#!/bin/bash
# The script removes unwanted chromosomes and converts bedGraph to bigWig

#generate bed files:
for i in *.bedGraph
do
 cell="${i%.bedGraph}"
 echo $cell
	
 # define file name for file with unwanted chromosomes removed
 cleanBg=$cell"_clean1.bedGraph"
 
 # remove unwanted chromosomes
 echo "Removing unwanted chromosomes"
 sed '/chrM/d;/random/d;/chrUn/d;/hap/d;/chrY/d;/chrEBV/d' < $i > $cleanBg
 
 # define file names - add suffix _blRemoved to both bedGraph and bigWig
 bgFile=$cell"_clean.bedGraph"
 bwFile=$cell".bw"
 
 # remove the blacklisted sites
 echo "remove blaclisted sites"
 bedtools subtract -a $cleanBg -b /Users/lilcrusher/annotations/blacklistedSites/hg38_blacklist.bed -A > $bgFile
 
 #convert bedGraph to bigWig
 echo "convert to bigWig"
 bedGraphToBigWig $bgFile /Users/lilcrusher/annotations/chromsize/hg38.chrom.sizes $bwFile
	
 mv $cell.bw /Volumes/BackUp_AubleLab/ENCODE_bigWigs/GRCh38/primaryCell_merged_bigWig
 
 rm $cleanBg
 mv $bgFile /Volumes/BackUp_AubleLab/ENCODE_bigWigs/GRCh38/primaryCell_merged_bedGraph_1stRoundOfCleaning
done
