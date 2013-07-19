package MT::ObjectDiff;

use Moo;
use Sub::Quote;
use Data::Printer;
use Scalar::Util qw(blessed);

has 'a' => (
    is => 'rwp',
    isa => isa_mt_object(),
);

has 'b' => (
    is  => 'rwp',
    isa => isa_mt_object(),
);

has 'changes' => (
    is      => 'ro',
    builder => 1,
);

has 'are_identical' => (
    is      => 'ro',
    builder => 1,
    lazy => 1,
);

has 'are_different' => (
    is      => 'ro',
    builder => 1,
    lazy    => 1,
);

sub isa_mt_object {
    return quote_sub(q{
        use Scalar::Util qw(blessed);
        die "Not an MT::Object"
            unless blessed( $_[0] ) and $_[0]->isa('MT::Object');
    });
}

sub BUILDARGS {
    my ( $class, @args ) = @_;
    return ( scalar @args == 1 and ref $args[0] eq 'HASH' )
        ? shift @args : { a => shift @args, b => shift @args };
};


sub _build_changes {
    my $self = shift;
    die "No a object" unless $self->a;
    die "No b object" unless $self->b;
    return _diff_hashes( 
        $self->b->fetch_data,       # Fetches object values from database
        $self->a->column_values     # Current object's values
    );
}

sub _build_are_different {
    my $self = shift;
    return scalar keys %{$self->changes};
}

sub _build_are_identical {
    my $self = shift;
    return $self->are_different ? 0 : 1;
}

sub _diff_hashes {
    my ( $orig, $new ) = @_;
    my $changed;

    foreach my $col ( keys %{ { %$orig, %$new } } ) {
        my ($pre, $post) = map { $_->{$col} // '' } $orig, $new; # Force define!
        $changed->{$col} = [ $pre => $post ] unless $pre eq $post;
    }
    return $changed;
}

1;

__END__

package main;

use Data::Printer;

use MT;
use feature ':5.10';
my $app = MT->new();
my $obj = $app->model( 'user' )->load(1);
die unless $obj and $obj->isa('MT::Object');
my $orig = $obj->clone();
$obj->name('Woohooogie');
# my $obj = bless { ima => 'obj' }, 'MT::Object';
# my $orig = bless { ima => 'orig' }, 'MT::Object';
my $comp = MT::ObjectDiff->new( $obj, $orig );

say "Diff: ".$comp->are_different;
say "Identical: ".$comp->are_identical;
p $comp->changes;
p $comp;

# $comp->are_identical
# $comp->are_different
# $comp->a                # Same as \%a
# $comp->a->SOMEKEY       # Same as $a{SOMEKEY}
# $comp->b                # Same as \%b
# $comp->b->SOMEKEY       # Same as $b{SOMEKEY}
# $comp->changes          # Same as (%a, %b) but without unchanged keys/values
#                         # Essentially this: %hash = map { $_ => $b{$_ } grep { $a{$_}//'' ne $b{$_}//'' } keys %b
# foreach my $c ( $comp->changed ) {
#     $c->key
#     $c->value_a
#     $c->value_b
#     $c->values
# }
# 

# https://metacpan.org/module/Test::MockObject
# https://metacpan.org/module/Test::MockObject::Extra
# https://metacpan.org/module/Test::Mock::Recorder
# https://metacpan.org/module/Test::Mock::Guard
# https://metacpan.org/module/Moo
# https://metacpan.org/module/MooseX::MungeHas - munge your "has" (works with Moo, Moose and Mouse)
# https://metacpan.org/module/Data::Comparator
# https://metacpan.org/module/Data::Compare
# https://metacpan.org/module/Type::Tiny
# https://metacpan.org/module/Algorithm::Diff::Callback
# https://metacpan.org/module/Data::Perl - Base classes wrapping fundamental Perl data types.
# https://metacpan.org/module/Hash::Objectify - Create objects from hashes on the fly
# https://metacpan.org/module/Hash::AsObject - treat hashes as objects, with arbitrary accessors/mutators
# https://metacpan.org/module/Hash::Diff - Return difference between two hashes as a hash
# https://metacpan.org/module/Data::Diff - data structure comparison module

1;
