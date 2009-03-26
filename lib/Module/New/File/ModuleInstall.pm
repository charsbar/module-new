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

build_requires 'Test::More' => '0.47';
build_requires 'Test::UseAllModules' => '0.10';

auto_install;
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
