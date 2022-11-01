#!/bin/bash

# from the folder with the BED run edit_bed_for_mutAnalysis.sh

# new pre-processed bed files with prefix: known_processed_sorted_ will be made

# sort files
# select the first three columns
# remove the unknown chromosomes- get all the known and remove everything that contains the word random

prefix="known_processed_sorted_"

for bedfile in *.bed
do
	echo $sorted$bedfile
	sort -k 1,1 -k2,2n $bedfile | awk '{print $1 "\t" $2 "\t" $3}' | grep -e chr1 -e chr2 -e chr3 -e chr4 -e chr5 -e chr6 -e chr7 -e chr8 -e chr9 -e chrX -e chrY | grep -v "random" > $prefix$bedfile
done
