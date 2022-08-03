#!/bin/bash
# DESCRIPTION!!!
#!/bin/bash
#This script will convert BAM files in the working directory to BIGWIG.


#generate bigwig files (for human):
for f in *.bam
do
	fileName="${f%.*}"
	echo $fileName
	sortedFile="sorted_$fileName"
	sortedBAM="${sortedFile}.bam"
	echo $sortedFile
	echo $fileName
	samtools sort $f $sortedFile
    samtools index $sortedBAM
done

