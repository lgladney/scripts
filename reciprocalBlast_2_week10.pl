#!/usr/bin/perl -w

use strict; 	

#Use system call to execute commands from the command line
#make a blast database for the two input fasta files

my $file1= $ARGV[0];

my $file2= $ARGV[1];
 
my $makeblastdb1= `makeblastdb -in $file1 -out db1 -dbtype nucl` or die $?;

my $makeblastdb2= `makeblastdb -in $file2 -out db2 -dbtype nucl` or die $?;

#blast each database against the query file and output to a text file; reciprocal blast 

my @blastn1= `blastn -db db1 -query $file2 -outfmt "6 qacc sacc evalue"` or die $?;

my @blastn2= `blastn -db db2 -query $file1 -outfmt "6 qacc sacc evalue"` or die $?;


 
#find reciprocal match with hash (the key-value pairs just be opposite/flip flopped)
#foreach sort key...blah, only really need one loop; search for element in other hash
#careful with naming hash- no same as arrays
my %hash1;
my %hash2;

#foreach line in blastn1 output, split on whitespace the current line
foreach (@blastn1) {
	my @array= split(/\s+/, $_);
	
	#if e-value is 0 (column 2), hash the first column [0] 
	if ($array[2] == 0.0) {
	
	#hash1{key is first column identifier}= value 
	$hash1{$array[0]}= $array[1]; 
	}
}
 
#foreach line in blastn1 output, split on whitespace the current line
foreach (@blastn2) {
	my @array= split(/\s+/, $_);
	
	#if e-value is 0 (column 2), hash the first column [0] 
	if ($array[2] == 0.0) {
	
	#hash1{key is first column identifier}= value 
	$hash2{$array[0]}= $array[1]; 
	}
}

foreach (sort keys %hash1) {
          #key         #value 
	#print "$_ ----->$hash1{$_} \n"; 
	my $key = $_;
	
	#return hash value for keys
	my $hash1Value=$hash1{$key};
	my $hash2Value=$hash2{$hash1Value};
	
	#if hash2 value eq hash1 key print this is a reciprocal match 
	if ($hash2Value eq $key){
	print "$hash1Value ---- $hash2Value\n";
	#print "hash1:  key $key>>> value $hash1Value      hash2:  key $hash1Value>>> value $hash2Value\n\n\n";
	}

}	

exit; 
  
  
  