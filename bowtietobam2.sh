#!/bin/bash
#This script will run Bowtie and then convert the resulting SAM file to BAM using HUMAN FASTQ input files.  Parameters are the same as used on Bowtie on Galaxy.
echo -e What is the name of the input FASTQ file?
read name1
echo -e What prefix would you like added to the output BAM file?
read name2
bowtie --sam -q -n 2 -k 1 /Users/dauble/bowtie-1.0.0/indexes/hg19.ebwt/hg19 $name1 | samtools view -S -b - > $name2.bam