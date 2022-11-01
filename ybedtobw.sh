#!/bin/bash
#This script will convert BED files in the working directory to BIGWIG.
#Note it specifies conversion of yeast genome data by directing to sacCer3chrom.sizes on dauble.
#Input bed MUST be sorted first using:
#sort -k 1,1 in.bed > in.sorted.bed
#generate bigwig files (for yeast):
for i in ./*.bed; do echo $i; bedtools genomecov -i $i -g ~/gentools/chromsize/sacCer3chrom.sizes -bg > $i.cov; bedGraphToBigWig $i.cov ~/gentools/chromsize/sacCer3chrom.sizes $i.bw; done