package TestsFor::LDAPTools::Search::LDAP;

use Test::Class::Moose;
use MT::Logger::Log4perl qw( get_logger :resurrect l4mtdump );
use Data::Printer;
use parent qw( MT::LDAP );

sub test_by_user  : Tags( ldap public ) {
    my ( $test, $report ) = @_;
    # my ( $self, $user ) = @_;
    # my $entry = $self->by_username( lc $user->name )
    #          || $self->by_name( $user->nickname );
    # return $entry;
}

sub test_by_id  : Tags( ldap public ) {
    my ( $test, $report ) = @_;
    # die 'Not implemented'
}

sub test_by_name  : Tags( ldap public ) {
    my ( $test, $report ) = @_;
    # my ( $self, $arg ) = @_;
    # my $entry = $self->get_entry_by_name( $arg, ['*'] );
    # $entry or $self->_no_user_warning( $arg );
    # return $entry;
}

sub test_by_username  : Tags( ldap public ) {
    my ( $test, $report ) = @_;
    # my ( $self, $arg ) = @_;
    # my $entry = $self->get_entry_by_uuid( $arg, ['*'] );
    # $entry or $self->_no_user_warning( $arg );
    # return $entry;
}

sub test__no_user_warning  : Tags( ldap private ) {
    my ( $test, $report ) = @_;
    # get_logger()->warn("No LDAP user record found matching $_[1]");
}

1;