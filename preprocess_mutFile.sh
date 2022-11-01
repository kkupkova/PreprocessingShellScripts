#!/bin/bash
# This script is used to process the "single somatic mutations" files downloaded from 
# ICGC. The input is gzipped TSV file and output is a processed TSV file with following 
# columns:
# chromosome	start	end	mutated_from	muatated_to	donor_id

#============Description============
#===================================
# 1) run the script from within the directory containing .tsv.gz files
# 2) a new folder is made within the directory- all the final files will be placed here
# 3) files are unzipped
# 4) TSV file processing:
#	-1: select only mutations identified in WGS (grep lines with WGS in them, this
#		will also remove the header)
#	-2: select only single base substitutions = in/dels are removed
#	-3: select columns 9, 10, 11, 16, 17, 2 - these contain information about:
#		 chromosome, start, end, mutated_from, muatated_to, and donor_id respectively
#	-4: put "chr" string in front of the chromosome number
#	-5: sort by chromosome number and start
#	-6: select only unique rows- the mutation effect is predicted, therefore the same 
#		mutations in the same patient can have different effects predicted- we want only
#		the mutation and we don't want it duplicated
# 5) print the number of donors (+1..header) and total lines in the original TSV file
# 6) print the number of donors and final number of mutations in the processed file

# make a directory, where all the processed files will be placed
mkdir processed_files

#unzip all the files within the directory
for i in *.gz; do gunzip $i; done

#process all the TSV files
for TSV_file in *.tsv
do 

#make the name for the final file
filtered="uniq_filteredColumns_SBS_WGS_$TSV_file"

grep -E "WGS"  $TSV_file | grep -E "single base substitution" |
awk -v OFS="\t" -F"\t" '{print $9, $10, $11, $16, $17, $2}'| 
awk 'BEGIN{FS="\t"; OFS="\t"} {$1="chr"$1; print}' | sort -k 1,1 -k2,2n | uniq > $filtered

# echo stats for original file
echo The number of donors and mutations in $TSV_file are respectively:
awk < $TSV_file '{print $2}' | sort | uniq | wc -l
wc -l $TSV_file

# echo stats for the filtered file
echo The number of donors and mutations in the filtered file: $filtered are respectively:
awk < $filtered '{print $6}' | sort | uniq | wc -l
wc -l $filtered

# zip all the original files
gzip $TSV_file

# move the processed files to the prepared folder
mv $filtered processed_files

done
