#!/bin/bash

chromSize=$(refgenie seek hg19/fasta.chrom_sizes)

for i in *.bedGraph
do 

	cell="${i%.*}"
	echo $cell

	bedGraphToBigWig $i $chromSize $cell.bw
	
	#mv $cell.bw /Volumes/BackUp_AubleLab/ENCODE_bigWigs/primaryCell_merged_bigWig
	
done
