package TestsFor::LDAPTools::CLI::Command::search;

use Test::Class::Moose;
use LDAPTools::CLI -command;
use strict; use warnings;

use MT::Logger::Log4perl qw( get_logger :resurrect l4mtdump );
use Data::Printer;
use Data::Dumper;

sub test_abstract {
    my ( $test, $report ) = @_;
    # "Search for users in LDAP and the MT database\n"
}

sub test_description {
    my ( $test, $report ) = @_;
    # return 'Abstract: ' . (shift)->abstract
}

sub test_options {
    my ( $test, $report ) = @_;
    # my ( $class, $app ) = @_;
    # return (
    #     [ 'field' => 'hidden' => {
    #         one_of => [
    #             [ 'id=i'          => "load by MT user ID" ],
    #             [ 'username|un=s' => "load by MT username (case-insensitive)"],
    #             [ 'name|dn=s'     => "load user(s) matching MT display name" ],
    #             [ 'titlecased'    => "load users with title-cased username"  ],
    #         ]
    #     } ],
    #     $class->global_options($app),
    # );
}


sub test_validate_args {
    my ( $test, $report ) = @_;
    # my ($self, $opt, $args) = @_;
    # $self->SUPER::validate_args( $opt, $args );
}

sub test_execute {
    my ( $test, $report ) = @_;
    # my ($self, $opt, $args) = @_;
    # 
    # my $mt = $self->init_mt( $opt->{cfg} );
    # 
    # my $users = $self->mt_user_search( $opt );
    # @$users   = map { { mt => $_ } } @$users;
    # 
    # $self->ldap_search( $opt, $users );
    # 
    # return $users;
}


sub test_mt_user_search {
    my ( $test, $report ) = @_;
    # my ( $class, $opt ) = @_;
    # require LDAPTools::Search::MT;
    # # my $search = LDAPTools::Search::MT->new();
    # my $search = 'LDAPTools::Search::MT';
    # return $opt->{titlecased} ? $search->titlecased()
    #      : $opt->{id}         ? $search->by_id( $opt->{id} )
    #      : $opt->{name}       ? $search->by_name( $opt->{name} )
    #      : $opt->{username}   ? $search->by_username( $opt->{username} )
    #                           : die "No search criteria specified";
}

sub test_ldap_search {
    my ( $test, $report ) = @_;
    # my ( $class, $opt, $users ) = @_;
    # 
    # return if ($opt->{id} || $opt->{titlecased} and ! @$users);
    # 
    # require LDAPTools::Search::LDAP;
    # if ( @$users ) {
    #     foreach my $u ( @$users ) {
    #         my $search = LDAPTools::Search::LDAP->new();
    #         if ( my $entry  = $search->by_user($u->{mt}) ) {
    #             $entry->dump;
    #             $u->{ldap} = $entry;
    #         }
    #     }
    # }
    # else {
    #     my $search = LDAPTools::Search::LDAP->new();
    #     my $entry = $opt->{name}     ? $search->by_name( $opt->{name} )
    #               : $opt->{username} ? $search->by_username( $opt->{username} )
    #                                    : undef;
    #     if ( $entry ) {
    #         $entry->dump;
    #         $users->[0]{ldap} = $entry;
    #     }
    # }
    # return $users;
}

1;

__END__
