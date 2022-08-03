#!/bin/bash
#The script takes all the narrowPeak files, transforms them into simple bed files -> 
# these are then merged into the MasterPeaks.bed file by bedtools and the unnecessary bed 
#files are removed
for sample in *.narrowPeak 
 do  
   id="$( cut -d '.' -f 1 <<< "$sample" )"
   awk '{print $1 "\t" $2 "\t" $3}' $sample > $id.bed
done

cat *.bed | sort -k1,1 -k2,2n | bedtools merge -i stdin > MasterPeaks.bed
#ls *.bed| grep -v MasterPeaks.bed | xargs rm