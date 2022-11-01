#!/bin/bash
#I made the script to filter a mutation table without need to upload it to R, because th
#these tables can be rather large

#!!!!!!!!! IMPORTANT !!!!!!!!!!!!!!!!!
#I haven't figure out, how to keep the first line = the header in the script
#so this hase to be done after running the script separately:
#----------------------------------------------------------------------------
#printf '%s\n' '0r !head -n 1 $TSV_file' x | ex $filename
#	$TSV_file: original unfiltered file
#	$filename: the filtered table, where header should be inserted
#----------------------------------------------------------------------------

#unzip files:
for i in *.gz; do gunzip $i; done

# got through all TSV files and grep only lines which contain a certain pattern - here: WGS

for TSV_file in *.tsv
do 

#create a file name for the filtered table and write it on a screen 
filename="WGS_$TSV_file"
echo $filename

#take the original unfiltered table, run grep and save the file as: WGS_OriginalFileName
grep -E "WGS"  $TSV_file > $filename

#zip the file back in the end
#gzip $TSV_file

done

find . -name '*.tsv' | xargs wc -l