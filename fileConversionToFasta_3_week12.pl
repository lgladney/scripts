#!/usr/bin/perl -w

#This script will identify the type of sequence file as supplied from the command line and
#convert sequence file into fasta file with .fna extension (if nucleotides) or 
# .faa (if protein)


use strict; 
use File::Basename;  #Utility used for finding the types of files
use 5.010;           #Version preferred for File::Basename utility

#File will be supplied as a command line argument; alert the user if no file is specified
@ARGV or die "No input file specified";

##########################################################################################

#While my file = command line argument 
while (my $file = <$ARGV[0]>) {


   #Remove the new line character 
   chomp $file;
  
   #Parse file name, directory path into variables $name $path 
   #Parse references $file entered at the command line   	
   my ($name, $path) = fileparse($file);
   
   #Open out files  
	open (PROTEINOUT, ">", "$name.faa") or die "cannot open > $name.faa: $!";

	open (NUCLOUT, ">", "$name.fna") or die "cannot open > $name.fna: $!";
} 

#Determine the file type  
my $type=0;  
open FILE, $ARGV[0] or die "Cannot open input file!\n";
while (<FILE>) {

   if (m/^ID/) {
      #print "File type is an EMBL file\n";
      $type=1;
     }
 
	   
    if (m/^\@/) {
      #print "File type is a fastq file\n";
       $type=2;
    }
   
	
    if (m/^LOCUS/) {
      #print "File type: is a Genbank file\n";
       $type=3;
    }
    

    if (m/^\#/) {
     # print "File type is a Mega file\n";
       $type=4;
    }
 
	  
   if (m/^\>/) {
      #print "File type is a PIR file\n";
       $type=5;
     }
      
    
}  
  
close FILE; 

open FILE, $ARGV[0] or die "Cannot open input file!\n";

##########################################################################################
#If file is an EMBL file...

if ($type==1) {

#Initialize variables
my @id;
my @accession; 
my @embl;
my @array; 


#Read through each line in the file with a while loop
while (<FILE>) {

	#if match ID at the beginning of the line
	if (m/^ID/) {
		
		#Split the matched line on whitespaces
		@id= split (/\s+/, $_); 

		#Print the second element in this line (id)
		#print "ID=$id[1] \n";
		
		#Prints the entire line that includes the match
		#print "$_ \n"; 
	}
  
  #if match AC at the beginning of the line	
  if (m/^AC/) {
	
	#Split the matched line on whitespaces 
	 @accession= split (/\s+/, $_); 
	 
	 #Print the first element in this line (accession)
	 #print "Accession= $accession[1] \n"; 
	 
	 }	
	
	#If match one or more whitespaces, sequence starts here 
   if (m/^\s+/) {
   	
   	#Substitute digits and whitespaces with nothing 
     s/[0-9]+//;
     s/\s+//g;
  	   
  	   #Push into array embl the current line concatenated with whitespaces 
  	   push (@embl, "$_"."\n");
   
   	
   		#print "$_\n";   #This prints the entire line with seq and positions
   			
   		}

   }

my $proteinflag=0;
foreach (@embl){
	 
	#print "@embl\n";
	if (m/[VLIPFYWSMNQKRHDE]/i) { 
	$proteinflag=1; 
	last; 
	} 
}	
	
	if ($proteinflag) {
	
	#Print id, accession no. and sequence (@embl)
	print PROTEINOUT ">$id[1] $accession[1] \n @embl\n";
	}
	else {
	print NUCLOUT ">$id[1] $accession[1] \n @embl\n";	
	}

	
close FILE;
exit; 

}
##########################################################################################
#If file is a fastq file...

if ($type==2) {

my $proteinflag=0;
my @array;

#Read through each line in the fastq file with a while loop
while (<FILE>) {

 
	#if current line matches @, substitute @ with >
	if ( m/^\@/) {
	
		$_ =~ (s/^\@/>/);
			
		#print "$_";
		
		push (@array, $_);
			
		}
	
	#if match letters, push line into array
	if (m/^[ATCGVLIPFYWSMNQKRHDE]/i) { 
    push (@array, $_);
    
    #if protein seq...
	if (m/[VLIPFYWSMNQKRHDE]/i) { 
	$proteinflag=1;  #set flag
	  
	} 
      
  }
	
	
}	#If proteinflag true, output to .faa else .fna 
	if ($proteinflag) {
	print PROTEINOUT "@array\n";
	}
	else {
	print NUCLOUT "@array\n";	
	}

  

close FILE;
exit; 

}
##########################################################################################
#If file is Genbank file...

