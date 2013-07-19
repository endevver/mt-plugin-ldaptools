# THIS PACKAGE IS NO LONGER IN USE
# 
# package LDAPTools;
# 
# use strict;
# use warnings;
# use Sub::Install;
# use Try::Tiny;
# use Carp;
# use MT::Author qw( ACTIVE INACTIVE AUTHOR COMMENTER );
# use Data::Printer {
#     colored      => 0,
#     sort_keys    => 1,
#     return_value => 'dump',
#     caller_info  => 1,
#     alias        => 'Dumper',
# };
# 
# use MT::Logger::Log4perl qw( get_logger :resurrect l4mtdump );
# ###l4p my $logger ||= get_logger;
# 
# # use Role::Tiny::With;
# #     with 'MT::Role::Logger';
# 
# sub search {
#     my ( $class, $uid ) = @_;
#     return unless $uid;
#     ###l4p $logger ||= get_logger(); $logger->trace();
# 
#     $uid = lc $uid;
# 
#     $logger->info( "Looking for LDAP entries with uid=$uid." );
# 
#     my ( $ldap, $dn, $ldap_entries );
# 
#     try {
#         require MT::LDAP;
#         $ldap = MT::LDAP->new
#             or die "Instantiating MT::LDAP failed: ". MT::LDAP->errstr;
# 
#         $dn = $ldap->get_dn( $uid )
#             or die "LDAP could not get_dn for $uid: ".$ldap->errstr;
#         $logger->debug( "LDAP distinguished name:\n", p( $dn ));
# 
#         $ldap_entries = $ldap->search_ldap( filter => "(uid=$uid)" ) || [];
# 
#         $logger->debug( "Matching LDAP entries:\n",   p( $ldap_entries ));
#         # $_->dump( \*STDERR ) foreach @$ldap_entries;
#     }
#     catch {
#         $logger->error( 'LDAP error: '.$_ );
#     }
# 
#     $logger->info( scalar( @$ldap_entries )
#                 . "items retrived from LDAP for for uid=$uid" );
# 
#     return ( $ldap, $dn, $ldap_entries );
# }
# 
# sub ldap_search { (shift)->search(@_); }
# 
# 
# 1;
