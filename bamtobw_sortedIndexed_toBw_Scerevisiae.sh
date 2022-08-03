#!/bin/bash
#This script will convert  sorted and indexed BAM files in the working directory to BIGWIG.
#Note it specifies conversion of human genome data by directing to hg19chrom.sizes on local computer.

#generate bed files:
#for i in *sorted.bam; do bedtools bamtobed -i $i > $i.bed; done
#generate bigwig files (for human):
for i in *.bed; do echo $i; bedtools genomecov -i $i -g ~/gentools/chromsize/sacCer3_ensemblchrom_chrom.sizes -bg > $i.cov; bedGraphToBigWig $i.cov ~/gentools/chromsize/sacCer3_ensemblchrom_chrom.sizes $i.bw; done