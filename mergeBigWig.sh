#!/bin/bash

# script goes through subdirectories - merges bigWigs within the directory to 
# a bigWig named according to the directory - this produces bedGraph
# move it to a following directory: /Volumes/BackUp_AubleLab/ENCODE_bigWigs/primaryCell_bedGraphs

for f in *; do
    if [ -d "$f" ]; then
        # $f is a directory
        echo $f
        
        cd $f
        
        bigWigMerge *.bigWig $f.bedGraph
        
        mv $f.bedGraph /Volumes/BackUp_AubleLab/ENCODE_bigWigs/GRCh38/primaryCell_merged_bedGraphs
        
        cd ..
    fi
done


