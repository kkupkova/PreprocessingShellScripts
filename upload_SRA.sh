#!/bin/bash

for F in ./*.fastq.gz
do
/Applications/Aspera\ Connect.app/Contents/Resources/ascp -i /Users/lilcrusher/epigen_mal/H3K27ac/53wk/dbGap_FASTQ/mykey -l 200m -k 1 $F asp-sra@gap-submit.ncbi.nlm.nih.gov:protected
done
