#!/bin/bash
#The script takes all the BAM files present in a folder and  removes the duplicated reads
#the output is a new bam file called "dedulplicated_"+original_BAMname.bam

prefix='OpticalDeduplicated_'
txt='.txt'

for i in *.bam
do 
	id="$( cut -d '.' -f 1 <<< "$i" )"
	java -jar /Users/lilcrusher/gentools/picard.jar MarkDuplicates I=$i O=$prefix$i M=$prefix$id$txt REMOVE_SEQUENCING_DUPLICATES=true


done



#example
#java -jar /Users/lilcrusher/gentools/picard.jar MarkDuplicates I=47633705Sdm.filt.merged.sorted.bl.bam O=deduplicated.bam M=deduplicated.txt REMOVE_DUPLICATES=true


