use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/lib";
use Test::More;
use Module::New;
use Path::Extended;

subtest default => sub {
  my $recipe = load_recipe();

  my $current = dir('.');

  my $context = Module::New->setup('Module::New::ForTest');
  eval { $recipe->run; };
  ok !$@ && $context->path->_root eq dir('.'), 'current is root';
  diag $@ if $@;

  chdir $current;
};

done_testing;

sub load_recipe {
  delete $INC{'Module/New/ForTest/Recipe/GuessRoot.pm'};
  require Module::New::ForTest::Recipe::GuessRoot;
  return 'Module::New::ForTest::Recipe::GuessRoot';
}
