package Module::New::Context;

use strict;
use warnings;
use Carp;

use Module::New::Loader;
use Module::New::Log;
use Sub::Install 'reinstall_sub';

foreach my $accessor (qw( template date path loader files )) {
  reinstall_sub({
    as   => $accessor,
    code => sub { shift->{$accessor} },
  });
}

sub new {
  my $class = shift;

  my $loader = Module::New::Loader->new(@_);
  my $self = bless { loader => $loader }, $class;

  foreach my $name (qw( License Template )) {
    $self->{lc $name} = $loader->load_class($name);
  }

  foreach my $name (qw( Config Path Date Files )) {
    $self->{lc $name} = $loader->load($name);
  }

  $self;
}

sub config {
  my $self = shift;
  return $self->{config} unless @_;
  return $self->{config}->get(@_) if @_ == 1;
  $self->{config}->set(@_);
}

sub license {
  my ($self, $type, @args) = @_;
  $type ||= $self->config('license') || 'perl';
  $self->{license}->render( $type, @args );
}

sub distname {
  my $self = shift;

  if ( @_ ) {
    my $module = my $dist = shift;
    $dist   =~ s/::/\-/g;
    $module =~ s/\-/::/g;

    croak "$dist looks weird" if $dist =~ tr/A-Za-z0-9_\-//cd;

    $self->{distname} = $dist;
    $self->module( $module );
  }

  $self->{distname};
}

sub module {
  my $self = shift;

  if ( @_ ) {
    $self->{module} = shift;
    my $file = $self->{module};
       $file =~ s|::|\/|g;
    $self->mainfile("lib/$file.pm");
  }
  $self->{module};
}

sub mainfile {
  my $self = shift;
  if ( @_ ) {
    $self->{mainfile} = shift;
  }
  $self->{mainfile};
}

sub maindir {
  my $self = shift;
  my $dir = $self->{mainfile};
     $dir =~ s/\.pm$//;
  return $dir;
}

1;

__END__

=head1 NAME

Module::New::Context

=head1 SYNOPSIS

  my $context = Module::New->context;
  my $value = $context->config('foo');
  my $distribution = $context->distname;  # Some-Distribution-Name
  $context->module('Some::Module::Name');

=head1 DESCRIPTION

This is used to hold various information on a distribution/module.

=head1 METHODS

=head2 new

creates an object.

=head2 config

returns a ::Config object if there's no argument, and returns an appropriate config value with an argument. If you pass more arguments, you can update the configuration temporarily (if you want to keep the values permanently, use C<-E<gt>config-E<gt>save(@_)> instead).

=head2 license

takes a license name and returns a license text (perl license by default).

=head2 distname

holds a distribution name you passed to the command.

=head2 module

holds a main module name you passed to the command (or the one converted from a distribution name).

=head2 mainfile

holds a main module file path.

=head2 maindir

holds a main module directory path.

=head1 AUTHOR

Kenichi Ishigaki, E<lt>ishigaki@cpan.orgE<gt>

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2007-2009 by Kenichi Ishigaki.

This program is free software; you can redistribute it and/or
modify it under the same terms as Perl itself.

=cut
