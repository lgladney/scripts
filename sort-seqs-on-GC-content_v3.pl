#!/usr/bin/perl  
#Lori Gladney

use warnings;
use strict;

use Bio::SeqIO;
#get command-line arguments, or die with a usage statement
my $usage         = "Usage: ./sort-seqs-on-GC-content_v2.pl infile infileformat\n infile= filename\ninfileformat= fasta\n";
my $infile        = shift or die $usage;  #type filename
my $infileformat  = shift or die $usage;  #type fasta

 
#create one SeqIO object to read in
my $seq_in = Bio::SeqIO->new(
                             -file   => "<$infile",
                             -format => $infileformat,
                             );

							 
	my @unsorted;  #array to hold scalar variables below 
	my $id;        #scalar to hold sequence identifier    
	my $num;       #scalar to hold GC content
	my $string;    #scalar to hold the sequence
	my $full_id;   #scalar to hold the full id including GC content, length etc. 
	   	
#write each entry in the input file to STDOUT, while the condition is true
#seq_in is the object that holds the file
#next seq passes each contig to the sequence object $seq
while (my $seq = $seq_in->next_seq ()) { 
	
	#Initialize variables for calculating the GC content ; start the counter at 0 for each contig that comes through the loop
	my $countG=0; #number of G's
	my $countC=0; #number of C's
    my $count=0;  #total count
    $num=0;    #percent GC
	
	$id= $seq->id; #Get the header Id of each contig
	my $length=$seq->length;  #Declare variable for finding the length of each contig sequence
	
	$string = $seq->seq;   #Each contig seq is treated as a string
	$countG = $string =~ s/(G)//sgi;   #Count the number of occurrences of G and C  in each contig  (globally and case insensitive)
    $countC = $string =~ s/(C)//sgi;
	
	$count= ($countG + $countC);  #total count of G and C
		
	$num = ($count / $length) *100;	#Calculate the %GC content of each contig (divide total count by the contig length, then multiply by 100.)
	
	$full_id= "$id %GC_content= $num GC_count= $count Contig_length= $length";
	
	push (@unsorted, [$full_id,$string,$num]); #Push each scalar into the unsorted array (identifiers, sequence and GC content) 
	                  #array elements 0,1,2    #Note $num  must also be added separately from the full_id for sorting on GC
											   
	
}
    #Declare a new array for the sorting the unsorted array. Use $$ to reference the other array. 
	#Sort the array within an array on $num (the second element in the unsorted array) in ascending order (a <=> b) on GC content 
	my @sorted= sort {$$a[2] <=> $$b[2]} @unsorted;
	
	#Loop through the array.. Print the contig sequences in order of GC content (lowest to highest)

	for (my $i=0;$i < @sorted; $i++) {
	
		my $seqstruct=$sorted[$i];   #The current iteration through the array
		my $full_id=$$seqstruct[0];  #full id is the 0th element in the array 
		my $sequence=$$seqstruct[1]; #sequence is the 1st element in the array 
	
		print ">$full_id\n$sequence\n"; 
		
	}	
	
exit;

