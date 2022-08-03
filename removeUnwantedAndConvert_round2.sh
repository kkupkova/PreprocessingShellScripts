#!/bin/bash
# The script removes blacklisted sites and converts bedGraph to bigWog

mkdir /Volumes/BackUp_AubleLab/ENCODE_bigWigs/GRCh38/primaryCell_merged_bedGraph_2nRoundOfCleaning
#generate bed files:
for i in *.bedGraph
do
 cell="${i%_clean.bedGraph}"
 echo $cell
	
 # define file names - after additional blacklist sites removal
 cleanBg=$cell".bedGraph"
 bwFile=$cell".bw"
 
 # remove the blacklisted sites
 echo "remove blaclisted sites"
 bedtools subtract -a $i -b /Volumes/BackUp_AubleLab/ENCODE_bigWigs/GRCh38/additional_blackList_hg38.bed -A > $cleanBg
 
 #convert bedGraph to bigWig
 echo "convert to bigWig"
 bedGraphToBigWig $cleanBg /Users/lilcrusher/annotations/chromsize/hg38.chrom.sizes $bwFile
	
 mv $bwFile /Volumes/BackUp_AubleLab/ENCODE_bigWigs/GRCh38/primaryCell_merged_bigWig
 
 mv $cleanBg /Volumes/BackUp_AubleLab/ENCODE_bigWigs/GRCh38/primaryCell_merged_bedGraph_2nRoundOfCleaning
done
