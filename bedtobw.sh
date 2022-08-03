#!/bin/bash
#This script will convert BED files in the working directory to BIGWIG.
#Note it specifies conversion of human genome data by directing to hg19chrom.sizes on dauble.
#Input bed MUST be sorted first using:
#sort -k 1,1 in.bed > in.sorted.bed
#generate bigwig files (for human):
for i in ./*.bed; do echo $i; bedtools genomecov -i $i -g ~/gentools/chromsize/hg19chrom.sizes -bg > $i.cov; bedGraphToBigWig $i.cov ~/gentools/chromsize/hg19chrom.sizes $i.bw; done