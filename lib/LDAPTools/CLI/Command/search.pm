package LDAPTools::CLI::Command::search;
use LDAPTools::CLI -command;
use strict; use warnings;

use Data::Dumper;

sub abstract { "Search for users in LDAP and the MT database\n" }

sub description { return (shift)->abstract }

sub options {
    my ( $class, $app ) = @_;
    return (
        [ 'field' => 'hidden' => {
            one_of => [
                [ 'id=i'          => "load by MT user ID" ],
                [ 'username|un=s' => "load by MT username (case-insensitive)"],
                [ 'name|dn=s'     => "load user(s) matching MT display name" ],
                [ 'titlecased'    => "load users with title-cased username"  ],
            ]
        } ],
        $class->global_options($app),
    );
}

sub execute {
    my ($self, $opt, $args) = @_;

    my $mt    = $self->init_mt( $opt->{cfg} );
    my $users = $self->mt_user_search( $opt );

    foreach my $u ( @$users ) {
        print "mt_user: ".Dumper($u);
        my ( $ldap, $dn, $ldap_entries ) = $self->ldap_search( $u->name );
        if ( $ldap_entries && @$ldap_entries ) {
            print 'ldap_dn: '.Dumper( $dn );
            print "ldap_entries:\n";
            $_->dump foreach @$ldap_entries;
        }
    }
    return $users;
}


sub mt_user_search {
    shift;
    require LDAPTools;
    LDAPTools->mt_user_search(@_);
}

sub ldap_search {
    shift;
    require LDAPTools;
    LDAPTools->ldap_search(@_);
}

1;

__END__
