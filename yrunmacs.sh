#!/bin/bash
#This script will run macs for YEAST S. cerevisiae samples using the specified 'test' and 'control' BAM or SAM files in the working directory. $1=test file, $2=control file, $3=output file prefix
echo -e What is the name of the experimental dataset?
read name1
echo -e What is the name of the control dataset?
read name2
echo -e What prefix would you like added to the output files?
read name3
macs14 -t $name1 -c $name2 -g 1.2e7 -n $name3 -B -S --call-subpeaks