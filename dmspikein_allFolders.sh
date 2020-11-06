#!/bin/bash
#NOTE THIS IS FOR NextSeq DATA! - each batch is placed in its own folder- script goes through all folders within the current one and perfoms following: 
#This script will map NextSeq FASTQ files in batch for one particular sample to the Drosophila dm6 genome using bowtie2, then convert the output to BAM, merge the individual files from each flow cell, filter unmapped reads, sort and index the filtered BAM file, and filter reads from blacklisted sites
#To capture the screen output in a file use this command syntax: nohup batchtofastqc.sh > dmspikein_allFolders.txt & (ampersand to run in background, leave off to run in foreground)

#go through the subdirectories within our directory
for folder in */
	do
		#change pathway to the subdirectory and make a new subdirectory there for results
		cd $folder
		#unzip files:
		for i in ./*.fastq.gz; do gunzip $i; done

#map to genome, convert to bam
		for i in *.fastq 
			do
				echo "Processing following FASTQ file:"
 				echo $i
				bowtie2 -x /Users/lilcrusher/bowtie2-2.2.6/indexes/dm6/genome -p 6 --time -U $i | samtools view -S -b - > $i.bam
				gzip $i
		done 

		#sort and index the resulting bam files
		for i in ./*.bam; do samtools sort $i $i.sorted; done
		for i in ./*.sorted.bam; do samtools index $i $i.bai; done

		echo -e The numbers of mapped and unmapped reads, respectively:

		#merge bams, filter unmapped reads
		samtools merge merged.bam *.sorted.bam 
		samtools view -c -F 4 merged.bam
		samtools view -c -f 4 merged.bam
		samtools view -h -F 4 -b merged.bam > filtered.merged.bam

		#sort and index
		samtools sort filtered.merged.bam filt.merged.sorted
		samtools index filt.merged.sorted.bam
		
		#filter blacklisted sites & make index for resulting file
		bedtools intersect -abam filt.merged.sorted.bam -b /Users/lilcrusher/scripts/blacklisted_sites/sorted_dm6Blacklist.bed -v > filt.merged.sorted.bl.bam
		samtools index filt.merged.sorted.bl.bam

		echo -e Final read count for this dataset after removal of blacklisted sequences:
		samtools view -c -F 4 filt.merged.sorted.bl.bam
		echo -e The final bam file is called filt.merged.sorted.bl.bam

		#make directory for the intermediary files not needed anymore & move those files to it
		mkdir intermediary_files
		mv merged.bam ./intermediary_files
		mv filtered.merged.bam ./intermediary_files
		mv filt.merged.sorted.bam ./intermediary_files
		mv filt.merged.sorted.bam.bai ./intermediary_files
		
		#go back to the original directory
		cd ..
done

#use a python script to get the values from the resulting text file and make an
# excel table
python2.7 /Users/lilcrusher/scripts/TxtToXls_forLoop.py