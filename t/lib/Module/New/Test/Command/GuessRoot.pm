package Module::New::Test::Command::GuessRoot;

use strict;
use warnings;
use Test::Classy::Base;
use Module::New;
use Path::Extended;

sub default : Test {
  my $class = shift;

  my $recipe = $class->load_recipe;

  my $current = dir('.');

  my $context = Module::New->setup('Module::New::ForTest');
  eval { $recipe->run; };
  ok !$@ && $context->path->_root eq dir('.'), $class->message('current is root');

  chdir $current;
}

sub with_option : Test {
  my $class = shift;

  my $recipe = $class->load_recipe;

  my $current = dir('.');
  my $testdir = dir('t');

  my $context = Module::New->setup('Module::New::ForTest');
     $context->config->set( root => $testdir );
  eval { $recipe->run; };
  ok !$@ && $context->path->_root eq $testdir, $class->message('t/ is root');

  chdir $current;
}

sub load_recipe {
  delete $INC{'Module/New/ForTest/Recipe/GuessRoot.pm'};
  require Module::New::ForTest::Recipe::GuessRoot;
  return 'Module::New::ForTest::Recipe::GuessRoot';
}

1;