#!/bin/bash
#NOTE THIS FOR MiSeq DATA!
#This script will map MiSeq FASTQ files for one particular sample to the human hg19 genome using bowtie2, then convert the output to BAM, filter unmapped reads, sort and index the filtered BAM file, convert to BigWig and run FastQC
#To capture the screen output in a file use this command syntax: nohup batchtofastqc.sh > batchoutput.txt & (ampersand to run in background, leave off to run in foreground)

#unzip files:
for i in ./*.fastq.gz; do gunzip $i; done

#map to genome, convert to bam
for i in ./*.fastq; do bowtie2 -x /Users/beast/bowtie2-2.2.6/indexes/hg19/hg19 -p 6 --time -U $i | samtools view -S -b - > $i.bam; done 

#sort and index the resulting bam file
for i in ./*.bam; do samtools sort $i $i.sorted; done
for i in ./*.sorted.bam; do samtools index $i $i.bai; done

echo -e The numbers of mapped and unmapped reads, respectively:

#filter unmapped reads
samtools view -c -F 4 *sorted.bam
samtools view -c -f 4 *sorted.bam
samtools view -h -F 4 -b *sorted.bam > filtered.bam

#sort and index
samtools sort filtered.bam filt.sorted
samtools index filt.sorted.bam

#filter blacklisted sites & make index for resulting file
bedtools intersect -abam filt.sorted.bam -b /Users/beast/scripts/blacklisted_sites/sorted_consensusBlacklist.bed -v > filt.sorted.bl.bam
samtools index filt.sorted.bl.bam

echo -e Final read count for this dataset after removal of blacklisted sequences:
samtools view -c -F 4 filt.sorted.bl.bam
echo -e The final bam file is called filt.sorted.bl.bam

#convert to BigWig
bedtools bamtobed -i filt.sorted.bl.bam > filt.sorted.bl.bam.bed
bedtools genomecov -i filt.sorted.bl.bam.bed -g ~/gentools/chromsize/hg19chrom.sizes -bg > filt.sorted.bl.bam.bed.cov; bedGraphToBigWig filt.sorted.bl.bam.bed.cov ~/gentools/chromsize/hg19chrom.sizes filt.sorted.bl.bam.bed.bw

#make directory for fastqc results
mkdir fastqc_results

#run fastqc and put results in the above directory
fastqc -o ./fastqc_results/ filt.sorted.bl.bam

#make directory for the intermediary files not needed anymore & move those files to it
mkdir intermediary_files
mv filtered.bam ./intermediary_files
mv filt.sorted.bam ./intermediary_files
mv filt.sorted.bam.bai ./intermediary_files