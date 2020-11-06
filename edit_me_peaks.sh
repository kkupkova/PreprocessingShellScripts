#!/bin/bash
# DESCRIPTION!!!
#go through all subdirectories

#change the H3K4me3 BED file so it has only 3 columns
for sample in *.bed
 	do  
   	id_bed="$( cut -d '-' -f 1 <<< "$sample" )"
   	echo $id_bed
   	awk '{print $1 "\t" $2 "\t" $3}' $sample > $id_bed.bed
   	rm $sample
done