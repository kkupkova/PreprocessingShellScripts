#!/bin/bash
# script goes throught the fastq files in the folder- unzips - maps to yeast and reports statistics in an excel sheat
#unzip files:

#unzip files:
for i in ./*.fastq.gz; do gunzip $i; done

#map to genome, convert to bam
for i in ./*.fastq; do bowtie2 -x /Users/lilcrusher/bowtie2-2.2.6/indexes/sacCer3/sacCer3 -p 6 --time -U $i | samtools view -S -b - > $i.bam 
echo $i
done 

#use a python script to get the values from the resulting text file and make an
# excel table
python2.7 /Users/lilcrusher/scripts/TxtToXls_yeast.py



