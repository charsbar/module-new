use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/lib", "$FindBin::Bin/../lib";
use Test::Classy;

load_tests_from 'Module::New::Test::Template';
run_tests;
