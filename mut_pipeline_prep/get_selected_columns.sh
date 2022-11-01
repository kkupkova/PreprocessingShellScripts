#!/bin/bash
# the script selects columns containing information about chrom / start/ end/ from / to/ donor_ID 
# removes the header, adds chr before chromosome number,  and sorts the final file 


for file_name in *.tsv
do 



filtered="filteredColumns_$file_name"

#cut -f9,10,11,16,17,2 file_name > outfile.tsv
# do not use cut, does not keep the predefined order -> use awk

# first awk command selects column in specific order | second awk command adds chr to the first column | 
#tail removes header | sort the file file
awk -v OFS="\t" -F"\t" '{print $9, $10, $11, $16, $17, $2}' $file_name | 
awk 'BEGIN{FS="\t"; OFS="\t"} {if(NR>1) $1="chr"$1; print}' | tail -n +2 | sort -k 1,1 -k2,2n  > $filtered

### explanation for the first awk
# -F"\t" is what to cut on exactly (tabs).
# -v OFS="  " is what to seperate with (two spaces)
done
