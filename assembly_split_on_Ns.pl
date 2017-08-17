#!/usr/bin/perl
#Lori Gladney
#While reading each line in a fasta file, split contigs where you see more than 10Ns and 
#output to a fasta file 
#Notation of split contigs should be contig#_substring_unique#

use warnings;
use strict;

use Bio::SeqIO;
# get command-line arguments, or die with a usage statement
my $usage         = "Usage: ./assembly_split_on_Ns.pl infile infileformat > contigs.fasta \n";
my $infile        = shift or die $usage;  #type filename
my $infileformat  = shift or die $usage;  #type fasta

 
# create one SeqIO object to read in
my $seq_in = Bio::SeqIO->new(
                             -file   => "<$infile",
                             -format => $infileformat,
                             );

#write each entry in the input file to STDOUT, while the condition is true
#seq_in is the object that holds the file
#next seq passes each contig to the sequence object $seq
while (my $seq = $seq_in->next_seq ()) { 
	
	#declare variable for the array  
    my @splitseq;
    
    #loop through each contig, and pass each sequence to an array @splitseq and
    #split the contig seq if matches 10 or more Ns and return the sequence to the array
	@splitseq=  split (m/N{10,}/,$seq->seq());
	
	for (my $i=0; $i < @splitseq; $i++) {
	 #increment each subcontig in the array @splitseq to provide a unique id
	 #The array will now contain subcontigs 0 or 1..n for contigs that contain
     # < 10 Ns or > 10 Ns, respectively. 
	
		#define what should be in the sequence id header by using the variable $id 
		my $id= ">". $seq->id . "_substring_" . $i ; 
		
		#print the defined id using the variable $id and include the contig or subcontig
		#sequence (there is only one per seq object). 
		#Don't forget to print splitseq on $i..the ith one
		print "$id\n$splitseq[$i]\n";
		
	}
	 
}
exit; 