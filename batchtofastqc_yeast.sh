#!/bin/bash

#unzip files:
for i in ./*.fastq.gz; do gunzip $i; done

#map to genome, convert to bam
for i in ./*.fastq; do bowtie2 -x /Users/lilcrusher/bowtie2-2.2.6/indexes/sacCer3/sacCer3  -p 6 --time -U $i | samtools view -S -b - > $i.bam; done 

#sort and index the resulting bam file
#for i in ./*.bam; do samtools sort $i $i.sorted; done
#for i in ./*.sorted.bam; do samtools index $i $i.bai; done

#echo -e The numbers of mapped and unmapped reads, respectively:

#filter unmapped reads
#samtools merge merged.bam *.sorted.bam 
#samtools view -c -F 4 *sorted.bam
#samtools view -c -f 4 *sorted.bam
#samtools view -h -F 4 -b *sorted.bam > filtered.bam

#use a python script to get the values from the resulting text file and make an
# excel table
python /Users/lilcrusher/scripts/TxtToXls_yeast.py
