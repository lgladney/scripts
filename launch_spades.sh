#!/bin/bash -l
# Runs a spades assembly.  Run with no options for usage.
# Author: Lee Katz <lkatz@cdc.gov>

#$ -S /bin/bash
#$ -pe smp 4-16
#$ -cwd -V
#$ -o spades.log
#$ -j y
#$ -N SPAdes3.9.0
#$ -q all.q

forward=$1
reverse=$2
out=$3
fastaOut=$4

scriptname=$(basename $0);

if [ "$out" == "" ]; then
  echo "Usage: $scriptname reads.1.fastq.gz reads.2.fastq.gz output/ [out.fasta]"
  echo "  if out.fasta is given, then the output directory will be removed and the scaffolds.fasta file will be saved"
  exit 1;
fi;

module load SPAdes/3.9.0
if [ $? -gt 0 ]; then echo "unable to load spades 3.9.0"; exit 1; fi;

NSLOTS=${NSLOTS:=1}

COMMAND="spades.py -1 $forward -2 $reverse --careful -o $out -t $NSLOTS"
echo $scriptname: $COMMAND
$COMMAND
if [ $? -gt 0 ]; then echo "problem with spades 3.9.0"; exit 1; fi;

if [ "$fastaOut" != "" ]; then
  cp -v "$out/scaffolds.fasta" $fastaOut
  if [ $? -gt 0 ]; then echo "problem with copying $out/scaffolds.fasta => $fastaOut"; exit 1; fi;
  rm -rf "$out";
  if [ $? -gt 0 ]; then echo "problem with removing the directory $out"; exit 1; fi;
fi
