package Module::New::Test::Recipe::Dist;

use strict;
use warnings;
use Test::Classy::Base;
use Module::New;
use Path::Extended;

sub normal_run : Tests(9) {
  my $class = shift;

  my $current = dir('.');
  my $testapp = $class->setup_testapp;

  $class->test_recipe('MyApp');

  $class->test_files($testapp->subdir('MyApp'));

  chdir $current;
  $testapp->remove;
}

sub no_dirs : Tests(9) {
  my $class = shift;

  my $current = dir('.');
  my $testapp = $class->setup_testapp;

  Module::New->context->config->set( no_dirs => 1 );

  $class->test_recipe('MyApp');

  $class->test_files($testapp);

  chdir $current;
  $testapp->remove;
}

sub default_makemaker : Tests(3) {
  my $class = shift;

  my $current = dir('.');
  my $testapp = $class->setup_testapp;

  $class->test_recipe('MyApp');

  my $maker = $testapp->file('MyApp/Makefile.PL');
  ok $maker->exists, $class->message('Makefile.PL exists');
  ok $maker->grep('ExtUtils::MakeMaker'), $class->message('and it uses ExtUtils::MakeMaker');

  chdir $current;
  $testapp->remove;
}

sub makemaker : Tests(3) {
  my $class = shift;

  my $current = dir('.');
  my $testapp = $class->setup_testapp;

  Module::New->context->config->set( make => 'MakeMaker' );

  $class->test_recipe('MyApp');

  my $maker = $testapp->file('MyApp/Makefile.PL');
  ok $maker->exists, $class->message('Makefile.PL exists');
  ok $maker->grep('ExtUtils::MakeMaker'), $class->message('and it uses ExtUtils::MakeMaker');

  chdir $current;
  $testapp->remove;
}

sub module_build : Tests(3) {
  my $class = shift;

  my $current = dir('.');
  my $testapp = $class->setup_testapp;

  Module::New->context->config->set( make => 'ModuleBuild' );

  $class->test_recipe('MyApp');

  my $maker = $testapp->file('MyApp/Build.PL');
  ok $maker->exists, $class->message('Build.PL exists');
  ok $maker->grep('Module::Build'), $class->message('and it uses Module::Build');

  chdir $current;
  $testapp->remove;
}

sub module_install : Tests(3) {
  my $class = shift;

  my $current = dir('.');
  my $testapp = $class->setup_testapp;

  Module::New->context->config->set( make => 'ModuleInstall' );

  $class->test_recipe('MyApp');

  my $maker = $testapp->file('MyApp/Makefile.PL');
  ok $maker->exists, $class->message('Makefile.PL exists');
  ok $maker->grep('Module::Install'), $class->message('and it uses Module::Install');

  chdir $current;
  $testapp->remove;
}

sub xs : Tests(5) {
  my $class = shift;

  my $current = dir('.');
  my $testapp = $class->setup_testapp;

  Module::New->context->config->set( xs => 1 );

  $class->test_recipe('MyApp');

  ok $testapp->file('MyApp/MyApp.xs')->exists, $class->message('main .xs exists');
  ok $testapp->file('MyApp/MyApp.h')->exists, $class->message('main .h exists');
  SKIP: {
    eval { require Devel::PPPort };
    skip "requires Devel::PPPort", 1 if $@;
    ok $testapp->file('MyApp/ppport.h'), $class->message('ppport.h exists');
  }
  my $main_pm = $testapp->file('MyApp/lib/MyApp.pm')->slurp;
  like $main_pm => qr/XSLoader/, $class->message('MyApp.pm loads XSLoader');

  chdir $current;
  $testapp->remove;
}

sub setup_testapp {
  my ($class, $path) = @_;

  $path ||= 't/TestApp';

  my $testapp = dir($path);
     $testapp->mkpath;
     $testapp->subdir('MyApp')->remove;

  my $context = Module::New->setup('Module::New::ForTest');
  $context->path->set_root( $testapp->relative );
  $context->config->set( silent => 1 );

  return $testapp;
}

sub test_recipe {
  my ($class, @args) = @_;

  my $recipe = $class->load_recipe;
  local $@;
  eval { $recipe->run(@args) };
  ok !$@, $class->message('created a distribution');
  diag $@ if $@;
}

sub load_recipe {
  my $class = shift;

  delete $INC{'Module/New/Recipe/Dist.pm'};
  require Module::New::Recipe::Dist;
  return 'Module::New::Recipe::Dist';
}

sub test_files {
  my ($class, $root) = @_;

  ok $root->file('lib/MyApp.pm')->exists, $class->message('MyApp.pm exists');
  ok $root->file('README')->exists, $class->message('README exists');
  ok $root->file('Changes')->exists, $class->message('Changes exists');
  ok $root->file('MANIFEST')->exists, $class->message('MANIFEST exists');
  ok $root->file('MANIFEST.SKIP')->exists, $class->message('MANIFEST.SKIP exists');
  ok $root->file('t/00_load.t')->exists, $class->message('load test exists');
  ok $root->file('t/99_pod.t')->exists, $class->message('pod test exists');
  ok $root->file('t/99_podcoverage.t')->exists, $class->message('pod coverage test exists');

}

1;
