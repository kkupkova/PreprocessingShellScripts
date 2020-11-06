#!/bin/bash
# takes 4th column of bedGraph and normalized values so they fall into 0-1 range
# then converts the normalized bedGraph file to bigWig file

# create directories where the output files will be stored
mkdir /Volumes/BackUp_AubleLab/ENCODE_bigWigs/GRCh38/primaryCell_merged_bedGraphs_cleanAndNormalized  
mkdir /Volumes/BackUp_AubleLab/ENCODE_bigWigs/GRCh38/primaryCell_merged_bigWig_cleanAndNormalized

for i in *.bedGraph
do 

	# get the file name without suffix
	cell="${i%.*}"
	echo $cell

	
	# define file names - add suffix _normalized to both bedGraph and bigWig
	bgFile=$cell"_normalized.bedGraph"
	bwFile=$cell"_normalized.bw"

	# normalize data - datailed explanation in "Cell_specificity_in_elements" notes
	echo "normalizing track 0-1"
	awk 'NR==1 { max=$4 ; min=$4 }
     FNR==NR { if ($4>=max) max=$4 ; $4<=min?min=$4:0 ; next}
     { $4=($4-min)/(max-min) ; print }' $i $i > $bgFile

	#convert bedGraph to bigWig
	echo "convert to bigWig"
	bedGraphToBigWig $bgFile ~/Users/lilcrusher/annotations/chromsize/hg38.chrom.sizes $bwFile
	
	
	mv $bgFile /Volumes/BackUp_AubleLab/ENCODE_bigWigs/GRCh38/primaryCell_merged_bedGraphs_cleanAndNormalized  
	mv $bwFile /Volumes/BackUp_AubleLab/ENCODE_bigWigs/GRCh38/primaryCell_merged_bigWig_cleanAndNormalized
	
done
