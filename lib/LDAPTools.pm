package LDAPTools;

use strict;
use warnings;
use Data::Printer;
use Sub::Install;
use Carp qw( cluck );

sub pre_save_author {
    my ($cb, $obj, $orig_obj) = @_;
    return unless $obj->id;

    my $db_data = $orig_obj->fetch_data();
    my ( $old_name, $name     ) = ( $db_data->{name},   $obj->name   );
    my ( $old_status, $status ) = ( $db_data->{status}, $obj->status );
    return unless
           ( $name ne $old_name )                # username change
        || (    $status       == $obj->INACTIVE  # Deactivation
             && $old_status   == $obj->ACTIVE );
    cluck "User object being saved with name or status change";
    my $compare = {
        status     => $status,
        old_status => $old_status,
        name       => $name,
        old_name   => $old_name
    };
    p $compare;
    warn "Showing original object data:\n";
    p $db_data;
    warn "Showing new object:\n";
    p $obj;

    my ( $ldap, $dn, $ldap_entries ) = __PACKAGE__->ldap_search( $obj->name );

    p $dn;
    p $ldap_entries;
}

sub mt_user_search {
    my ( $class, $opt ) = @_;
    my $User = MT->instance->model('user');

    my @users = ();

    if ( $opt->{titlecased} ) {
        my $iter = $User->load_iter();
        while ( my $user = $iter->() ) {
            next unless $user->name =~ m/^[A-Z]/;
            push @users, $user;
        }
        warn scalar( @users )." users found in titlecased search\n";
        return [ @users ];
    }
    
    my $terms
        = $opt->{id}        ? { id => $opt->{id} }
        : $opt->{name}      ? { nickname => { like => '%'.$opt->{name}.'%' }}
        : $opt->{username}  ? [
                                  { name => lc($opt->{username}) } 
                                  => -or =>
                                  { name => ucfirst(lc($opt->{username})) }
                              ]
                            : die "No search criteria specified";

    @users = $User->load( $terms );

    if ( ! @users ) {
        warn "Could not find user(s) in the MT database: ".$User->errstr;
        print STDERR "Database search terms: ".Dumper($terms)
            if $opt->{verbose};
    }
    elsif ( @users > 1 ) {
        warn scalar( @users )." users found in search\n";
    }

    return [ @users ];
}


sub ldap_search {
    my ( $class, $uid ) = @_;
    require MT::LDAP;
    return unless $uid;

    $uid = lc $uid;

    my $ldap = MT::LDAP->new
        or die "Loading MT::LDAP failed: ". MT::LDAP->errstr;

    my $dn   = $ldap->get_dn( $uid )
        or die "LDAP error: ".$ldap->errstr;

    my $ldap_entries = $ldap->search_ldap( filter => "(uid=$uid)" );

    unless ( $ldap_entries && @$ldap_entries ) {
        warn "No entries found in LDAP for uid=$uid.\n";
        print Dumper($dn);
    }

    return ( $ldap, $dn, $ldap_entries );
}


1;