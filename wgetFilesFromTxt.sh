#!/bin/bash
# DESCRIPTION!!!
# example : wgetFilesFromTxt.sh txtWithFiles.txt 

# the script opens the txtWithFiles.txt ($1) - reads it line by line and copies the
# file on each line to the directory indicated in the second argument final/destination

file=$1 #text file to read the file names from

while IFS= read -r line
do
	wget $line
done <"$file"
