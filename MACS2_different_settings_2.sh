#!/bin/bash
# the script calls peaks with different settings
# also with and without input control

echo -e What is the name of the control dataset?
read controlSample

# get all of the BAM files in the folder and use the characters before the first occurence
# of "." as the sample ID

mkdir broad_withInput
mkdir broad_noInput
mkdir broad_05_noInput
mkdir broad_005_noInput
for sample in *.bam  
 do  
   id="$( cut -d '_' -f 1 <<< "$sample" )"
   echo $id

   
   macs2 callpeak -t $sample -c $controlSample -n $id -g hs -f BAM --broad --outdir ./broad_withInput
   
   macs2 callpeak -t $sample -n $id -g hs -f BAM --broad --outdir ./broad_noInput
   
   macs2 callpeak -t $sample -n $id -g hs -f BAM --broad --broad-cutoff 0.05  --outdir ./broad_05_noInput
   
   macs2 callpeak -t $sample -n $id -g hs -f BAM --broad --broad-cutoff 0.005  --outdir ./broad_005_noInput
   
done
