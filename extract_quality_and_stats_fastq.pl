#!/usr/bin/env perl
#Lori Gladney 1-16-2018
#While reading each 4th line in fastq file, extract the quality string and determine the length and average quality score of each read
#Convert the raw values for each read set into descriptive statistics

use warnings;
use strict;
use Statistics::Descriptive;

# get command-line arguments, or die with a usage statement
my $usage         = "Usage: extract_quality_and_stats_fastq.pl uncompressed_fastq > out.txt\n\nThis script requires perl modules that can be accessed with multi-threaded perl version 5.16.1-MT and input fastq must not be compressed.\n\nStandard output is in tabular format with the following fields, in-order:\n\nlower whisker, 1st quartile, median, 3rd quartile, upper whisker, skewness, mean_normal, mean_geometric, variance, standard deviation, count \n";
my $infile        = $ARGV[0] or die $usage;  #filename for uncompressed_fastq file

#open file handle
open FILE, $infile or die $!; 

#Declare arrays to store average read quality and length values for each read
my @qual;
my @len;


#Loop through the file
while (<FILE>) {
	
     my $string;  ##print  if $. % 4 == 0; this prints every 4th line in the fastq
	 if ($. % 4 == 0) {

	 $string = $_; #store the quality string for the current line
	 my $length = length($string);  #find the length of the quality string which is equal the read length
	 
	 #declare variables for calculating the average quality of each individual read
	 my $num=0;
	 my $sum=0;
	 my $avgReadQual;
	 
		#Find the average quality score using the quality score of each base in the read, 
		#sum them up and divide by the read length
		for ( split //, $string ) {
		
			#convert the ASCII code to quality format
			#print "$_ = ", ord($_) - 33, "\n";
			$num=ord($_) - 33;
			$sum+=$num;
			#print "$sum \n";
			$avgReadQual=($sum/$length);

			 }

			#Store these values in arrays for later	
			#print join ("\t", $avgReadQual , $length)."\n";
			push (@qual, $avgReadQual);
			push (@len,  $length);
	 }
	 
 }

my @data1=@qual; #Read quality  
my $stat1 = Statistics::Descriptive::Full->new();  #descriptive stats function
$stat1->add_data(@data1);
	
#print the descriptive statistics in tabular format	
#print join ("\t", "lower whisker", "1st quartile", "median", "3rd quartile", "upper whisker", "skewness", "mean_normal", "mean_geometric", "variance","standard deviation","count")."\n";
#print join ("\t", $stat->quantile(0), $stat->quantile(1), $stat->quantile(2), $stat->quantile(3), $stat->quantile(4), $stat->skewness(), $stat->mean(), $stat->geometric_mean(), $stat->variance(), $stat->standard_deviation(), $stat->count())."\n";

print join ("\t", $ARGV[0], "average_read_quality_stats")."\n"; 
print join ("\t", "lower_whisker=", $stat1->quantile(0))."\n";
print join ("\t", "1st_quartile=", $stat1->quantile(1) )."\n";
print join ("\t", "median=", $stat1->quantile(2))."\n";
print join ("\t", "3rd_quartile=", $stat1->quantile(3))."\n";
print join ("\t", "upper_whisker=", $stat1->quantile(4))."\n";
print join ("\t", "skewness=", $stat1->skewness())."\n";
print join ("\t", "mean_normal=", $stat1->mean())."\n";
print join ("\t", "mean_geometric=", $stat1->geometric_mean())."\n";
print join ("\t", "variance=", $stat1->variance())."\n";
print join ("\t", "standard_deviation=",$stat1->standard_deviation())."\n";
print join ("\t", "read_count=", $stat1->count())."\n";
 
#print "########################################################\n"; 
 
my @data2=@len; #Read length 
my $stat2 = Statistics::Descriptive::Full->new();  #descriptive stats function
$stat2->add_data(@data2);
	
#print the descriptive statistics in tabular format	
#print join ("\t", "lower whisker", "1st quartile", "median", "3rd quartile", "upper whisker", "skewness", "mean_normal", "mean_geometric", "variance","standard deviation","count")."\n";
#print join ("\t", $stat->quantile(0), $stat->quantile(1), $stat->quantile(2), $stat->quantile(3), $stat->quantile(4), $stat->skewness(), $stat->mean(), $stat->geometric_mean(), $stat->variance(), $stat->standard_deviation(), $stat->count())."\n";

print join ("\t", $ARGV[0], "read_length_stats")."\n";
print join ("\t", "lower_whisker=", $stat2->quantile(0))."\n";
print join ("\t", "1st_quartile=", $stat2->quantile(1) )."\n";
print join ("\t", "median=", $stat2->quantile(2))."\n";
print join ("\t", "3rd_quartile=", $stat2->quantile(3))."\n";
print join ("\t", "upper_whisker=", $stat2->quantile(4))."\n";
print join ("\t", "skewness=", $stat2->skewness())."\n";
print join ("\t", "mean_normal=", $stat2->mean())."\n";
print join ("\t", "mean_geometric=", $stat2->geometric_mean())."\n";
print join ("\t", "variance=", $stat2->variance())."\n";
print join ("\t", "standard_deviation=",$stat2->standard_deviation())."\n";
print join ("\t", "read_count=", $stat2->count())."\n"; 
 
 
close FILE;
exit; 

