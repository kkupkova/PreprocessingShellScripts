#!/bin/bash
#go through all subdirectories in the master directory 
# 1) map to yeast 
# 2) get only unmapped yeast
# 3) convert BAM to FASTQ
#set up part of prefix for fastq name
NoYeast='_noYeast'


#go through the subdirectories within our directory
for folder in */
	do
		#change pathway to the subdirectory and make a new subdirectory there for results
		cd $folder
		mkdir cleansed_FASTQ
		
		#unzip files:
		for i in ./*.fastq.gz; do gunzip $i; done
		
		#go through all the present fastq files
		for i in *.fastq;
 			do 
 				# ID= everything before "."
 				id="$( cut -d '.' -f 1 <<< "$i" )"
 				echo "Processing following FASTQ file:"
 				echo $id
 	
 				#map the FASTQ file to the yeast genome
 				bowtie2 -x /Users/lilcrusher/bowtie2-2.2.6/indexes/sacCer3/sacCer3  -p 6 --time -U $i | samtools view -S -b - > $id.bam
 				
 				echo "Filtering out the mapped reads"
 				# filter out the reads mapped to the yeast = only unmapped stay
 				samtools view -b -f 4 $id.bam > $id$NoYeast.bam
 				
 				echo "Generating FASTQ file"
 				#transform the noYeast BAM file to FASTQ file using bedtools
 				bedtools bamtofastq -i $id$NoYeast.bam -fq $id$NoYeast.fastq
 				
 				echo "Zipping and removing unnecessary files"
 				#zip the fastq files back
 				gzip $i
 				gzip $id$NoYeast.fastq
 				
 	
 				#remove the unnecessary files
 				rm $id.bam
 				rm $id$NoYeast.bam
 	
 				mv $id$NoYeast.fastq.gz ./cleansed_FASTQ
 	
		done
		
		#go back to the original directory
		cd ..
done

echo "Done!"


