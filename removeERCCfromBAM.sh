#!/bin/bash
#the script goes throug the BAM files and removes all ERCCs from them
# =removes all lines which contain "ERCC-" in them 
SAM=".sam"
nonERCC="non_ERCC"
for sample in *.bam  
 do  
   echo "The processed bam file is $sample"
   #samtools idxstats $sample | cut -f 1 | grep -v ERCC | xargs samtools view -b $sample > $nonERCC$sample
   
   samtools view -h -o $sample$SAM $sample
   sed '/ERCC-/d' < $sample$SAM > $nonERCC$sample$SAM
   
   rm $sample$SAM
   
   samtools view -Sb $nonERCC$sample$SAM > $nonERCC$sample

   rm $nonERCC$sample$SAM
   
done

