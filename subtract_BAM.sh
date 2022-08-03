 #!/bin/bash

# The script first asks for control file and than goes through 
# all of the bam files in the folder and either subtracts the 
# control from the experimental file or creates a file with log2FoldChanges
# we use two different normalization methods: read count normalization
# or SES normalization - similar to DESeq2

echo -e What is the name of the control dataset?
read controlSample

mkdir subtracted_readCountNorm
mkdir log2FC_readCountNorm

# go through the .bw files in the folder
for bamFile in *.bam
do 
	# extract file name - everything before the first dot
	fileName="${bamFile%%.*}"
	
	# create file names for outputs
	subtractedRC="${fileName}_subtractedControl_readcountNorm.bw"
	subtractedSES="${fileName}_subtractedControl_SESnorm.bw"
	
	log2FC_RC="${fileName}_log2FCOverControl_readcountNorm.bw"
	log2FC_SES="${fileName}_log2FOoverControl_SESNorm.bw"
	
	# 1) subtract read count normalized
	echo "Subtracting ${controlSample} from ${bamFile}: read count normalization"
	bamCompare -b1 $bamFile -b2 $controlSample --scaleFactorsMethod readCount --operation subtract -p 10 -o $subtractedRC -of bigwig
	
	
	# 2) log2FoldChange read count normalized
	echo "Getting log2FC of ${bamFile} over ${controlSample}: read count normalization"
	bamCompare -b1 $bamFile -b2 $controlSample --scaleFactorsMethod readCount --operation log2 --pseudocount 1 -p 10 -o $log2FC_RC -of bigwig
	
	
	# move the processed files to the final destination 
	mv $subtractedRC subtracted_readCountNorm
	mv $log2FC_RC log2FC_readCountNorm

done
