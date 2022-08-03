 #!/bin/bash

# The script first asks forr control file and than goes through 
# all of the bw files in the folder and either subtracts the 
# control from the experimental file or creates a file with log2FoldChanges

echo -e What is the name of the control dataset?
read controlSample

mkdir subtracted
mkdir log2FC

# go through the .bw files in the folder
for bwFile in *.bw
do 
	# extract file name - everything before the first dot
	fileName="${bwFile%%.*}"
	
	# create file names for outputs
	subtracted="${fileName}_subtractedControl.bw"
	log2FC="${fileName}_log2FCoverControl.bw"
	
	echo "Subtracting ${controlSample} from ${bwFile}"
	
	# 1) subtract
	bigwigCompare -b1 $bwFile -b2 $controlSample --operation subtract -p max/2 -o $subtracted -of bigwig
	
	echo "Getting log2FC of ${bwFile} over ${controlSample}"
	# 2) log2FoldChange
	bigwigCompare -b1 $bwFile -b2 $controlSample --operation log2 --pseudocount 1 -p max/2 -o $log2FC -of bigwig
	
	# move the processed files to the final destination 
	mv $subtracted subtracted
	mv $log2FC log2FC

done
