#!/usr/bin/env perl

use strict;
use warnings;

use File::Copy;

use v5.16;

my $dir = shift || ".";
my $previo = shift || "CC-20-21";

for my $d ( qw( proyectos sesiones ) ) {
    eval {
	mkdir("$dir/$d");
    };

    my $url = "http://raw.githubusercontent.com/JJ/$previo/master/$d/README.md";
    `wget --backups=1  $url`;
    move( 'README.md', "$dir/$d/" ) || die "Can't write file";
  }

mkdir("$dir/src");



for my $f ( qw (.gitignore LICENSE Metodología_y_criterios_de_evaluación.md README.md)) {
    `wget  --backups=1 https://raw.githubusercontent.com/JJ/$previo/master/$f`;
}
