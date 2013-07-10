package LDAPTools::Search::MT;

use MT::Logger::Log4perl qw( get_logger :resurrect l4mtdump );
use Data::Printer;

sub by_id {
    my ( $self, $arg ) = @_;
    $self->_load({ id => $arg });
}

sub by_name {
    my ( $self, $arg ) = @_;
    $self->_load({ nickname => { like => '%'.$arg.'%' }})
}

sub by_username {
    my ( $self, $arg ) = @_;
    $self->_load([
                    { name => lc($arg) } 
                        => -or =>
                    { name => ucfirst(lc($arg)) }
                ]);
}

sub titlecased {
    my $self = shift;
    my $User = MT->instance->model('user');
    my $iter = $User->load_iter();
    my @users;
    while ( my $user = $iter->() ) {
        push( @users, $user )
            if $user->name =~ m/^([:upper:]|\p{IsUpper})/;
    }
    get_logger()->info( scalar(@users)
                        ." users found in titlecased search" );
    return \@users;
}

sub _load {
    my ( $self, $terms ) = @_;
    my $User   = MT->instance->model('user');
    my $logger = get_logger();
    $logger->debug( "Database search terms: ", p($terms) );
    my @users  = $User->load( $terms );

    if ( ! scalar @users ) {
        my $error = $User->errstr // '';
        $error    = ": $error" if $error;
        $logger->warn( "Could not find user(s) in the MT database".$error );
    }
    elsif ( scalar @users > 1 ) {
        $logger->info( scalar(@users)." users found in search" );
    }

    return \@users;
}

1;