#!/bin/bash
#This script will run Bowtie and then convert the resulting SAM file to BAM using YEAST (S. cerevisiae sacCer3) and FASTQ input files.
echo -e What is the name of the input FASTQ file?
read name1
echo -e What prefix would you like added to the output BAM file?
read name2
bowtie --sam  -q --nomaqround -m 3 --best --strata --chunkmbs 4000 --offrate 7 --seedmms 2 --threads 3 /Users/dauble/bowtie-1.0.0/indexes/sacCer3.ebwt/genome $name1 | samtools view -S -b - > $name2.bam