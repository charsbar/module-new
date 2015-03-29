package Module::New::Recipe::TravisYml;

use strict;
use warnings;
use Module::New::Recipe;
use Module::New::Command::Basic;

flow {
  guess_root;

  create_files('TravisYml');

  create_manifest;
};

1;

__END__

=encoding utf-8

=head1 NAME

Module::New::Recipe::TravisYml - add .travis.yml

=head1 USAGE

From the shell/command line:

=over 4

=item module_new travis_yml

=back

=head1 AUTHOR

Kenichi Ishigaki, E<lt>ishigaki@cpan.orgE<gt>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2015 by Kenichi Ishigaki.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut
