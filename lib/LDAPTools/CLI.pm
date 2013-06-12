package LDAPTools::CLI;

use App::Cmd::Setup -app;

1;


__END__

######################################################################
#print Dumper($_->attributes) for @$ldap_entries;

my $attrs = {
   cn                           => 'cn',
   LDAPUserFullNameAttribute    => $mt->config->LDAPUserFullNameAttribute || '',
   LDAPUserEmailAttribute       => $mt->config->LDAPUserEmailAttribute || '',
   LDAPGroupFullNameAttribute   => $mt->config->LDAPGroupFullNameAttribute || '',
   LDAPGroupNameAttribute       => $mt->config->LDAPGroupNameAttribute || '',
   LDAPGroupIdAttribute         => $mt->config->LDAPGroupIdAttribute || '',
   LDAPGroupMemberAttribute     => $mt->config->LDAPGroupMemberAttribute || '',
   LDAPGroupSearchBase          => $mt->config->LDAPGroupSearchBase || '',
   LDAPGroupFilter              => $mt->config->LDAPGroupFilter || '',
   LDAPUserIdAttribute          => $mt->config->LDAPUserIdAttribute || '',
   LDAPUserFullNameAttribute    => $mt->config->LDAPUserFullNameAttribute || '',
   LDAPUserGroupMemberAttribute => $mt->config->LDAPUserGroupMemberAttribute || '',
};
