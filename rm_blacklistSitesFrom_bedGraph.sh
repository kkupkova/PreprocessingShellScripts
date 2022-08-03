#!/bin/bash

# remove blacklisted sited from bedGraph - convert to bw 

# create directories where results will be moved at the end
mkdir blacklisted_sites_removed
mkdir /Volumes/BackUp_AubleLab/ENCODE_bigWigs/primaryCell_merged_bigWig/blacklisted_sites_removed

for i in *.bedGraph
do 
	# get the file name without suffix
	cell="${i%.*}"
	echo $cell
	
	# define file names - add suffix _blRemoved to both bedGraph and bigWig
	bgFile=$cell"_blRemoved.bedGraph"
	bwFile=$cell"_blRemoved.bw"

	# remove the blacklisted sites
	bedtools subtract -a $i -b /Users/lilcrusher/scripts/blacklisted_sites/sorted_consensusBlacklist.bed -A > $bgFile

	#convert bedGraph to bigWig
	bedGraphToBigWig $bgFile ~/gentools/chromsize/hg19chrom.sizes $bwFile
	
	mv $bgFile blacklisted_sites_removed
	mv $bwFile /Volumes/BackUp_AubleLab/ENCODE_bigWigs/primaryCell_merged_bigWig/blacklisted_sites_removed

done
