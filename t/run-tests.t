#!/usr/bin/env perl

use lib qw( lib extlib );
use Test::Class::Moose::Load 't/lib';

Test::Class::Moose->new({
    show_timing => 1,
    randomize   => 0,
    statistics  => 1,
    @ARGV ? (include_tags => \@ARGV) : (),
})->runtests;
