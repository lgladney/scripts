#!/usr/bin/env perl
#Lori Gladney 12-01-2016
#Adapted from https://www.biostars.org/p/76972/
#Converts tips of trees using a newick tree file and a tab-delimited mapping/taxonomy file
#USAGE: tree_replace_tips.pl taxonomyFile phylogeneticTreeFile > tree.dnd
#Example taxonomyFile #Don't use the : character in the taxonomy file or the output file won't work in Mega
#2011C-3398	2011C-3398|O45H2|MA|Isolate
#2013C-4319	2013C-4319|O45NM|CT|Stool|EH2X01.0249|EH2A26.0275

use strict;
use warnings;

my $treeFile = pop;
my %taxonomy = map { /(\S+)\s+(.+)/; $1 => $2 } <>;

push @ARGV, $treeFile;

while ( my $line = <> ) {
    $line =~ s/\b$_\b/$taxonomy{$_}/g for keys %taxonomy;
    print $line;
}

