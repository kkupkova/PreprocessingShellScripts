#!/bin/bash

# the script goes through subdirectories containing FASTQ files
# first all files are unzipped - then all FASTQ files from within a subdirectory
# are merged into one FASTQ file, which is named ccording to the sundirectory

# list everything within a folder
for directory in *; do
	# if $directory is a directory - then proceed
    if [ -d "$directory" ]; then
        
        # first report the directory name
        echo $directory
        
        # then go into the directory
        cd $directory
        
        # unzip all the fastq files
        for i in *.gz; do gunzip $i; done
        
        # merge all the fastq files into a large fastq file named after the directory
        cat *.fastq > $directory.fastq
        
        # zip all the files again
        for i in *.fastq; do gzip $i ; done
        
        # go back to the main directory
        cd ..
    fi
done


