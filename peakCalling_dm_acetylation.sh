#!/bin/bash

#This script gets all the BAM files present in the folder and runs peak calling with
# MACS 2 It requires the name of the input, which will be used as control in 
# peak calling

#first get the control dataset name- get the name also with the pathway to the file
#make sure, that the control dataset is placed into a different folder, otherwise it would run 
#the peak calling also on the input

echo -e What is the name of the control dataset?
read controlSample

# get all of the BAM files in the folder and use the characters before the first occurence
# of "." as the sample ID
for sample in *.bam  
 do  
   id="$( cut -d '.' -f 1 <<< "$sample" )"
   #mkdir $id
   macs2 callpeak -t $sample -c $controlSample -n $id --broad -g dm --broad-cutoff 0.01 --outdir ./$id

done

