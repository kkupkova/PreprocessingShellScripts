#!/bin/bash

sorted='sorted_'

#unzip files:
for bedfile in *.bed
do
	echo $sorted$bedfile
	# sort 1-2
	#sort -k 1,1V -k2,2n $bedfile -o $sorted$bedfile
	#sor 1-10
	sort -k 1,1 -k2,2n $bedfile -o $sorted$bedfile
done
