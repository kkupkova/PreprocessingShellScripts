 #!/bin/bash

# The script goes through 
# all of the bam files in the folder and creates bw files:
# we use two different normalization methods: read count normalization
# or SES normalization - similar to DESeq2


mkdir bw_RPKMnorm
mkdir bw_notNorm

# go through the .bw files in the folder
for bamFile in *.bam
do 
	# extract file name - everything before the first dot
	fileName="${bamFile%%.*}"
	
	
	bw_RPKM="${fileName}_RPKMnorm.bw"
	bw_notNorm="${fileName}_notNorm.bw"
	
	# 1) subtract read count normalized
	echo "Generating bigWig from ${bamFile}: read count normalization"
	bamCoverage -b $bamFile -o $bw_RPKM -of bigwig --normalizeUsing RPKM -p 10
	
	# 2) subtract SES normalized
	echo "Generating bigWig from ${bamFile}: no normalization"
	bamCoverage -b $bamFile -o $bw_notNorm -of bigwig -p 10
	
	
	# move the processed files to the final destination 
	mv $bw_RPKM bw_RPKMnorm
	mv $bw_notNorm bw_notNorm

done
