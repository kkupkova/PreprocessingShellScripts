#!/bin/bash
#This script will run HISAT2 using paired-end read files and then convert the resulting SAM file to sorted BAM using RAT (rn6) index and FASTQ input files.
echo -e What is the name of the input FASTQ forward read file?
read name1
echo -e What is the name of the input FASTQ reverse read file?
read name2
echo -e What prefix would you like added to the output sorted BAM file?
read name3
hisat2 -p 7 --dta -x /Users/beast/hisat2-2.0.4/indexes/rn6/genome -1 $name1 -2 $name2 | samtools view -S -b - > $name3.unsorted.bam
samtools sort -@ 7 $name3.unsorted.bam $name3
rm *unsorted.bam




