package LDAPTools::CLI::Command;
use App::Cmd::Setup -command;
use strict; use warnings;

sub usage_desc { "%c COMMAND %o" }

sub global_options {
    my ( $class, $app ) = @_;
    return (
        [ 'help|h'      => "this usage screen" ],
        [ "verbose|v" => "verbose output"    ],
    );
}

sub opt_spec { # ( $class, $app )
    return (shift)->options( +shift );
}

sub init_mt {
    my ($self, $cfg) = @_;
    require MT;
    my $mt = MT->new(defined $cfg ? (Config => $cfg) : ())
        or die MT->errstr;
    $mt;
}

1;