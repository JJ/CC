#!/usr/bin/env perl6

use Text::CSV;

my $csv-name = @*ARGS[0];

my @lines = csv(in => $csv-name);
constant $format = "| %60s | %6s |";
say sprintf $format, "Nombre", "semver";
say "|", ("-" xx 62).join(""), "|", ("-" xx 8).join(""), "|";

for @lines[1..*] -> $l {
    my $id = $l[2]
            ??$l[2]
            !!$l[0].split(/\s+|","\s+/).map( *.comb.first );
    say sprintf $format, "<!-- Enlace de $id -->", "vx.y.z";
}
