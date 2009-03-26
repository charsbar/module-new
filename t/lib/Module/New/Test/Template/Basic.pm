package Module::New::Test::Template::Basic;

use strict;
use warnings;
use Test::Classy::Base;
use Module::New::Template;
use Module::New;

sub initialize { Module::New->setup('Module::New::ForTest') }

sub simple_interpolate : Test {
  my $class = shift;

  Module::New->context->config->set( name => 'foo' );

  my $text = Module::New::Template->render('my name is <%= $c->config("name") %>');

  ok $text eq 'my name is foo', $class->message('<%= %> works');
}

sub no_interpolate : Test {
  my $class = shift;

  Module::New->context->config->set( name => 'bar' );

  my $text = Module::New::Template->render('my name is foo');

  ok $text eq 'my name is foo', $class->message;
}

1;
