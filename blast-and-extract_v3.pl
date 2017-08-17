#!/usr/bin/env perl
#Lori Gladney 8/17/15
use strict; 	
use warnings;

@ARGV or die "Usage: blast-and-extract.pl <ref_sequence> <query_sequence> <target_name> <flanking_length> \n";

my $file1= $ARGV[0];   #reference fasta sequence 
my $file2= $ARGV[1];   #query fasta sequence
my $target_gene= $ARGV[2]; #target region name
my $flanking_length= $ARGV[3]; #Integer value ex. 1000, or 0 for exact coordinates

#Use system call to execute commands from the command line 
#Perform Blastn. Store the results in @blastn: tabular out-format 6, query_id, start/end of sequence in query, query/subject accession and e-value.
 
my @blastn= `blastn -subject $file1 -query $file2 -outfmt "6 qid qstart qend qacc sacc evalue"` or die $?;  
print "Blastn output $file2: \n @blastn\n";

#foreach line in blastn2 output, split on whitespace the current line
my @array;
foreach (@blastn) {
	
		push (@array, $_);
	
	#Put the blast output in another array and split on whitespace
	@array= split(/\s+/, $_);
	
	#Pull the coordinates from the blast output and account for additional flanking length
	#Does account for multiple copies found
	my $start= ($array[0] - $flanking_length);
	my $end= ($array[1] + $flanking_length);
	
	print "$file2 $array[2] $target_gene extracting regions $array[0] : $array[1] plus $flanking_length bp on either side\n";
	
	#Use system call to extract sequence with extractSequence.pl, courtesy of Lee Katz, gzu2@cdc.gov
	#NOTE: Deflines must have a unique identifier for each contig or multi-fasta sequence; no spaces is recommended
	`extractSequence.pl -i $file2 -o $file2.$start"_"$end.$target_gene.fasta -s $start -e $end -c $array[2]` or die $?;
		
	}
exit;
  
   
  