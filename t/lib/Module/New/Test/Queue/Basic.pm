package Module::New::Test::Queue::Basic;

use strict;
use warnings;
use Test::Classy::Base;
use Module::New::Queue;

sub items_in_queue_are {
  my ($class, $expected) = @_;

  my $number_in_queue = scalar Module::New::Queue->queue;
  ok $number_in_queue == $expected,
     $class->message("$number_in_queue items are queued");
}

sub joined_string_is {
  my ($class, $expected) = @_;

  my $string = join ', ', map { $_->() } Module::New::Queue->queue;
  ok $string eq $expected,
     $class->message("and the order is right: $string");
}

sub basic : Tests(2) {
  my $class = shift;

  Module::New::Queue->clear;
  Module::New::Queue->register(sub { "first" });
  Module::New::Queue->register(sub { "second" });
  Module::New::Queue->register(sub { "third" });

  $class->items_in_queue_are(3);
  $class->joined_string_is('first, second, third');
}

sub localized : Tests(4) {
  my $class = shift;

  Module::New::Queue->clear;
  Module::New::Queue->register(sub { "first" });
  Module::New::Queue->register(sub { "second" });
  Module::New::Queue->localize(sub {
    Module::New::Queue->register(sub { "local first" });
    Module::New::Queue->register(sub { "local second" });

    $class->items_in_queue_are(2);
    $class->joined_string_is('local first, local second');
  });
  Module::New::Queue->register(sub { "third" });

  $class->items_in_queue_are(3);
  $class->joined_string_is('first, second, third');
}

1;
