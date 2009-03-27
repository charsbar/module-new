package Module::New::Path;

use strict;
use warnings;
use Carp;
use Path::Extended::File;
use Path::Extended::Dir;

sub new { bless { _root => '' }, shift }

sub _root { shift->{_root} }

sub file {
  my $self = shift;

  croak "root is not defined; set it first" unless $self->_root;

  my $context = Module::New->context;
  my $subdir  = $context->config('subdir');

  $self->_file( $self->_root, $subdir, @_ );
}

sub dir {
  my $self = shift;

  croak "root is not defined; set it first" unless $self->_root;

  my $context = Module::New->context;
  my $subdir  = $context->config('subdir');

  $self->_dir( $self->_root, $subdir, @_ );
}

sub _file { shift; Path::Extended::File->new( grep {defined} @_ ) }
sub _dir  { shift; Path::Extended::Dir->new( grep {defined} @_ ) }

sub guess_root {
  my ($self, $path) = @_;

  if ( defined $path ) {
    my $dir = $self->_dir('.', $path);
       $dir->mkpath unless $dir->exists;
    return $self->set_root($dir);
  }

  my $current = my $dir = $self->_dir('.');
  if ( $dir->subdir('lib')->exists ) {
    return $self->set_root($dir);
  }

  my $try = 30;
  while ( $try-- and $dir->parent ne $dir ) {
    if ( $dir->subdir('lib')->exists ) {
      if ( $dir->file('Makefile.PL')->exists
        or $dir->file('Build.PL')->exists
      ) {
        return $self->set_root($dir);
      }
    }
    $dir = $dir->parent;
  }
  croak "Can't guess root";
}

sub set_root {
  my ($self, $path) = @_;

  my $root = $self->{_root} = $self->_dir( $path || '.' );

  croak "$root does not exist" unless $root->exists;

  Module::New->context->log( debug => "set root to $root" );

  chdir $root;

  return $root;
}

sub create_dir {
  my ($self, $path, $absolute) = @_;

  my $dir;
  if ( $absolute ) {
    $dir = $self->_dir($path);
  }
  else {
    $dir = $self->dir($path);
  }
  unless ( $dir->exists ) {
    $dir->mkpath;
    Module::New->context->log( info => "created $path" );
  }
}

sub remove_dir {
  my ($self, $path, $absolute) = @_;

  my $dir;
  if ( $absolute ) {
    $dir = $self->_dir($path);
  }
  else {
    $dir = $self->dir($path);
  }
  if ( $dir->exists ) {
    $dir->remove;
    Module::New->context->log( info => "removed $path" );
  }
}

sub create_file {
  my ($self, %files) = @_;

  croak "root is not defined; set it first" unless $self->_root;

  my $context = Module::New->context;

  foreach my $path ( sort keys %files ) {
    next unless $path;

    my $file = $self->file($path);
    $self->create_dir( $file->parent->relative( $self->_root ) );

    if ( $file->exists ) {
      if ( $context->config('grace') ) {
        $file->rename_to("$file.bak");
        Module::New->context->log( info => "renamed $path to $path.bak" );
      }
      elsif ( $context->config('force') ) {
        # just skip and do nothing
      }
      else {
        Carp::confess "$path already exists";
      }
    }
    $file->save( $files{$path}, mkdir => 1 );
    Module::New->context->log( info => "created $path" );
  }
}

sub remove_file {
  my ($self, @paths) = @_;

  croak "root is not defined; set it first" unless $self->_root;

  foreach my $path ( @paths ) {
    $self->file($path)->remove;
    Module::New->context->log( info => "removed $path" );
  }
}

sub change_dir {
  my ($self, $path) = @_;
  chdir $self->dir($path);
  Module::New->context->log( info => "changed directory to $path" );
}

1;

__END__

=head1 NAME

Module::New::Path

=head1 DESCRIPTION

This is to handle files/directories in a distribution.

=head1 METHODS

=head2 new

creates an object.

=head2 set_root

takes a path and sets a root/base directory of a distribution.

=head2 guess_root

looks for a Makefile.PL/Build.PL to make/build and makes there a root/base directory for the distribution.

=head2 file, dir

takes a (relative) path and returns a C<Path::Extended::File/Dir> object respectively. 

=head2 create_dir, remove_dir

takes a path and creates/removes a (relative) directory. If the second argument is passed and true, the directory is regarded as an absolute one.

=head2 create_file

creates a file (and makes a parent directory if necessary).

=head2 remove_file

removes a file.

=head2 change_dir

takes a (relative) path and changes the current directory to there.

=head1 AUTHOR

Kenichi Ishigaki, E<lt>ishigaki@cpan.orgE<gt>

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2009 by Kenichi Ishigaki.

This program is free software; you can redistribute it and/or
modify it under the same terms as Perl itself.

=cut
