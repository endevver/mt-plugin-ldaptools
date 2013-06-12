package TestsFor::LDAPTools::Compile;

use Test::More;
use Data::Printer;
use lib 'plugins/LDAPTools/lib';
use MT;

use_ok($_)
    for qw(
            LDAPTools
            Sub::Install
        );

my $app = MT->instance;
isa_ok( $app, 'MT' );

my $User     = MT->model('user');
my ( $user ) = $User->get_by_key({ name => 'testuser' });

isa_ok( $user, $User );

$user->password or $user->password('(None)');

$user->status( $user->status == 1 ? 2 : 1 );

is( $user->save(), 1, 'Saved user' )
    or diag( $user->errstr || $User->errstr );

done_testing();
