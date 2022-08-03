 #!/bin/bash
 #get BAM file name
echo -e What is the name of the bam file you want to plot?
read name1

#compute coverage with single nucleotide resolution
bedtools coverage -a /Users/lilcrusher/scripts/myNgsPlot/sortedBedFromBedtools.bed -b $name1 -d -sorted > coverage.bed

# transform the data into suitable form
bedtools merge -c 8 -o collapse -d -2001 -s  -i coverage.bed | tr "," "\t" > output.bed
 
 #remove the files, which are no longer necessary
 rm coverage.bed
 
 #get library size
 samtools view -c -F 4 $name1 > libsize.txt
 
 #run python script to make normalized average plot
 python /Users/lilcrusher/scripts/averagePlot.py output.bed libsize.txt 1000