#!/bin/bash

# script goes through subdirectories - merges bigWigs within the directory to 
# a bigWig named according to the directory - this produces bedGraph
# move it to a following directory: /Volumes/BackUp_AubleLab/ENCODE_bigWigs/primaryCell_bedGraphs
# convert the bedGraph to bigWig and move it to another dicrectory

# use refgenie to lookup chromosome sizes
chromSize=$(refgenie seek hg19/fasta.chrom_sizes)

for f in *; do
    if [ -d "$f" ]; then
        # $f is a directory
        echo $f
        
        cd $f
        
        # merge the bigWig files
        bigWigMerge *.bigWig $f.bedGraph
        # convert bedGraph to bigWig
        bedGraphToBigWig $f.bedGraph $chromSize $f.bw
        
        
        mv $f.bedGraph /Volumes/BackUp_AubleLab/ENCODE_files_cellSpecificity/hg19/primaryCells_merged_bedGraph
        mv $f.bw /Volumes/BackUp_AubleLab/ENCODE_files_cellSpecificity/hg19/primaryCells_merged_bigWig
        
        cd ..
    fi
done


