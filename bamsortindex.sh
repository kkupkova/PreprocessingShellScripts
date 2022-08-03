#!/bin/bash
#This script will sort and then index BAM files in batch in the working directory.
#generate sorted BAM files:


for i in *.bam 
do 
	fileName="${i%%.*}"
	echo $fileName
	
	#sort and index the bam file
	sorted="${fileName}_sorted"
	sortedBAM="${sorted}.bam"
	
	
	samtools sort -@ 7 $i $sorted
	samtools index $sortedBAM
	
	
	# remove the original unsorted files
	rm $i
done

	