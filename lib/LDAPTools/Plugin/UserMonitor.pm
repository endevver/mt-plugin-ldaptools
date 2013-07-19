package LDAPTools::Plugin::UserMonitor;

use strict;
use warnings;

use MT::Author qw( ACTIVE INACTIVE COMMENTER );

use MT::Logger::Log4perl qw( get_logger :resurrect l4mtdump );
use Data::Printer;

sub pre_save_author {
    my ( $cb, $obj, $orig ) = @_;

    # Short-circuit on unsaved objects
    return unless $orig and $obj->id;

    require MT::ObjectDiff;
    my $diff    = MT::ObjectDiff->new( $obj, $orig );
    my $changes = $diff->changes;

    # Short-circuit unless we have a username change or a deactivation
    return unless   $changes->{name}
               || ( $changes->{status} and $changes->{status}[0] == ACTIVE() ); 

    __PACKAGE__->report( $changes, $obj, $orig );
}

sub find_ldap_record {
    my ( $self, $obj ) = @_;
    require LDAPTools::Search::LDAP;
    my $search = LDAPTools::Search::LDAP->new();
    return $search->by_username( $obj->name );
}

sub report {
    my ( $self, $changes, $obj, $orig ) = @_;

    my @msgs = ( 'User modification report for '
                . $obj->name
                . ' '
                . Carp::longmess() );

    my $utype  = $obj->type eq COMMENTER ? 'Commenter' : 'Author';
    my $status = $changes->{status} || [];
    my $uname  = $changes->{name}   || [];

    push( @msgs,
        sprintf(  "User record alert for %s '%s' (ID:%d, Auth:%s):\n\n",
                    $utype, $obj->name, $obj->id, $obj->auth_type           ),
        ( @$status ? "\t* User's MT record is being disabled"          : () ),
        ( @$uname  ? "\t* Username change from ".join(' to ', @$uname) : () ),
    );

    my ( $ldap_entry ) = __PACKAGE__->find_ldap_record( $obj )
                      || __PACKAGE__->find_ldap_record( $orig );
    if ( $ldap_entry ) {
        use IO::String;
        my $iostr = IO::String->new;
        $ldap_entry->dump( $iostr );
        push( @msgs, 'LDAP entry for '.$obj->name,
                     ${$iostr->string_ref} );
    }
    else {
        push( @msgs, 'No LDAP entry for '.$obj->name );
    }

    push( @msgs, 'Changes: '. p( $changes ),
                 'Original object data: '. p( $orig ) );

    my $logger = get_logger();
    $logger->warn($_) for @msgs
}

1;

__END__

package main;

use Data::Printer;
use MT::Author qw( ACTIVE INACTIVE COMMENTER );

use MT;
use feature ':5.10';
my $app = MT->new();
my $obj = $app->model( 'user' )->load({ name => 'genetestone' });
die unless $obj and $obj->isa('MT::Object');
$obj->status( INACTIVE() );
my $orig = $obj->clone();

LDAPTools::Plugin::UserMonitor->pre_save_author( $obj, $orig );



1;
