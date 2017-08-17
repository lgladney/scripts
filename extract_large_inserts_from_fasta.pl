#!/usr/bin/env perl
#Lori Gladney 01-31-2017
#Extract inserts from read-mapping CLC sequence files that are greater than a specified value
#From: http://www.bioinformatics-made-simple.com/2012/07/how-to-filter-sequence-by-their-length.html
#Usage perl remove_small.pl 400 input.fasta > result.fasta
my $minlen = shift or die "Error: `minlen` parameter not provided\n";
{
    local $/=">";
    while(<>) {
        chomp;
        next unless /\w/;
        s/>$//gs;
        my @chunk = split /\n/;
        my $header = shift @chunk;
        my $seqlen = length join "", @chunk;
        print ">$_" if($seqlen >= $minlen);
    }
    local $/="\n";
}