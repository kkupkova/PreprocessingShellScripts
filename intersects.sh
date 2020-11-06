#!/bin/bash
# The script take all bed files in a folder. Intersects them with the master bed file 
# and reports overlaps.

echo -e What is the name of the BED file that should be intersected with all bed files in this folder?
read masterBed

mkdir intersect_results
for sample in *.bed
 do  
   id="$( cut -d '.' -f 1 <<< "$sample" )"
   sampleName="${id}_intersect.bed"
   bedtools intersect -a $masterBed -b $sample -wao > $sampleName
   mv $sampleName intersect_results
done