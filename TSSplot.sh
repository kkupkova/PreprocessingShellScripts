 #!/bin/bash
 # first argument - the tab delimited text file with following columns: chrom	strand	start	end
 # second argument is the desired width around TSS
 
 # make paramater for -l in bedtools flank one higher, so we get odd number (TSS in the center
 # and desired region around)
 l_param=$(($2 +1)) 
 
echo "The list with genes is $1"

echo "The region size on both sides from TSS is $2"

echo "The processed bam file is $3"


#first remove the head from the text file ($1 is the first parameter fed to the script and 
#it is the name of the text file with gene positions)
# | add dots for gene names |add another dots for score | reorder so we get bed file in formal format:
# chrom 	start	end	name	score	strand
tail -n +2 $1 | awk '$(NF+1) = "."' | awk '$(NF+1) = "."' | \
 awk '{print $1 "\t" $3 "\t" $4 "\t" $5 "\t" $6 "\t" $2}' | \
 
 # bedtools flank adds region of the size which is passed to parameter $2 prior to the TSS
 # bedtools slop adds the same region after the TSS
 bedtools flank -g hg19.genome -l $l_param -r 0 -s|bedtools slop -l 0 -r $2 -s -g hg19.genome | \
 
 #sort the file by chromosome name -> start site -> and by directionality
 sort  -o sortedBed.bed -u -k 1,1 -k 2,2n -k 6,6
 
 # bedtools coverage with argument -d computes the coverage with single nucleotide
 # resolution
 bedtools coverage -a sortedBed.bed -b $3 -d > coverage.bed
 
 # bedtools merge with argument collapse gives the single nucleotide resolution for 
 # each region | change all the commas to tab
 bedtools merge -c 8 -o collapse -d -2001 -s  -i coverage.bed | tr "," "\t" > output.bed
 
 #remove the files, which are no longer necessary
 rm sortedBed.bed
 rm coverage.bed

 samtools view -c -F 4 $3 > libsize.txt
 

python /Users/lilcrusher/scripts/averagePlot.py output.bed libsize.txt $2
 
 rm libsize.txt
