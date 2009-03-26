package Module::New::License;

use strict;
use warnings;
use Carp;
use Sub::Install 'reinstall_sub';

my %LICENSES;

sub _install_dsl {
  my $class = shift;

  return if $class eq 'main';
  return if $class =~ /^Test::/;

  reinstall_sub({
    as   => 'license',
    into => $class,
    code => sub ($$) { 
      my ($name, $text) = @_;
      $LICENSES{$name} = sub { $text->(@_) };
    },
  });

  reinstall_sub({
    as   => 'content',
    into => $class,
    code => sub (&) { return shift },
  });

  reinstall_sub({
    as   => 'render',
    into => $class,
    code => sub {
      my ($self, $type, @args) = @_;

      return $LICENSES{$type}->(@args) if $LICENSES{$type};

      croak "unknown license type: $type";
    }
  });
}

BEGIN { _install_dsl(__PACKAGE__); }

sub import {
  my ($class, $flag) = @_;

  _install_dsl(caller) if $flag && $flag eq 'base';
}

license perl => content { return <<'EOT';
This program is free software; you can redistribute it and/or
modify it under the same terms as Perl itself.
EOT
};

1;

__END__

=head1 NAME

Module::New::License

=head1 SYNOPSIS

  use Module::New::License;
  Module::New::License->render('perl');

=head1 DESCRIPTION

This is used internally to render a license text. At the moment, only perl license is supported.

=head1 METHOD

=head2 render

takes a license name and render the text.

=head1 CREATE OTHER LICENSES

  package Your::Module::New::License;
  use Module::New::License 'base';

  license 'license name' => content { my @args = @_; return <<"EOT";
  blah blah blah...
  EOT
  };

With a C<base> flag, domain specific C<license> and C<content> functions will be installed to define custom licenses.

=head1 AUTHOR

Kenichi Ishigaki, E<lt>ishigaki at cpan.orgE<gt>

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2007-2009 by Kenichi Ishigaki.

This program is free software; you can redistribute it and/or
modify it under the same terms as Perl itself.

=cut
