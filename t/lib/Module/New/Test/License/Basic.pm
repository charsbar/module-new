package Module::New::Test::License::Basic;

use strict;
use warnings;
use Test::Classy::Base;

__PACKAGE__->mk_classdata( license_class => 'Module::New::License' );

sub initialize {
  my $class = shift;

  my $license_class = $class->license_class;
  eval "use $license_class";
}

sub perl : Test {
  my $class = shift;

  my $license = $class->license_class->object('perl', {holder => 'me', year => '2013'});
  ok $license, $class->message('found license');
}

sub not_found : Test {
  my $class = shift;

  eval { $class->license_class->object('not_found', {holder => 'me', year => '2013'}) };
  ok $@, $class->message('not found license');
}

1;
