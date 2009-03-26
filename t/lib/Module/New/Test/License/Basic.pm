package Module::New::Test::License::Basic;

use strict;
use warnings;
use Test::Classy::Base;

__PACKAGE__->mk_classdata( license_class => 'Module::New::License' );

sub initialize {
  my $class = shift;

  my $license_class = $class->license_class;
  eval "require $license_class";
}

sub perl : Test {
  my $class = shift;

  my $license = $class->license_class->render('perl');
  ok $license, $class->message('found license');
}

sub not_found : Test {
  my $class = shift;

  eval { $class->license_class->render('not_found') };
  ok $@, $class->message('not found license');
}

1;
