#!/bin/bash

# the script maps all fastq files within a folder to sacCer3, removes unmapped reads
# and creates FASTQ files from the unmapped reads

# get bowtie2 index and define blacklisted sites
sacCer3index="/Users/lilcrusher/bowtie2-2.2.6/indexes/sacCer3/sacCer3"
nonYeast='_nonYeast'

# now do the mapping etc.
for zippedFastq in *.fastq.gz 
do 
	# get the fastq file name and clean file name without any extensions
	fastqFile="${zippedFastq%.*}"
	fileName="${zippedFastq%%.*}"
				
	# first unzip the file
	gunzip $zippedFastq
				
	# Map to sacCer3 with bowtie2
	echo "Mapping following file:"
	echo $fastqFile
				
	unsortedBAM="${fileName}_unsorted.bam"
	bowtie2 -x $sacCer3index -p 6 --time -U $fastqFile | samtools view -S -b - > $unsortedBAM
				
	#sort and index the bam file
	sorted="${fileName}_sorted"
	sortedBAM="${sorted}.bam"
	sortedBAI="${sortedBAM}.bai"
	samtools sort $unsortedBAM $sorted
	samtools index $sortedBAM
				
	# remove the unsorted BAM file
	rm $unsortedBAM
			
	#filter unmapped reads
	filteredBAM="${fileName}_filtered.bam"
	echo -e The numbers of mapped and unmapped reads, respectively:
	samtools view -c -F 4 $sortedBAM
	samtools view -c -f 4 $sortedBAM
	samtools view -h -F 4 -b $sortedBAM > $filteredBAM
	
	# filter out the reads mapped to the yeast = only unmapped stay ->
	# transform the BAM file to FASTQ file using bedtools
	nonYeastBAM="${fileName}__nonYeast.bam"
	nonYeastFASTQ="${fileName}__nonYeast.fastq"
 	samtools view -b -f 4 $sortedBAM > $nonYeastBAM
 	bedtools bamtofastq -i $nonYeastBAM -fq $nonYeastFASTQ
				
	# remove unfiltered files
	rm $sortedBAM
	rm $sortedBAI
			
	#sort and index mapped BAMs
	sorted="${fileName}_filtered_sorted"
	sortedBAM="${sorted}.bam"
	sortedBAI="${sortedBAM}.bai"
	samtools sort $filteredBAM $sorted
	samtools index $sortedBAM
				
	# remove unsorted file
	rm $filteredBAM

done

#use a python script to get the values from the resulting text file and make an
# excel table
python2.7 /Users/lilcrusher/scripts/TxtToXls_forLoop.py
