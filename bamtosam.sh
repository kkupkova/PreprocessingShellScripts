# convert BAM to SAM in batch (i.e. will convert all BAM files in the working directory to SAM).
for file in ./*.bam
    do
    echo $file 
    samtools view -h $file > ${file/.bam/.sam}
    done