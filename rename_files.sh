#!/bin/bash
#The script takes all the files within the folder with predefined extension (here: .bed.hg19)
# to extension specified behind the curly bracket (here: _hg19.bed)


# Rename all *.bed.hg19 to *_hg19.bed
for f in *.bed.hg19; do 
    mv -- "$f" "${f%.bed.hg19}_hg19.bed"
done