if ($type==3) {

#Initialize variables
my @locus;
my @origin;
my @array;
my @seq;
my $aa;   #flag for checking amino acid or nucleotide seq 

#Read through each line in the file with a while loop
while (<FILE>) {

	#if match LOCUS at the beginning of the line
	if (m/^LOCUS/) {
		
		#Split the matched line on whitespaces
		@locus= split (/\s+/, $_); 

		#Print the second element in this line (accession number)
		#print "Locus=$locus[1] \n";
		
		#Prints the entire line that includes the match
		#print "$_ \n"; 
	}
  
  #if match origin at the beginning of the line, sequence starts next line	
  if (m/^ORIGIN/) {
	
	#Split the matched line on whitespaces 
	 @origin= split (/\s+/, $_); 
	 
	 #Print the first element in this line (ORIGIN)
	 #print "This is the $origin[0], sequence is below \n"; 
	 
	 }

	#If match one or more whitespaces followed by digits, sequence starts here 
   if (m/^\s+\d/) {
	
	#Split the matched lines on whitespaces 
	@array= split (/\s+/, $_); 
	
		#Prints current line
		#print "$_\n";
		
    #Join the matched lines of sequence from @array (starting at pos 2..end of index)
    #Removes whitespaces and position numbers from the sequence 
    
	my $feq= join ('', @array[2..$#array]); 
	
			# push scalar feq (line) to a new array @seq 
	 	     push(@seq,$feq);
	 	     
	 		#Prints just the sequence
	 		#print "@seq\n";
	 		
	 	
  }

}

my $proteinflag=0;
foreach (@seq){
	 
	if (m/[VLIPFYWSMNQKRHDE]/i) { 
	$proteinflag=1; 
	last; 
	} 
}	
	
	if ($proteinflag) {
	
	#Print locus and sequence (@seq)
	print PROTEINOUT ">$locus[1] \n @seq\n";
	}
	else {
	print NUCLOUT ">$locus[1] \n @seq\n";	
	}

		
	
	
close FILE;
exit; 

}
##########################################################################################
#If file is a mega file...

if ($type==4) {

my %hash;

#Read through each line in the mega file with a while loop
while (<FILE>) {

 

	if (m/^\#mega/ or m/^\#MEGA/) {
	
	   (s/#mega// or s/#MEGA//); 
	
	} 

	if (m/^TITLE/) {
		
      (s/$_//); 

     }
     
    if (m/^\#/) {
    
       (s/#/>/); 
    
    }
    
    if (m/^\>/) {
    
     #split on whitespace and create @array
     my @array =split (/\s+/); 
     
     #hash each unique element in the current line ($array[0]=key) and add its value ($array[1]) each time through the loop
     #check if the line has a sequence and if not, skip the line  
     
     #if the key exists in the hash 
     if(exists $hash{$array[0]}) {    

		#and if a sequence exists on that line that would be a value
		if(exists $array[1]){
		
		#concatenate hash value(s) to its key 
		 $hash{$array[0]}= (($hash{$array[0]}).($array[1])."\n"); 
		 	}
 		
     }
     else
     {
     #if hash is empty, then create and add the first line value 
     $hash{$array[0]}= $array[1]."\n"; 
     }
  }   
  
 }  
my @array;
my $proteinflag=0;
foreach (sort keys %hash) {
	#print "$_ $hash{$_}\n";
        
	if (m/[VLIPFYWSMNQKRHDE]/i, $array[1]) { 
	$proteinflag=1; 
	last;
	} 
	else {
		$proteinflag=0; 
	   }
  }
  
	foreach(keys %hash){
		if ($proteinflag) {
			print PROTEINOUT "$_ \n$hash{$_} \n";
       	}
   		else {
       		print NUCLOUT "$_ \n$hash{$_} \n"; 
      	}
    }
  



close FILE; 
exit; 

}
##########################################################################################
#If file is PIR file...


if ($type==5) {

my @array;

#Read through each line in the pir file with a while loop
while (<FILE>) {

	#substitute * with nothing while reading file
	s/\*//;
	chomp; #gets rid of new line
	#if line starts w/ >, substitute the new line with nothing (globally)
	if ( m/^\>/) {
		 if (m/\n/) {
		(s{\n}{ }g);
		} 
		push (@array, $_);
		next;
		}
		
	#print "$_ \n"; 
    push (@array, $_."\n");
}

print  PROTEINOUT "@array \n";

close FILE;
exit; 

}


exit; 
##########################################################################################

###########################         THE END         ######################################

		






