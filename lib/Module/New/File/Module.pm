package Module::New::File::Module;

use strict;
use warnings;
use Module::New::File;

file '{MAINFILE}' => content { return <<'EOT';
package <%= $c->module %>;

use strict;
use warnings;

sub new {
    my $class = shift;
    my $self  = bless {}, $class;

    $self;
}

1;

__END__

=head1 NAME

<%= $c->module %>

=head1 SYNOPSIS

=head1 DESCRIPTION

=head1 METHODS

=head2 new

=head1 AUTHOR

<%= $c->config('author') %>, E<lt><%= $c->config('email') %>E<gt>

=head1 COPYRIGHT AND LICENSE

Copyright (C) <%= $c->date->year %> by <%= $c->config('author') %>.

<%= $c->license %>
=cut
EOT
};

1;

__END__

=head1 NAME

Module::New::File::Module

=head1 DESCRIPTION

a template for a module.

=head1 AUTHOR

Kenichi Ishigaki, E<lt>ishigaki at cpan.orgE<gt>

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2007 by Kenichi Ishigaki.

This program is free software; you can redistribute it and/or
modify it under the same terms as Perl itself.

=cut
