#!/bin/bash

# convert bedGraph files from within a folder to a bigWig and move the bigWigs
# to the folder at line 16

# get the chromosome sizes from refgenie
chromSize=$(refgenie seek hg19/fasta.chrom_sizes)

for i in *.bedGraph
do 

	cell="${i%.*}"
	echo $cell

	bedGraphToBigWig $i $chromSize $cell.bw
	#mv $cell.bw /Volumes/BackUp_AubleLab/ENCODE_bigWigs/primaryCell_merged_bigWig

done
