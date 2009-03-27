package Module::New::Test::Config::Merge;

use strict;
use warnings;
use Test::Classy::Base;
use Module::New::Config;

sub merge : Tests(2) {
  my $class = shift;

  my $config = Module::New::Config->new( no_prompt => 1 );

  local @ARGV = qw(--first=first --second=second);

  $config->get_options('first=s');
  $config->get_options('second=s');

  ok $config->get('first') eq 'first', $class->message('first option');
  ok $config->get('second') eq 'second', $class->message('second option');
}

1;
