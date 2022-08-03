#!/bin/bash
#This is script for already mapped Drosophila reads- it takes the bam files presented in current folder
# and creates BigWig files out of them


#get bam files

for i in *.bam; do


echo "Processing $i"

bed='.bed'
cov='.cov'
bw='.bw'


#convert to BigWig
bedtools bamtobed -i $i > $i$bed
bedtools genomecov -i $i$bed -g ~/gentools/chromsize/dm6chrom.sizes -bg > $i$bed$cov; bedGraphToBigWig $i$bed$cov ~/gentools/chromsize/dm6chrom.sizes $i$bed$bw

done


echo "All done!"