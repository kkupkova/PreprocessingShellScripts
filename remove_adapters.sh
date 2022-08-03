#!/bin/bash


INPUT=adapters.csv
OLDIFS=$IFS
IFS=','
[ ! -f $INPUT ] && { echo "$INPUT file not found"; exit 99; }
while read fastq adapter
do
	echo "FASTQ file : $fastq"
	echo "adapter : $adapter"
done < $INPUT
IFS=$OLDIFS

