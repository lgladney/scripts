#!/usr/bin/env perl
#Lori Gladney 1-4-2018
#While reading each 4thline in fastq file, extract the quality string and determine 
#the length and average score of each

use warnings;
use strict;

# get command-line arguments, or die with a usage statement
my $usage         = "Usage: extract_quality_fastq.pl uncompressed_fastq > out.txt\n";
my $infile        = $ARGV[0] or die $usage;  #filename for uncompressed_fastq file

#open file handle
open FILE, $infile or die $!; 

#Go ahead and print the header for the output
print join ("\t", "Average_Read_Quality", "Read_Length")."\n";

#Loop through the file
while (<FILE>) {
	
     my $string;  ##print  if $. % 4 == 0; this prints every 4th line in the fastq
	 if ($. % 4 == 0) {

	 $string = $_; #store the quality string for the current line
	 my $length = length($string);  #find the length of the quality string which is equal the read length
	 
	 #declare variables for calculating the average quality of each individual read
	 my $count=0;
	 my $sum=0;
	 my $avgReadQual;
	 
		#Find the average quality score using the quality score of each base in the read, 
		#sum them up and divide by the read length
		for ( split //, $string ) {
		
			#convert the ASCII code to quality format
			#print "$_ = ", ord($_) - 33, "\n";
			$count=ord($_) - 33;
			$sum+=$count;
			#print "$sum \n";
			$avgReadQual=($sum/$length);

			 }

			#print "Read_Length= $length \n";
			#print "Average_Read_Quality= $avgReadQual \n";
			
			#print the average read quality for all reads as well as the length in tab-delimited format
			#these will be large files in the Megabyte size range
			print join ("\t", $avgReadQual , $length)."\n";
	 
	 
	 }
	 
 }

exit; 

