#!/bin/bash

# remove blacklisted sited from bedGraph - convert to bw 

# create directories where results will be moved at the end
mkdir blacklisted_sites_removed
mkdir /Volumes/BackUp_AubleLab/ENCODE_bigWigs/primaryCell_merged_bigWig/blacklisted_sites_removed

for i in *.bedGraph
do 
	# get the file name without suffix
	cell="${i%_blRemoved.bedGraph}"
	echo $cell
	
	# define file name for file with unwanted chromosomes removed
	cleanBg=$cell"_clean.bedGraph"
	
	# remove unwanted chromosomes
	echo "Removing unwanted chromosomes"
	sed '/chrM/d;/random/d;/chrUn/d;/hap/d;/chrY/d' < $i > $cleanBg
	
	# define file names - add suffix _blRemoved to both bedGraph and bigWig
	bgFile=$cell".bedGraph"
	bwFile=$cell".bw"

	# remove the blacklisted sites
	echo "remove blaclisted sites"
	bedtools subtract -a $cleanBg -b /Volumes/BackUp_AubleLab/ENCODE_bigWigs/additional_blackList.bed -A > $bgFile

	#convert bedGraph to bigWig
	echo "convert to bigWig"
	bedGraphToBigWig $bgFile ~/gentools/chromsize/hg19chrom.sizes $bwFile
	
	mv $bgFile blacklisted_sites_removed
	mv $bwFile /Volumes/BackUp_AubleLab/ENCODE_bigWigs/primaryCell_merged_bigWig/blacklisted_sites_removed

	# remove the file with just unwanted chromosomes removed prior to blacklisting
	rm $cleanBg
done
