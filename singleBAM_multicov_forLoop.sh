#!/bin/bash
# DESCRIPTION!!!
# this script is used when bedtools multicov gives an error on multiple BAM 
# files (header problem) - but it works on single BAM files -> the script goes
# through the BAM files in the folder and maps each one individually



# make a directory, where the files should be stored
echo -e What is the BED file you want the BAM files to be mapped onto? # drag the folder to the console
read bedFile

echo -e Give a name of a output directory # drag the folder to the console
read outDir

mkdir $outDir

for f in *.bam
do
	# get the filename before dot
	fileName="${f%.*}"
	echo $fileName
	
	# create name for an output count table
	countTable="${outDir}/counts_${fileName}.txt"
	
	# run bedtools multicov
	bedtools multicov -bams $f -bed $bedFile > $countTable
done

echo "Done!"
