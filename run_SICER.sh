#!/bin/bash

#this script must be placed in scripts directory!!
# !!!!Replace it with your own directory!!!
SICER=/Users/beast/SICER_V1.1/SICER

#["InputDir"] ["bed file"] ["control file"] ["OutputDir"] ["Species"] ["redundancy threshold"] ["window size (bp)"] ["fragment size"] ["effective genome fraction"]   ["gap size (bp)"] ["FDR"]
#note that here the output is specified by "." after the bed files as located in the working directory
#standard run
#sh $SICER/SICER.sh /Users/beast/epigen_mal/H3K9me3/testSICER 1398.sorted.bl.bam.bed 1398_input.sorted.bl.bam.bed . hg19 1 200 425 0.74 600 .01
#for broader peaks (10-100kb scale) and resolution around 1 kb
#sh $SICER/SICER.sh /Users/beast/epigen_mal/H3K9me3/moms/SICER_broad_peak_processing M1498.sorted.bl.bam.bed M1407In.sorted.bl.bam.bed . hg19 1 1000 425 0.74 5000 .01
sh $SICER/SICER.sh /Users/beast/epigen_mal/H3K9me3/SICER M1661.sorted.bl.bam.bed M1407In.sorted.bl.bam.bed . hg19 1 1000 425 0.74 5000 .01