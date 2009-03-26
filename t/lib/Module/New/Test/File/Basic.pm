package Module::New::Test::File::Basic;

use strict;
use warnings;
use Test::Classy::Base;
use Module::New;

sub simple : Tests(2) {
  my $class = shift;

  Module::New->setup('Module::New::ForTest');

  my %files = Module::New::ForTest::File::Simple->render;

  my $num_of_files = keys %files;
  ok $num_of_files == 1, $class->message('one file');
  ok $files{Simple} =~ /today is \d{4}\/\d{2}\/\d{2}\./, $class->message('has Simple file content');
}

package Module::New::ForTest::File::Simple;
use Module::New::File;

file 'Simple' => content { return <<'EOT';
today is <%= $c->date->ymd('/') %>.
EOT
};

1;
