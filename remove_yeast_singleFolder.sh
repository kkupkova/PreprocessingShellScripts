#!/bin/bash
#This script takes the present FASTQ sequences within a folder, mapsa them to a yeast genome and 
#creates a new FASTQ file containing the non-yeast sequences

#unzip the FASTQ files:
#unzip files:
for i in ./*.fastq.gz; do gunzip $i; done

# map the FASTQ file to the yeast genome -> get the unmapped reads and make a new FASTQ files out of them
NoYeast='_noYeast'

for i in *.fastq;
 do 
 	# ID= everything before "."
 	id="$( cut -d '.' -f 1 <<< "$i" )"
 	echo $id.bam
 	
 	#map the FASTQ file to the yeast genome
 	bowtie2 -x /Users/lilcrusher/bowtie2-2.2.6/indexes/sacCer3/sacCer3  -p 6 --time -U $i | samtools view -S -b - > $id.bam
 	
 	# filter out the reads mapped to the yeast = only unmapped stay
 	samtools view -b -f 4 $id.bam > $id$NoYeast.bam
 	
 	#transform the noYeast BAM file to FASTQ file using bedtools
 	bedtools bamtofastq -i $id$NoYeast.bam -fq $id$NoYeast.fastq
 	
 	
done

































