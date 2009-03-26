package Module::New::Test::License::Extended;

use strict;
use warnings;
use Module::New::Test::License::Basic 'base';

__PACKAGE__->license_class('Module::New::ForTest::License');

sub with_args : Tests(2) {
  my $class = shift;

  my $license = $class->license_class->render('with_args', 'foo');
  ok $license, $class->message('found license');
  ok $license =~ /foo/, $class->message('foo is interpolated');
}

1;