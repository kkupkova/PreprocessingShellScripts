#!/bin/bash

# script goes through BED files with a folder and runs liftover from hg19 to hg38

mkdir -p hg38_liftover

for i in *.bed
do 

	cell="${i%.*}"
	echo $cell
	
	hg38name="hg38_liftover/${cell}_hg38.bed"
	hg38unmapped="hg38_liftover/unmapped_${cell}_hg38.bed"

	liftover $i /Users/lilcrusher/annotations/liftOver_chain/hg19ToHg38.over.chain $hg38name $hg38unmapped
	
done

# remove all empty files (the empty files with unmapped coordinates)
find . -type f -empty -delete