#!/bin/bash
#This script will map FASTQ files in batch to human hg19 genome using bowtie2, then convert the output to BAM, filter unmapped reads and sort and index the filtered BAM file
#To capture the screen output in a file use this command syntax: nohup batchtobam.sh > batchoutput.out & (ampersand to run in background, leave off to run in foreground)
#unzip files:
for i in ./*.fastq.gz; do gunzip $i; done

#map to genome, convert to bam
for i in ./*.fastq; do bowtie2 -x /Users/dauble/bowtie2-2.2.6/indexes/hg19/hg19 -p 3 --time -U $i | samtools view -S -b - > $i.bam; done 

#filter and sort
for i in ./*.bam; do samtools view -c -F 4 | samtools view -c -f 4 | samtools view -h -F 4 -b $i > $i.filtered.bam; done 

#sort and index
for i in ./*.filtered.bam; do samtools sort > $i.sorted; done

#index:
for i in ./*.sorted.bam; do samtools index $i $i.bai; done