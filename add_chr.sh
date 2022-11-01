#!/bin/bash

for i in *.bed
do 
awk 'BEGIN{FS="\t"; OFS="\t"} {$1="chr"$1; print}' $i > "chr_"$i
done
