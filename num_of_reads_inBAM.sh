#!/bin/bash
#Script goes through all the BAM files in a folder and returns the number of mapped reads

for i in *.bam
do 
	id="$( cut -d '.' -f 1 <<< "$i" )"
	echo $i

	samtools view -c -F 4 $i
done






