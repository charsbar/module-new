package Module::New::ForTest::License;

use strict;
use warnings;
use Module::New::License 'base';

license with_args => content { my $name = shift; return <<"EOT";
this license is named $name.
EOT
};

1;
