package TestsFor::LDAPTools::Search::MT;

use Test::Class::Moose;
use MT::Logger::Log4perl qw( get_logger :resurrect l4mtdump );
use Data::Printer;

sub test_by_id  : Tags( mt public ) {
    my ( $test, $report ) = @_;
    my $class = $test−>test_class;
    isa( $class->by_id(1),   'MT::Author' );
    is(  $class->by_id(999999), undef        );
}

sub test_by_name  : Tags( mt public ) {
    my ( $test, $report ) = @_;
    isa( scalar $self->by_name('GoodName'), 'MT::Author' );
    # my ( $self, $arg ) = @_;
    # $self->_load({ nickname => { like => '%'.$arg.'%' }})
}

sub test_by_username  : Tags( mt public ) {
    my ( $test, $report ) = @_;
    isa( scalar $self->by_username('jay'), 'MT:Author' );
    isa( scalar $self->by_username('Jay'), 'MT:Author' );
    isa( scalar $self->by_username('JAY'), 'MT:Author' );
    is( scalar $self->by_username('NoSuchUser'), undef );
    # my ( $self, $arg ) = @_;
    # $self->_load([
    #                 { name => lc($arg) } 
    #                     => -or =>
    #                 { name => ucfirst(lc($arg)) }
    #             ]);
}

sub test_titlecased  : Tags( mt public ) {
    my ( $test, $report ) = @_;
    # my $self = shift;
    # my $User = MT->instance->model('user');
    # my $iter = $User->load_iter();
    # my @users;
    # while ( my $user = $iter->() ) {
    #     push( @users, $user )
    #         if $user->name =~ m/^([:upper:]|\p{IsUpper})/;
    # }
    # get_logger()->info( scalar(@users)
    #                     ." users found in titlecased search" );
    # return \@users;
}

sub test__load  : Tags( mt private ) {{
    my ( $test, $report ) = @_;
    # my ( $self, $terms ) = @_;
    # my $User   = MT->instance->model('user');
    # my $logger = get_logger();
    # $logger->debug( "Database search terms: ", p($terms) );
    # my @users  = $User->load( $terms );
    # 
    # if ( ! scalar @users ) {
    #     my $error = $User->errstr // '';
    #     $error    = ": $error" if $error;
    #     $logger->warn( "Could not find user(s) in the MT database".$error );
    # }
    # elsif ( scalar @users > 1 ) {
    #     $logger->info( scalar(@users)." users found in search" );
    # }
    # 
    # return \@users;
}

1;