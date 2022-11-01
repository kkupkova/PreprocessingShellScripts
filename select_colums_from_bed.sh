#!/bin/bash
# DESCRIPTION!!!
#selects the first three columns in the BED file and creates a new file with
#prefix processed_

processed='processed_'
#change the TFBS BED file so it has only 3 columns
for sample in *.bed
 	do  
 	echo $sample
   	awk '{print $1 "\t" $2 "\t" $3}' $sample > $processed$sample
done