#!/bin/bash
#run this script from the folder with ROSE scripts:

#first BAM file is the analyzed BAM file
echo -e What is the name of the BAM file?
read BAMfile

# second BAM file is an input
echo -e What is the name of the control BAM file?
read control

# GFF file is generated from .broadPeak file from MACS2:
# awk '{print $1 "\t" $4 "\t" "\t" $2 "\t" $3 "\t" "\t" $6 "\t" "\t" $4}' *.broadPeak > example.gff
# -> now run shell script from folder containing broadPeak files: BroadPeakToGff.sh

echo -e What is the name of the gff file?
read peaks

echo -e Where should be the output files be placed?
read output


python ROSE_main.py -g HG19 -i $peaks -r $BAMfile -c $control -o $output -s 12500 -t 2500

