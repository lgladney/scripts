#!/usr/bin/env perl
#Lori Gladney 3-15-2018
#While reading each line in uncompressed fastq file, extract the seq, quality string and additional info such as ambiguous bases, GC, read length etc. for each read in a fastq 
#Use multi-threaded perl with this script, perl/5.16.1-MT

use warnings;
use strict;

#read in file with ARGV loop through lines in file with while loop pull out every fourth line and place into an array loop through the array in a for loop convert the acsii code for each read into the base quality scores and take the average for each read, store these values 
# get command-line arguments, or die with a usage statement
my $usage         = "Usage: extract_quality_fastq.pl uncompressed_fastq > out.txt\n";
my $infile        = $ARGV[0] or die $usage;  #filename for uncompressed_fastq file

#open file handle
open FILE, $infile or die $!; 

#Set up header for tabulated output
print join ("\t", "GC_percent","Percent_ambiguities", "Count_ambiguities", "Average_Read_Quality", "Read_Length", "Sequence")."\n";

#Set up global variables and counters
my $sequence;
my $sequenceRaw;
my $length=0;
my $avgReadQual=0;
my $ambiguities=0;
my $countN=0;
my $GC=0;

while (<FILE>) {
	
	 #Extract every second line in the fastq file to get the sequence 
	 if ($. %4 == 2) {   
	 
	 $sequence = $_;  #Store the sequence here
	 $sequenceRaw = $_;	#Store the sequence for calculations
	 
		#Calculate the %GC, number and %ambiguous bases, and read length 
		foreach ($sequence ) {
			my $length2=0;
			my $sum2= 0;
			my $count2= 0;
			my $count3=0;
			my $count4=0;
			my $sum3=0;
			my $sum4=0;
			my $sum5 =0;
			$length2 = length($sequence);
			$count2 = $sequence =~ s/(N)//sgi;
			$sum2+=$count2;
			$countN= $sum2;
			$ambiguities=($sum2/$length2)*100;
			#print $length2."\n";
			#print $count2."\n";
			#print $sum2."\n";
			$count3 = $sequence =~ s/(G)//sgi;
			$sum3+=$count3;
			$count4 = $sequence =~ s/(C)//sgi;
			$sum4+=$count4;
			$sum5 = ($sum3 + $sum4);
			$GC= ($sum5/$length2)*100;
						
           }
	 
	 
	 }
	 
	  	
     my $string;  ##print  if $. % 4 == 0; this prints every 4th line
	 
	 #Print the quality string from every fourth line 
	 if ($. % 4 == 0) {

			$string = $_;
			$length = length($string);
			my $count=0;
			my $sum=0;
			# my $avgReadQual;
		
		#Gonvert the quality string to a phred score or Qscore for each base and take the average for each read
		for ( split //, $string ) {
			
			#print "$_ = ", ord($_) - 33, "\n";
			$count=ord($_) - 33;
			$sum+=$count;
			#print "$sum \n";
			$avgReadQual=($sum/$length);
						
           }

			#print "Read_Length= $length \n";
			#print "Average_Read_Quality= $avgReadQual \n";
			
			print join ("\t", $GC, $ambiguities, $countN, $avgReadQual , $length, $sequenceRaw);
			#print $avgReadQual."\n"; 
			#print $ambiguities."\n";
	 
	 }
	 
	 
	
}

exit; 

