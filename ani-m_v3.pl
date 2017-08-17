#!/usr/bin/perl 
#Lori Gladney 01-08-2015 version 3 
#Objective: Run MUMmer dnadiff script between two genomes 
#Run script from current directory with genome assemblies

use strict;
use warnings; 
use File::Temp qw/ tempfile tempdir /;
#use File::Spec;

my $template = "ani-m.XXXXXX";
my $tempdir = tempdir($template, CLEANUP => 1, TMPDIR=>1); #makes a temp directory using template and deletes the directory
#print "$tempdir\n" ;  #sanity checks

#Reading in fasta files (assemblies) from the command line into variables $reference and $query
#$ARGV[0] is the first file, $ARGV[1] is the second file 
my $reference= $ARGV[0] or die "Cannot locate the reference sequence\nUsage: ani-m.pl <reference> <query> 
This script outputs the reference genome, the query genome and the Average nucleotide identity";
my $query= $ARGV[1] or die "Cannot locate the query sequence\nUsage: ani-m.pl <reference> <query>
This script outputs the reference genome, the query genome and the Average nucleotide identity";

#print "$tempdir($ARGV[0]$ARGV[1])\n";

my $prefix= "$tempdir/$ARGV[0]_$ARGV[1]";
#print "$prefix";  #sanity check


#Make system call to run the dnadiff script and output any STDERR/STDOUT to dev/null
system ("dnadiff $reference $query -p $prefix 2>/dev/null");
 die "Error: Problem with dnadiff" if $?;
 
 
#Objective: parse output from MUMmer script dnadiff e.g. out.report

#Reading data from an input file
#The filename containing the data
my $filename= "$prefix.report";

#First we open the file containing the data and associate it with file handle FILE
open (FILE, $filename) or die "Cannot locate dnadiff 'out.report' file. Please make sure the file is in the current directory.\n";

#We store the the data into the variable @report (associated with <FILE>) , which is where it is read from. 
my @report= <FILE>;

# Close the file - we've read all the data into @report now.
close FILE;

my @ani;
my @identity; 
my @aligned;
my @alignedbases;

  

#Loop through each line in the report, pulling out lines that match AvgIdentity. 
foreach (@report) {
	
		
	if (/^AvgIdentity/) {
	
	#Split matching lines on whitespace and place into new array @identity
	@identity= split(/\s+/,$_);
	
	#print "$identity[1]\n";  #sanity check
	#print " @identity[0..10] @identity[11..50] \n";  #sanity check
	
	#Place the second column value [REF column] of the first line with AvgIdentity into array @ani
	#This is the line from the 1:1 alignments 
	push (@ani, $identity[1]); 
	
    #print "@ani \n";     #sanity check
  
      }
    
	if (/^AlignedBases/) {
	
	#Split matching lines on whitespace and place into new array @aligned
	@aligned= split(/\s+/,$_);
	
	#Place the second column value [Query column] of the first line with AlignedBases into array @alignedbases
		push (@alignedbases, $aligned[2]); 
	
      
      }
	  
	
   }   
   
 
   #Print the Reference Query AlignedBases %ANI
   print join ("\t", $ARGV[0] , $ARGV[1], "$alignedbases[0]", "$ani[0]")."\n"; 
    
 exit;    
