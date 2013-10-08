package Module::New::Recipe::License;

use strict;
use warnings;
use Module::New::Recipe;
use Module::New::Command::Basic;

available_options qw(license=s);

flow {
  guess_root;

  create_files('License');

  create_manifest;
};

1;

__END__

=encoding utf-8

=head1 NAME

Module::New::Recipe::License

=head1 SYNOPSIS

=head1 DESCRIPTION

=head1 METHODS

=head1 AUTHOR

Kenichi Ishigaki, E<lt>ishigaki@cpan.orgE<gt>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2013 by Kenichi Ishigaki.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut
