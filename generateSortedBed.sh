 #!/bin/bash
 #run script as e.g. $ generateSortedBed.sh 1000
 # argument = the width of the region around TSS
 
 # make paramater for -l in bedtools flank one higher, so we get odd number (TSS in the center
 # and desired region around)
 l_param=$(($1 +1)) 

echo "The region size on both sides from TSS is $1"

#first remove the head from the bed file ($1 is the first parameter fed to the script and 
#it is the name of the text file with gene positions)
# | add dots for gene names |add another dots for score | reorder so we get bed file in formal format:
# chrom 	start	end	name	score	strand
tail -n +2 /Users/lilcrusher/scripts/myNgsPlot/TSS.bed | awk '$(NF+1) = "."' | awk '$(NF+1) = "."' | \
 awk '{print $1 "\t" $3 "\t" $4 "\t" $5 "\t" $6 "\t" $2}' | \
 
 # bedtools flank adds region of the size which is passed to parameter $1 prior to the TSS
 # bedtools slop adds the same region after the TSS
 bedtools flank -g /Users/lilcrusher/scripts/myNgsPlot/hg19.genome -l $l_param -r 0 -s|bedtools slop -l 0 -r $2 -s -g /Users/lilcrusher/scripts/myNgsPlot/hg19.genome | \
 
 #sort the file by chromosome name -> start site -> and by directionality
 sort  -o sortedBed.bed -u -k 1,1 -k 2,2n -k 6,6