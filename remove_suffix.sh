#!/bin/bash
# script removes suffix "_sorted_" from BAM file file name

for i in *_sorted.bam
do 
	mv -- "$i" "${i%_sorted.bam}.bam"	
done

for i in *_sorted.bam.bai
do 
	mv -- "$i" "${i%_sorted.bam.bai}.bam.bai"	
done