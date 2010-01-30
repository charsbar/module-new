package Module::New::File::ModuleInstall;

use strict;
use warnings;
use Module::New::File;

file 'Makefile.PL' => content { return <<'EOT';
use strict;
use warnings;
use inc::Module::Install;

name     '<%= $c->distname %>';
all_from '<%= $c->mainfile %>';

test_requires 'Test::More' => '0.47';
test_requires 'Test::UseAllModules' => '0.10';

% if ($c->repository) {
resources(
    repository => '<%= $c->repository %>',
);
% }

WriteAll;
EOT
};

1;

__END__

=head1 NAME

Module::New::File::ModuleInstall

=head1 DESCRIPTION

a template for C<Makefile.PL> (with L<Module::Install>).

=head1 AUTHOR

Kenichi Ishigaki, E<lt>ishigaki at cpan.orgE<gt>

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2007-2009 by Kenichi Ishigaki.

This program is free software; you can redistribute it and/or
modify it under the same terms as Perl itself.

=cut
