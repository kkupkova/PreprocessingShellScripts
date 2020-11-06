#!/bin/bash

# convert bedGraph files from within a folder to a bigWig and move the bigWigs
# to the folder at line 14

for i in *.bedGraph
do 

	cell="${i%.*}"
	echo $cell

	bedGraphToBigWig $i /Users/lilcrusher/annotations/chromsize/hg38.chrom.sizes $cell.bw
	
	mv $cell.bw /Volumes/BackUp_AubleLab/ENCODE_files_cellSpecificity/GRCh38/primaryCell_merged_bigWig_cleanAndNormalized

done
