use strict;
use warnings;
use Test::More;
use Module::New;
use Module::New::Path;
use Path::Extended;

Module::New->setup('Module::New::ForTest');

subtest default => sub {
  my $path = Module::New::Path->new;

  my $root = eval { $path->guess_root; } || '';
  my $dir = dir('.');
  ok $dir->file('Makefile.PL')->exists, 'Makefile.PL exists';
  ok $root eq $dir, 'root is current dir';
};

subtest look_for_makefile_pl => sub {
  my $path = Module::New::Path->new;

  my $current = dir('.');
  my $testapp = dir('t/TestApp');
     $testapp->mkpath;
     $testapp->subdir('lib/foo')->mkpath;
     $testapp->file('Makefile.PL')->touch;
  ok $testapp->file('Makefile.PL')->exists, 'Makefile.PL exists';

  chdir $testapp->subdir('lib/foo');

  my $root = eval { $path->guess_root; } || '';

  ok $root eq $testapp, 'root is testapp';

  chdir $current;

  $testapp->remove;
};

subtest look_for_build_pl => sub {
  my $path = Module::New::Path->new;

  my $current = dir('.');
  my $testapp = dir('t/TestApp');
     $testapp->mkpath;
     $testapp->subdir('lib/foo')->mkpath;
     $testapp->file('Build.PL')->touch;
  ok $testapp->file('Build.PL')->exists, 'Build.PL exists';

  chdir $testapp->subdir('lib/foo');

  my $root = eval { $path->guess_root; } || '';

  ok $root eq $testapp, 'root is testapp';
  chdir $current;

  $testapp->remove;
};

subtest not_found => sub {
  my $path = Module::New::Path->new;

  my $current = dir('.');
  my $dir;
  foreach my $candidate (qw( / /tmp )) {
    $dir = dir($candidate);
    last if chdir $dir;
  }
  if ( $current eq $dir ) {
    SKIP: {
      skip 'this test may be unstable for you', 1;
      fail;
      return;
    }
  }

  local $@;
  eval { $path->guess_root; };

  ok $@ =~ /^Can't guess root/, "Can't guess root";

  chdir $current;
};

subtest with_args => sub {
  my $path = Module::New::Path->new;

  my $current = dir('.');
  my $testapp = dir('t/TestApp');
  ok !$testapp->exists, 'testapp does not exist';

  local $@;
  my $root = eval { $path->guess_root('t/TestApp/'); } || '';

  ok $root eq $testapp, 'root is testapp';
  ok $testapp->exists, 'testapp exists';

  chdir $current;

  $testapp->remove;
};

done_testing;
