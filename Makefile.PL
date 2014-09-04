use strict;
use warnings;

use ExtUtils::MakeMaker;

WriteMakefile(
  NAME         => 'Mojolicious::Plugin::SemanticUI',
  VERSION_FROM => 'lib/Mojolicious/Plugin/SemanticUI.pm',
  AUTHOR       => 'A Good Programmer <nospam@cpan.org>',
  PREREQ_PM    => {'Mojolicious' => '5.37'},
  test         => {TESTS => 't/*.t'}
);
