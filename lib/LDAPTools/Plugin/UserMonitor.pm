package LDAPTools::Plugin::UserMonitor;

use strict;
use warnings;

use MT::Author qw( ACTIVE INACTIVE COMMENTER );

use MT::Logger::Log4perl qw( get_logger :resurrect l4mtdump );
use Data::Printer;
use POSIX;

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
    return $search->by_username( ref($obj) ? $obj->name : $obj );
}

sub report {
    my ( $self, $changes, $obj, $orig ) = @_;
    my $utype          = $obj->type eq COMMENTER ? 'Commenter' : 'Author';
    my $status         = $changes->{status} || [];
    my $uname          = $changes->{name}   || [];
    my @uname_cmd      = POSIX::uname();
    my $host           = $uname_cmd[1];
    my $subject        = 'User modification report for ' . $obj->name . " ($host)";
    my ( $ldap_entry ) = __PACKAGE__->find_ldap_record( $obj );
    $ldap_entry      ||= __PACKAGE__->find_ldap_record( $changes->{name}[0] )
        if $changes->{name};

    my @msgs = (
        sprintf(  "## User record alert for %s '%s' (ID:%d, Auth:%s):\n",
                    $utype, $obj->name, $obj->id, $obj->auth_type           ),
        ( @$status ? "* User's MT record is being disabled"          : () ),
        ( @$uname  ? "* Username change from ".join(' to ', @$uname) : () ),
        "\n----\n",
    );

    push( @msgs, "## LDAP record for ".$obj->name."\n" );
    if ( $ldap_entry ) {
        require IO::String;
        my $iostr = IO::String->new;
        $ldap_entry->dump( $iostr );
        push( @msgs, "@@@", ${$iostr->string_ref}, "@@@" );
    }
    else { push( @msgs, 'No LDAP entry for '.$obj->name."\n" ) }

    push( @msgs,
        "\n----\n",
        "## MT Author record\n",
        "@@@",
        "Changes: "                . p( $changes ),
        "\nOriginal object data: " . p( $orig    ),
        "@@@",
        "\n----\n",
        "## Stack Trace\n",
        "@@@",
        "Triggered at ".Carp::longmess(),
        "@@@",
        qq(\n[tagged:ldaptools-alert tagged:log4mt responsible:"Jay Allen" milestone:"Log Data"])
    );

    get_logger('mtmail')->warn(
        subject => $subject,
        message => join( "\n", @msgs ),
    );
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

# say 'TRYING ONE';
# my $orig = $obj->clone();
# LDAPTools::Plugin::UserMonitor->pre_save_author( $obj, $orig );

# say 'Status change to inactive';
# $obj->status( INACTIVE() );
# my $orig = $obj->clone();
# LDAPTools::Plugin::UserMonitor->pre_save_author( $obj, $orig );

# say 'Status change to active';
# $obj->status( ACTIVE() );
# my $orig = $obj->clone();
# LDAPTools::Plugin::UserMonitor->pre_save_author( $obj, $orig );

# say 'Username change to active';
# $obj->name( 'flllauha' );
# my $orig = $obj->clone();
# LDAPTools::Plugin::UserMonitor->pre_save_author( $obj, $orig );

1;

