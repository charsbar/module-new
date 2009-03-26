package Module::New::File::Changes;

use strict;
use warnings;
use Module::New::File;

file 'Changes' => content { return <<'EOT';
Revision history for <%= $c->distname %>

0.01 <%= $c->date->ymd('/') %>
  - initial release
EOT
};

1;

__END__

=head1 NAME

Module::New::File::Changes

=head1 DESCRIPTION

a template for C<Changes> file.

=head1 AUTHOR

Kenichi Ishigaki, E<lt>ishigaki@cpan.orgE<gt>

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2007-2009 by Kenichi Ishigaki.

This program is free software; you can redistribute it and/or
modify it under the same terms as Perl itself.

=cut
