#!/bin/bash

#This script gets all the BAM files present in the folder and runs peak calling with
# MACS 1.4.2. It requires the name of the input, which will be used as control in 
# peak calling

#first get the control dataset name- get the name also with the pathway to the file
#make sure, that the control dataset is placed into a different folder, otherwise it would run 
#the peak calling also on the input

# get all of the BAM files in the folder and use the characters before the first occurence
# of "." as the sample ID
for sample in *.bam  
 do  
   id="$( cut -d '.' -f 1 <<< "$sample" )"
   macs14 -t $sample -g mm -n $id -B -S --call-subpeaks
done
