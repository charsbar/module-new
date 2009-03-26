use strict;
use warnings;
use lib 't/lib';
use Test::Classy;

load_tests_from 'Module::New::Test::Loader';
run_tests;
