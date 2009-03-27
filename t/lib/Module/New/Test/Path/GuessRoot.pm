package Module::New::Test::Path::GuessRoot;

use strict;
use warnings;
use Test::Classy::Base;
use Module::New;
use Module::New::Path;
use Path::Extended;

sub initialize { Module::New->setup('Module::New::ForTest'); }

sub default : Tests(2) {
  my $class = shift;

  my $path = Module::New::Path->new;

  my $root = eval { $path->guess_root; } || '';
  my $dir = dir('.');
  ok $dir->file('Makefile.PL')->exists, $class->message('Makefile.PL exists');
  ok $root eq $dir, $class->message('root is current dir');
}

sub look_for_makefile_pl : Tests(2) {
  my $class = shift;

  my $path = Module::New::Path->new;

  my $current = dir('.');
  my $testapp = dir('t/TestApp');
     $testapp->mkpath;
     $testapp->subdir('lib/foo')->mkpath;
     $testapp->file('Makefile.PL')->touch;
  ok $testapp->file('Makefile.PL')->exists, $class->message('Makefile.PL exists');

  chdir $testapp->subdir('lib/foo');

  my $root = eval { $path->guess_root; } || '';

  ok $root eq $testapp, $class->message('root is testapp');

  chdir $current;

  $testapp->remove;
}

sub look_for_build_pl : Tests(2) {
  my $class = shift;

  my $path = Module::New::Path->new;

  my $current = dir('.');
  my $testapp = dir('t/TestApp');
     $testapp->mkpath;
     $testapp->subdir('lib/foo')->mkpath;
     $testapp->file('Build.PL')->touch;
  ok $testapp->file('Build.PL')->exists, $class->message('Build.PL exists');

  chdir $testapp->subdir('lib/foo');

  my $root = eval { $path->guess_root; } || '';

  ok $root eq $testapp, $class->message('root is testapp');
  chdir $current;

  $testapp->remove;
}

sub not_found : Test {
  my $class = shift;

  my $path = Module::New::Path->new;

  my $current = dir('.');
  my $dir;
  foreach my $candidate (qw( / /tmp )) {
    $dir = dir($candidate);
    last if chdir $dir;
  }
  if ( $current eq $dir ) {
    return $class->skip_this_test('this test may be unstable for you')
  }

  local $@;
  eval { $path->guess_root; };

  ok $@ =~ /^Can't guess root/, $class->message("Can't guess root");

  chdir $current;
}

sub with_args : Tests(3) {
  my $class = shift;

  my $path = Module::New::Path->new;

  my $current = dir('.');
  my $testapp = dir('t/TestApp');
  ok !$testapp->exists, $class->message('testapp does not exist');

  local $@;
  my $root = eval { $path->guess_root('t/TestApp/'); } || '';

  ok $root eq $testapp, $class->message('root is testapp');
  ok $testapp->exists, $class->message('testapp exists');

  chdir $current;

  $testapp->remove;
}

1;
