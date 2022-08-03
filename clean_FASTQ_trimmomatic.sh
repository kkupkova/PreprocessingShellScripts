#!/bin/bash
# the script goes through all FASTQ files and preforms some cleaning of the sequences - 
# the output are two sets of FASTQ files: 
# clean_: Remove leading low quality or N bases (below quality 3) (LEADING:3)
#		  Remove trailing low quality or N bases (below quality 3) (TRAILING:3)
#	      Scan the read with a 4-base wide sliding window, cutting when the average quality per base drops below 15 (SLIDINGWINDOW:4:15)
#		  Drop reads below the 50 bases long (MINLEN:50)
# short_: Remove leading low quality or N bases (below quality 3) (LEADING:3)
#		  Crop sequences to 80 bp (CROP:80)
#	      Scan the read with a 4-base wide sliding window, cutting when the average quality per base drops below 15 (SLIDINGWINDOW:4:15)
#		  Drop reads below the 50 bases long (MINLEN:50)
for i in *.fastq 
do
	echo "Processing following FASTQ file:"
 	echo $i
 	
 	cleanFastq="clean_${i}"
 	shortFASTQ="short_${i}"
 	
	java -jar /Users/lilcrusher/Trimmomatic-0.39/trimmomatic-0.39.jar SE -phred33 $i $cleanFastq LEADING:3 TRAILING:3 SLIDINGWINDOW:4:15 MINLEN:50
	java -jar /Users/lilcrusher/Trimmomatic-0.39/trimmomatic-0.39.jar SE -phred33 $i $shortFASTQ LEADING:3 CROP:80 SLIDINGWINDOW:4:15 MINLEN:50
done
