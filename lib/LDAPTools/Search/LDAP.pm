package LDAPTools::Search::LDAP;

use MT::Logger::Log4perl qw( get_logger :resurrect l4mtdump );
use Data::Printer;
use parent qw( MT::LDAP );

sub by_user {
    my ( $self, $user ) = @_;
    my $entry = $self->by_username( lc $user->name )
             || $self->by_name( $user->nickname );
    return $entry;
}

sub by_id { die 'Not implemented' }

sub by_name {
    my ( $self, $arg ) = @_;
    my $entry = $self->get_entry_by_name( $arg, ['*'] );
    $entry or $self->_no_user_warning( $arg );
    return $entry;
}

sub by_username {
    my ( $self, $arg ) = @_;
    my $entry = $self->get_entry_by_uuid( $arg, ['*'] );
    $entry or $self->_no_user_warning( $arg );
    return $entry;
}

sub _no_user_warning {
    get_logger()->warn("No LDAP user record found matching $_[1]");
}

1;