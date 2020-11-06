#!/bin/bash
# zip the fastq files in a folder
for i in *.fastq; do gzip $i ; done
