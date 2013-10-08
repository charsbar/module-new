requires 'File::HomeDir'         => '0.66';
requires 'Getopt::Long'          => 0;
requires 'Log::Dump'             => '0.03';
requires 'Module::Find'          => 0;
requires 'Path::Extended'        => '0.10';
requires 'Software::License'     => 0;
requires 'String::CamelCase'     => 0;
requires 'Sub::Install'          => 0;
requires 'Text::MicroTemplate'   => '0.06';
requires 'Time::Piece'           => 0;
requires 'YAML::Tiny'            => '1.51';

on 'test' => sub {
  requires 'Test::Classy'          => '0.04';
  requires 'Test::More'            => '0.47';
  requires 'Test::UseAllModules'   => '0.09';
};

on 'build' => sub {
  requires 'ExtUtils::MakeMaker::CPANfile' => '0.04';
};

on 'configure' => sub {
  requires 'ExtUtils::MakeMaker::CPANfile' => '0.04';
};
