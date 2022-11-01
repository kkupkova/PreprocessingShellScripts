#!/bin/bash

CpG='CpG_'

#unzip files:
for bedfile in *.bed.gz
do
	echo ${bedfile%".gz"}
	bedName=${bedfile%".gz"}
	gunzip -c $bedfile | sort -k 1,1 -k2,2n \
	 | bedtools intersect -a $ANNOTATION/cpgIslandsReduced.hg38.bed -b stdin > $CpG$bedName
done
