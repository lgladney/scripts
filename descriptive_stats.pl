#!/usr/bin/env perl
#Lori Gladney 1-4-2018
#Calculate the descriptive statistics for a single variable (store values in a file that has rows with no column header)

use warnings;
use strict;
use Statistics::Descriptive;
 
# get command-line arguments, or die with a usage statement
my $usage         = "Usage: descriptive_stats.pl values.txt > out.txt\n";
my $infile        = $ARGV[0] or die $usage;  #filename with values

#open file handle
open FILE, $infile or die $!;
 
#Add the data array to the function to make the calculations
my @data = <FILE>;
my $stat = Statistics::Descriptive::Full->new();  #descriptive stats function
$stat->add_data(@data);
	
#print the descriptive statistics	
print join ("\t", "lower whisker", "1st quartile", "median", "3rd quartile", "upper whisker", "skewness", "mean","variance","standard deviation","count" )."\n";
print join ("\t", $stat->quantile(0) , $stat->quantile(1), $stat->quantile(2), $stat->quantile(3), $stat->quantile(4), $stat->skewness(), $stat->mean(), $stat->variance(), $stat->standard_deviation(), $stat->count())."\n";


exit; 

