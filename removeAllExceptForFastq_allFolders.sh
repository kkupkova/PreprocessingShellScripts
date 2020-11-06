#!/bin/bash
# go through the subdirectories and keep only .fastq.gz files

#go through the subdirectories within our directory
for folder in */
	do
		#change pathway to the subdirectory and make a new subdirectory there for results
		cd $folder
		# remove all except .fastq.gz
		find . -type f ! -name '*.fastq.gz' -delete
		rm -rf fastqc_results
		rm -rf intermediary_files
		cd ..
done



