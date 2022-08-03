#!/bin/bash
# Goes through fastq files in a folder
# 1) map to mouse
# 2) select the unmapped sequences - non-mouse stay 
# 3) convert to fastq (the final fastq will have suffix corresponding to variable $nonHuman)

nonHuman='_nonMouse'
for i in *.fastq;
 do 
 	# ID= everything before "."
 	id="$( cut -d '.' -f 1 <<< "$i" )"
 	echo $id.bam
 	
 	#map the FASTQ file to the human genome
 	bowtie2 -x /Users/lilcrusher/bowtie2-2.2.6/indexes/mm10/mm10  -p 6 --time -U $i | samtools view -S -b - > $id.bam
 	
 	# filter out the reads mapped to the human = only unmapped stay
 	samtools view -b -f 4 $id.bam > $id$nonHuman.bam
 	
 	#transform the BAM file to FASTQ file using bedtools
 	bedtools bamtofastq -i $id$nonHuman.bam -fq $id$nonHuman.fastq
 		
done

































