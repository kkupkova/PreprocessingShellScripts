 #!/bin/bash
 
bedtools coverage -a /Users/lilcrusher/scripts/myNgsPlot/sortedBedFromBedtools.bed -b merged_control_53wk.bam.sorted.bam -d -sorted > coverage.bed
 # bedtools merge with argument collapse gives the single nucleotide resolution for 
 # each region | change all the commas to tab
 bedtools merge -c 8 -o collapse -d -2001 -s  -i coverage.bed | tr "," "\t" > output_control.bed
 
 #remove the files, which are no longer necessary
 rm coverage.bed
 
 samtools view -c -F 4 merged_control_53wk.bam.sorted.bam > libsize_control.txt
 

#python /Users/lilcrusher/scripts/averagePlot.py output.bed libsize.txt 1000
 

bedtools coverage -a /Users/lilcrusher/scripts/myNgsPlot/sortedBedFromBedtools.bed -b merged_stunted_53wk.bam.sorted.bam -d -sorted > coverage.bed

bedtools merge -c 8 -o collapse -d -2001 -s  -i coverage.bed | tr "," "\t" > output_stunted.bed
 
 #remove the files, which are no longer necessary
 rm coverage.bed
 
 samtools view -c -F 4 merged_control_53wk.bam.sorted.bam > libsize_stunted.txt
 
 python averagePlot.py output_control.bed libsize_control.txt 1000
 
 python averagePlot.py output_stunted.bed libsize_stunted.txt 1000