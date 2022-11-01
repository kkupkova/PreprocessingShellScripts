#!/bin/bash
#  run without any input argument

mkdir unmapped
mkdir hg19
for bedFile in *.bed
do
  ID=${bedFile%"_sort_peaks.narrowPeak.bed"}
  final_name="${bedFile%"sort_peaks.narrowPeak.bed"}hg19_peaks.bed"
  echo $ID
  awk '{print $1 "\t" $2 "\t" $3}' $bedFile > 3columns.bed
  liftOver 3columns.bed /Users/kristyna/annotation_files/hg38ToHg19.over.chain $final_name ${ID}_unmapped.bed

  mv $final_name hg19
  mv ${ID}_unmapped.bed unmapped
  rm 3columns.bed
done
