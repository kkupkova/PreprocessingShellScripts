#!/bin/bash
# the script gets the number of unique elements in a specified column: 

echo What is the column number you want to get the unique elements from?
read col_num

for file_name in *.tsv
do 

echo The number of donors in $file_name are:
awk < $file_name '{print $'$col_num'}' | sort | uniq | wc -l

#alternative:
#cut -f $col_num $file_name | sort | uniq | wc -l

done
