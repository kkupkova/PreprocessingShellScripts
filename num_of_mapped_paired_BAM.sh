#!/bin/bash
#Script goes through all the BAM files in a folder and returns the number of mapped reads
# in paired-end files

for i in *.bam
do 
	echo $i
	
	# get number of mapped reads as recommended by: https://www.biostars.org/p/138116/
	samtools view -F 0x4 -@ 7 $i | cut -f 1 | sort | uniq | wc -l
done






