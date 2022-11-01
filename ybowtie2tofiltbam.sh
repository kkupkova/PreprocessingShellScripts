#!/bin/bash
#This script will run Bowtie2 and then convert the resulting SAM file to BAM using YEAST (S. cerevisiae sacCer3) and FASTQ input files.
echo -e What is the name of the input FASTQ file?
read name1
echo -e What prefix would you like added to the output BAM file?
read name2
bowtie2 -x /Users/dauble/bowtie2-2.2.6/indexes/sacCer3.bt2/sacCer3 -p 3 --time -U $name1 | samtools view -S -b - > $name2.bam