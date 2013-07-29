package TestsFor::LDAPTools::Plugin;

use Test::Class::Moose;
use MT::Author qw( ACTIVE COMMENTER );

use MT::Logger::Log4perl qw( get_logger :resurrect l4mtdump );
###l4p my $logger ||= get_logger;

sub test_pre_save_author  : Tags( plugin ) {
    my ( $test, $report ) = @_;
    # my ( $cb, $obj, $orig_obj ) = @_;
   # 
   #  # Only perform the following checks on previously saved objects
   #  return unless $obj->id;
   # 
   #  # Create hashrefs of old, new and changed values
   #  my $orig    = $orig_obj->fetch_data;  # Fetches fresh from database
   #  my $new     = $obj->column_values;
   #  my $changed = _diff_hashes( $orig, $new );
   # 
   #  # Continue ONLY if we have a username change or a deactivation
   #  return unless   $changed->{name}
   #             || ( $changed->{status} and $orig->{status} eq ACTIVE() ); 
   # 
   # 
   # ###l4p $logger ||= get_logger(); $logger->trace();
   # 
   #  require LDAPTools;
   #  my $ldaptool = LDAPTools->new(
   #      log_level  => 'debug',
   #      log_output => \*STDERR,
   #  );
   # 
   #  $logger->warn(sprintf(
   #      "%s '%s' (ID:%d, Auth:%s) is being %s at %s",
   #      ( $obj->type eq COMMENTER ? 'Commenter' : 'Author' ),
   #      $orig->{name},
   #      $obj->id,
   #      $obj->auth_type,
   #      join(' and ',
   #          ( $changed->{status} ? "deactivated"                     : () ),
   #          ( $changed->{name}   ? 'saved with new name '.$obj->name : () ),
   #      ),
   #      Carp::longmess(),
   #  ));
   # 
   #  $logger->debug( "Original object data:" .p( $orig ) );
   #  $logger->debug( "New object data:"      .p( $obj  ) );
   # 
   #  my ( $ldap, $dn, $ldap_entries ) =  $ldaptool->search( $obj->name );
}

sub test__diff_hashes  : Tags( plugin util ) {
    my ( $test, $report ) = @_;
    # my ( $orig, $new ) = @_;
    # my $changed;
    # 
    # foreach my $col ( keys %{ { %$orig, %$new } } ) {
    #     my ($pre, $post) = map { $_->{$col} // '' } $orig, $new; # Force define!
    #     $changed->{$col} = [ $pre => $post ] unless $pre eq $post;
    # }
    # return $changed;
}

1;