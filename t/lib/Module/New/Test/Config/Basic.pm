package Module::New::Test::Config::Basic;

use strict;
use warnings;
use Test::Classy::Base;
use Module::New::Config;
use Path::Extended;

sub first_time : Tests(3) {
  my $class = shift;

  my $file = file('t/sample.yaml');
  ok !$file->exists, $class->message('sample file does not exist');

  my $config = Module::New::Config->new(
    file      => $file,
    no_prompt => 1,
  );

  ok $config->file eq $file, $class->message('config file is the sample');
  ok $file->exists, $class->message('config file is created');

  $file->remove;
}

sub from_file : Tests(4) {
  my $class = shift;

  my $file = file('t/sample.yaml');
  $file->save(<<'YAML');
author: me
email: me@localhost
YAML

  ok $file->exists, $class->message('sample file exists');

  my $config = Module::New::Config->new(
    file      => $file,
    no_prompt => 1,
  );

  ok $config->file eq $file, $class->message('config file is the sample');

  ok $config->get('author') eq 'me', $class->message('author is correct');
  ok $config->get('email')  eq 'me@localhost', $class->message('email is correct');

  $file->remove;
}

sub from_argv : Tests(4) {
  my $class = shift;

  my $file = file('t/sample.yaml');
  ok !$file->exists, $class->message('sample file does not exist');

  my $config = Module::New::Config->new(
    file      => $file,
    no_prompt => 1,
  );

  ok $config->file eq $file, $class->message('config file is the sample');

  local @ARGV = qw( --author=me --email=me@localhost );
  $config->get_options(qw( author=s email=s ));

  ok $config->get('author') eq 'me', $class->message('author is correct');
  ok $config->get('email')  eq 'me@localhost', $class->message('email is correct');

  $file->remove;
}

sub from_mixed_source : Tests(4) {
  my $class = shift;

  my $file = file('t/sample.yaml');
  $file->save(<<'YAML');
author: me
email: me@localhost
YAML

  ok $file->exists, $class->message('sample file exists');

  my $config = Module::New::Config->new(
    file      => $file,
    no_prompt => 1,
  );

  ok $config->file eq $file, $class->message('config file is the sample');

  local @ARGV = qw( --email=foo@localhost );
  $config->get_options(qw( author=s email=s ));

  ok $config->get('author') eq 'me', $class->message('author is correct');
  ok $config->get('email')  eq 'foo@localhost', $class->message('email is correct');

  $file->remove;
}

sub set_and_save : Tests(8) {
  my $class = shift;

  my $file = file('t/sample.yaml');
  $file->save(<<'YAML');
author: me
email: me@localhost
YAML

  ok $file->exists, $class->message('sample file exists');

  my $config = Module::New::Config->new(
    file      => $file,
    no_prompt => 1,
  );

  ok $config->file eq $file, $class->message('config file is the sample');

  ok $config->get('author') eq 'me', $class->message('author is correct');
  ok $config->get('email')  eq 'me@localhost', $class->message('email is correct');

  $config->set( email => 'foo@localhost' );
  ok $config->get('email') eq 'foo@localhost', $class->message('new email is set');

  $config->load( force => 1 );
  ok $config->get('email')  eq 'me@localhost', $class->message('new email is gone with reload');

  $config->save( email => 'foo@localhost' );
  ok $config->get('email') eq 'foo@localhost', $class->message('new email is set and saved');

  $config->load( force => 1 );
  ok $config->get('email')  eq 'foo@localhost', $class->message('new email is kept with reload');

  $file->remove;
}

1;
