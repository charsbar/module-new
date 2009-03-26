package Module::New::Test::Recipe::File;

use strict;
use warnings;
use Test::Classy::Base;
use Module::New;
use Path::Extended;

sub normal_run : Tests(3) {
  my $class = shift;

  my $current = dir('.');
  my $testapp = $class->setup_testapp;

  $class->run_recipe('MyApp::File');

  ok $testapp->file('MANIFEST')->exists, $class->message('MANIFEST is created');
  ok $testapp->file('lib/MyApp/File.pm')->exists, $class->message('and the file is correct');

  chdir $current;
  $testapp->remove;
}

sub file_in_subdir : Tests(4) {
  my $class = shift;

  my $current = dir('.');
  my $testapp = $class->setup_testapp;

  Module::New->context->config->set( subdir => 't' );

  $class->run_recipe('MyApp::File');

  ok $testapp->file('MANIFEST')->exists, $class->message('MANIFEST is created');
  ok $testapp->file('MANIFEST')->exists, $class->message('MANIFEST is created');
  ok !$testapp->file('t/MANIFEST')->exists, $class->message('MANIFEST is not in t/');

  chdir $current;
  $testapp->remove;
}

sub testfile : Tests(4) {
  my $class = shift;

  my $current = dir('.');
  my $testapp = $class->setup_testapp;

  $class->run_recipe('t/test.t');

  ok $testapp->file('MANIFEST')->exists, $class->message('MANIFEST is created');
  ok $testapp->file('t/test.t')->exists, $class->message('and the file is correct');
  ok $testapp->file('t/test.t')->grep('use Test::More'), $class->message('and its content has "use Test::More"');

  chdir $current;
  $testapp->remove;
}

sub script : Tests(4) {
  my $class = shift;

  my $current = dir('.');
  my $testapp = $class->setup_testapp;

  $class->run_recipe('bin/script');

  ok $testapp->file('MANIFEST')->exists, $class->message('MANIFEST is created');
  ok $testapp->file('bin/script')->exists, $class->message('and the file is correct');
  ok $testapp->file('bin/script')->grep('#!perl'), $class->message('and its content has a shebang line');

  chdir $current;
  $testapp->remove;
}

sub setup_testapp {
  my ($class, $path) = @_;

  $path ||= 't/TestApp';

  my $testapp = dir($path);
     $testapp->mkpath;
     $testapp->file('Makefile.PL')->touch;
     $testapp->subdir('lib')->mkpath;

  my $context = Module::New->setup('Module::New::ForTest');
  $context->path->set_root( $testapp->relative );
  $context->config->set( silent => 1 );

  return $testapp;
}

sub run_recipe {
  my ($class, @args) = @_;

  my $recipe = $class->load_recipe;
  local $@;
  eval { $recipe->run(@args) };
  ok !$@, $class->message('created a file');

  if ($@) {
    warn $@;
    Module::New->context->dump_logs;
  }
}

sub load_recipe {
  my $class = shift;

  delete $INC{'Module/New/Recipe/File.pm'};
  require Module::New::Recipe::File;
  return 'Module::New::Recipe::File';
}

1;
