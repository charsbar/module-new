package Module::New::Test::Loader::Basic;

use strict;
use warnings;
use Test::Classy::Base;
use Module::New::Loader;

sub no_args : Tests(2) {
  my $class = shift;

  my $loader = Module::New::Loader->new;

  local $@;
  my $instance = eval { $loader->load( 'Loader' ) };
  ok !$@, $class->message('loaded successfully');
  warn $@ if $@;
  ok $instance->isa('Module::New::Loader'), $class->message('and the loaded class is as expected');
}

sub with_namespace : Tests(2) {
  my $class = shift;

  my $loader = Module::New::Loader->new('Module::New::ForTest');

  local $@;
  my $instance = eval { $loader->load( Sample => 'File' ) };
  ok !$@, $class->message('loaded successfully');
  warn $@ if $@;
  ok $instance->isa('Module::New::ForTest::Sample::File'), $class->message('and the loaded class is as expected');
}

sub fallback : Tests(2) {
  my $class = shift;

  my $loader = Module::New::Loader->new('Module::New::NotFound');

  local $@;
  my $instance = eval { $loader->load( 'Loader' ) };
  ok !$@, $class->message('loaded successfully');
  warn $@ if $@;
  ok $instance->isa('Module::New::Loader'), $class->message('and the loaded class is as expected');
}

1;
