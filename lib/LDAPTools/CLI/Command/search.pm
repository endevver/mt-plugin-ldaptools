package LDAPTools::CLI::Command::search;
use LDAPTools::CLI -command;
use strict; use warnings;

use MT::Logger::Log4perl qw( get_logger :resurrect l4mtdump );
use Data::Printer;
use Data::Dumper;

sub abstract { "Search for users in LDAP and the MT database\n" }

sub description { return 'Abstract: ' . (shift)->abstract }

sub options {
    my ( $class, $app ) = @_;
    return (
        [
            'field' => 'hidden',
            {
                one_of => [
                      [ 'id=i'          => "load by MT user ID" ],
                      [ 'username|un=s' => "load by MT username (case-insensitive)" ],
                      [ 'name|dn=s'     => "load user(s) matching MT display name"  ],
                ],
            } 
        ],
        [],
        [ 'titlecased'    => 'return only users with title-cased usernames'  ],
        [ 'disabled'      => 'return only disabled users'                    ],
        [ 'ldap!'         => 'return only users with/without an LDAP record' ],
        [ 'count'         => 'only show a count of matching users'           ],
        $class->global_options($app),
    );
}


sub validate_args {
    my ($self, $opt, $args) = @_;
    $self->SUPER::validate_args( $opt, $args );
}

sub execute {
    my ($self, $opt, $args) = @_;

    p $opt;

    my $mt = $self->init_mt( $opt->{cfg} );

    my $users = $self->mt_user_search( $opt );
    @$users   = map { { mt => $_ } } @$users;

    if ( $opt->{count} ) {
        printf "%d users found matching search criteria\n", scalar(@$users);
    }
    elsif ( ! @$users ) {
        return $self->ldap_search( $opt, [] );
    }
    else {
        foreach my $u ( @$users ) {
            p $u->{mt}->column_values;
            $self->ldap_search( $opt, [$u] );
        }
    }
    return $users;   
}


sub mt_user_search {
    my ( $class, $opt ) = @_;
    require LDAPTools::Search::MT;
    # my $search = LDAPTools::Search::MT->new();
    my $search = 'LDAPTools::Search::MT';
    return $opt->{id}         ? $search->by_id( $opt->{id} )
         : $opt->{name}       ? $search->by_name( $opt->{name} )
         : $opt->{username}   ? $search->by_username( $opt->{username} )
         : $opt->{titlecased} ? $search->filtered_search( $opt )
         : $opt->{disabled}   ? $search->filtered_search( $opt )
                              : die "No search criteria specified";
}

sub ldap_search {
    my ( $class, $opt, $users ) = @_;

    return if ( $opt->{id} || $opt->{titlecased} || $opt->{disabled} ) && ! @$users;

    require LDAPTools::Search::LDAP;
    if ( @$users ) {
        foreach my $u ( @$users ) {
            my $search = LDAPTools::Search::LDAP->new();
            if ( my $entry  = $search->by_user($u->{mt}) ) {
                $entry->dump;
                $u->{ldap} = $entry;
            }
        }
    }
    else {
        my $search = LDAPTools::Search::LDAP->new();
        my $entry = $opt->{name}     ? $search->by_name( $opt->{name} )
                  : $opt->{username} ? $search->by_username( $opt->{username} )
                                       : undef;
        if ( $entry ) {
            $entry->dump;
            $users->[0]{ldap} = $entry;
        }
    }
    return $users;
}

1;

__END__
