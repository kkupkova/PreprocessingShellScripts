#!/bin/bash
# DESCRIPTION!!!
# example : copy_files_from_txt_file.sh txtWithFiles.txt path/to/files final/destination

# the script opens the txtWithFiles.txt ($1) - reads it line by line and copies the
# file on each line to the directory indicated in the second argument final/destination

file=$1 #text file to read the file names from
copy_from=$2 #folder, where the coppied filenames are placed
copy_to=$3 # final destination
while IFS= read -r line
do
	cp "${copy_from}/${line}" $copy_to
done <"$file"
