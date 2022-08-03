#!/bin/bash
# convert BAM files to bigWig with deepTools

for i in *.bam
do 

	cell="${i%.*}"
	echo $cell

	bamCoverage -b $i -o $cell.bw
	
	
done
