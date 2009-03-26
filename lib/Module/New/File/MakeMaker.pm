package Module::New::File::MakeMaker;

use strict;
use warnings;
use Module::New::File;

file 'Makefile.PL' => content { return <<'EOT';
use strict;
use warnings;
use ExtUtils::MakeMaker;

WriteMakefile(
    NAME          => '<%= $c->module %>',
    AUTHOR        => '<%= $c->config('author') %> <<%= $c->config('email') %>>',
    VERSION_FROM  => '<%= $c->mainfile %>',
    ABSTRACT_FROM => '<%= $c->mainfile %>',
    PREREQ_PM => {
        'Test::More'          => '0.47',
        'Test::UseAllModules' => '0.10',
    },
    ($ExtUtils::MakeMaker::VERSION >= 6.31
        ? ( LICENSE => 'perl' )
        : ()
    ),
);
EOT
};

1;

__END__

=head1 NAME

Module::New::File::MakeMaker

=head1 DESCRIPTION

a template for C<Makefile.PL> (with L<ExtUtils::MakeMaker>).

=head1 AUTHOR

Kenichi Ishigaki, E<lt>ishigaki at cpan.orgE<gt>

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2007-2009 by Kenichi Ishigaki.

This program is free software; you can redistribute it and/or
modify it under the same terms as Perl itself.

=cut
