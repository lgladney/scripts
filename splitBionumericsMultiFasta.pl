#!/usr/bin/env perl
#Lori Gladney  08/17/2017
#Splits a multi-genome fasta file from Bionumerics into individual genomes
#Splits the contigs on pipes, then removes contigs less than 500 bp  
#Make sure lskatz/lskScripts @ https://github.com/lskatz/lskScripts are in your PATH and executable
#Dependencies: multi-threaded perl/5.16.1-MT,splitBionumericsFasta.pl and run_assembly_filterContigs.pl

use strict; 	
use warnings;

@ARGV or die "No input file specified!\n Usage:splitBionumericsMultiFasta.pl <input_multifasta>\n";

my $file= $ARGV[0] or die "No input file found\nUsage:splitBionumericsMultiFasta.pl <input_multifasta>\n";

#Filehandle for reading input file
open FILE, $file;

my @array;
while (<FILE>) {

	#Substitute whitespace in the deflines and put into array
	if (/>/) {
	#print $_;
	$_ =~ (s/(\s+|\|)/\_/g);
	#print "$_\n";
	push (@array, "$_.fasta\n");
	}
	
	#Put the remaining lines (sequence) into the array
	else {
	push (@array, $_);
	}
	#print "@array\n";
	
}

close (FILE);

#Define outfile name
my $outfile = 'tmp.out';

#Open the outfile and write to it or die if problem with outfile
open (FILEOUT, ">> $outfile") || die "Cannot open $outfile!\n";

#Write an array of lines to the file, then close the filehandle when done 
print FILEOUT @array;	
close(FILEOUT);	

#System call to extract and write out the individual genomes from the file 
system("awk '/^>/ {OUT=substr(\$0,2)}; OUT {print >OUT}' tmp.out"); 

#Removing the temporary outfile
system("rm tmp.out");

#System call to run splitBionumericsFasta.pl on each fasta file; splits contigs on pipes
system("for i in *.fasta;do splitBionumericsFasta.pl \$i > \$i.split.fasta;done");

#System call to run the script run_assembly_filterContigs.pl on each fasta file; removes small contigs less than 500 bp
system("for i in *split.fasta;do run_assembly_filterContigs.pl -l 500 \$i > \$i.filtered.fasta;done");

exit;

