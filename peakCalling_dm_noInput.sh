#!/bin/bash

#This script gets all the BAM files present in the folder and runs peak calling with

# get all of the BAM files in the folder and use the characters before the first occurence
# of "." as the sample ID
for sample in *.bam  
 do  
   id="$( cut -d '.' -f 1 <<< "$sample" )"
   macs14 -t $sample -g dm -n $id -B -S --call-subpeaks
done
