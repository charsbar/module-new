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
    'Log::Dump'             => 0,
    'Path::Extended'        => '0.10',
    'String::CamelCase'     => 0,
    'Sub::Install'          => 0,
    'Test::Classy'          => '0.04',
    'Test::More'            => '0.47',
    'Test::UseAllModules'   => '0.09',
    'Text::MicroTemplate'   => '0.05',
    'Time::Piece'           => 0,
    'YAML'                  => '0.60',
  },
  EXE_FILES => ['module_new'],
  ($ExtUtils::MakeMaker::VERSION >= 6.31
    ? (LICENSE => 'perl')
    : ()
  ),
);
