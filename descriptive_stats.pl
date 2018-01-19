#!/usr/bin/env perl
#Lori Gladney 1-4-2018
#Calculate the descriptive statistics for a single variable (store values in a file that has rows with no column header)
#This script requires perl modules that can be accessed in the multi-threaded version of perl 5.16.1-MT

use warnings;
use strict;
use Statistics::Descriptive;
 
# get command-line arguments, or die with a usage statement
my $usage         = "Usage: descriptive_stats.pl values.txt > out.txt\n\nThis script requires perl modules that can be accessed with multi-threaded perl version 5.16.1-MT and input values stored as text with no header line.\n\nStandard output is in tabular format with the following fields, in-order:\n\nlower whisker, 1st quartile, median, 3rd quartile, upper whisker, skewness, mean_normal, mean_geometric, variance, standard deviation, count \n";
my $infile        = $ARGV[0] or die $usage;  #filename with values

#open file handle
open FILE, $infile or die $!;
 
#Add the data array to the function to make the calculations
my @data = <FILE>;
my $stat = Statistics::Descriptive::Full->new();  #descriptive stats function
$stat->add_data(@data);
	
#print the descriptive statistics in tabular format	
#print join ("\t", "lower whisker", "1st quartile", "median", "3rd quartile", "upper whisker", "skewness", "mean_normal", "mean_geometric", "variance","standard deviation","count")."\n";
#print join ("\t", $stat->quantile(0), $stat->quantile(1), $stat->quantile(2), $stat->quantile(3), $stat->quantile(4), $stat->skewness(), $stat->mean(), $stat->geometric_mean(), $stat->variance(), $stat->standard_deviation(), $stat->count())."\n";

print join ("\t", "lower whisker=", $stat->quantile(0));
print join ("\t", "1st quartile=", $stat->quantile(1) )."\n";
print join ("\t", "median=", $stat->quantile(2))."\n";
print join ("\t", "3rd quartile=", $stat->quantile(3))."\n";
print join ("\t", "upper whisker=", $stat->quantile(4));
print join ("\t", "skewness=", $stat->skewness())."\n";
print join ("\t", "mean_normal=", $stat->mean())."\n";
print join ("\t", "mean_geometric=", $stat->geometric_mean())."\n";
print join ("\t", "variance=", $stat->variance())."\n";
print join ("\t", "standard deviation=",$stat->standard_deviation())."\n";
print join ("\t", "count=", $stat->count())."\n";
 

exit; 

