#!/bin/bash
# the script selects columns containing information about

known="known_"
for file_name in *.bed
do 
grep -e chr1 -e chr2 -e chr3 -e chr4 -e chr5 -e chr6 -e chr7 -e chr8 -e chr9 -e chrX -e chrY $file_name > $known$file_name
done
