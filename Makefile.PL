use strict;
use warnings;
use ExtUtils::MakeMaker;

WriteMakefile(
  NAME           => 'Module::New',
  AUTHOR         => 'Kenichi Ishigaki <ishigaki@cpan.org>',
  VERSION_FROM   => 'lib/Module/New.pm',
  ABSTRACT_FROM  => 'lib/Module/New.pm',
  PREREQ_PM => {
    'File::HomeDir'         => '0.66',
    'Getopt::Long'          => 0,
    'Log::Dump'             => '0.03',
    'Path::Extended'        => '0.10',
    'String::CamelCase'     => 0,
    'Sub::Install'          => 0,
    'Test::Classy'          => '0.04',
    'Test::More'            => '0.47',
    'Test::UseAllModules'   => '0.09',
    'Text::MicroTemplate'   => '0.06',
    'Time::Piece'           => 0,
    'YAML::Tiny'            => '1.51',
  },
  EXE_FILES => [grep {-f $_} qw/module_new new/],
  ($ExtUtils::MakeMaker::VERSION >= 6.31
    ? (LICENSE => 'perl')
    : ()
  ),
);
