package LDAPTools::CLI::Command::fix;
# use LDAPTools::CLI -command;  Nope. See use parent below
use strict; use warnings;

use parent qw( LDAPTools::CLI::Command::search );

sub options {
    my ( $class, $app ) = @_;
    return (
        [ 'field' => 'hidden' => {
            one_of => [
                [ 'id=i'          => "load by MT user ID" ],
                [ 'username|un=s' => "load by MT username (case-insensitive)" ],
            ]
        } ],
        $class->global_options($app),
    );
}

sub validate_args {
    my ($self, $opt, $args) = @_;
    $self->SUPER::validate_args( $opt, $args );
}

sub abstract { 'Find and fix title-cased usernames and user status' }

sub description {
    return qq(Performs the "search" command and, assuming only one user\n)
         . qq(was found, fixes the user's MT username case and user status\n\n)
         . qq(IMPORTANT: You should run $0 search [OPTIONS] first to make\n)
         . qq(sure you'll be acting on the correct user\n);
}

sub execute {
    my $self           = shift;
    my ( $opt, $args ) = @_;

    my $users = $self->SUPER::execute(@_);

    unless ( @$users == 1 ) {
        print STDERR 'Aborting username case/status fix because '
                   . ( @$users > 1 ? 'multiple users were ' : 'no user was ' )
                   . 'found';
        return $users;
    }

    my $user = $users->[0];
    my $umt  = $user->{mt};
    printf "\n".'Resolving username case and user status (name=%s, status=%d): ', 
            $umt->name, $umt->status;

    $umt->name( lc( $umt->name ) );
    $umt->status( $umt->ACTIVE() )
        if $umt->status == $umt->INACTIVE();
    $umt->save
        or die "Could not save user record: ".$umt->errstr;

    printf "DONE (name=%s, status=%d)\n", $umt->name, $umt->status;

    $user;
}

1;
