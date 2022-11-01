#!/bin/bash
#This script will filter out unmapped reads from a BAM file and display the number of mapped and unmapped reads.
echo -e What is the name of the input BAM file?
read name1
echo -e What prefix would you like added to the output BAM file?
read name2
echo -e The number of mapped reads:
samtools view -c -F 4 $name1
echo -e The number of unmapped reads: 
samtools view -c -f 4 $name1
samtools view -h -F 4 -b $name1 > $name2.bam