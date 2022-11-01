#!/bin/bash
#This script will run Bowtie2 and then convert the resulting SAM file to BAM using DROSOPHILA (dm6) reference genome and FASTQ input files.
echo -e What is the name of the input FASTQ file?
read name1
echo -e What prefix would you like added to the output BAM file?
read name2
bowtie2 -x /Users/beast/bowtie2-2.2.6/indexes/dm6/genome -p 3 --time -U $name1 | samtools view -S -b - > $name2.bam