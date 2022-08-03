#!/bin/bash
#This script will convert BAM files in the working directory to BIGWIG.
#Note it specifies conversion of Drosophila genome data by directing to dm6chrom.sizes on dauble.
#generate sorted BAM files:
for i in ./*.bam; do samtools sort $i $i.sorted; done
#generate index files:
for i in ./*.sorted.bam; do samtools index $i $i.bai; done
#generate bed files:
for i in ./*.sorted.bam; do bedtools bamtobed -i $i > $i.bed; done
#generate bigwig files (for human):
for i in ./*.bed; do echo $i; bedtools genomecov -i $i -g ~/gentools/chromsize/dm6chrom.sizes -bg > $i.cov; bedGraphToBigWig $i.cov ~/gentools/chromsize/dm6chrom.sizes $i.bw; done