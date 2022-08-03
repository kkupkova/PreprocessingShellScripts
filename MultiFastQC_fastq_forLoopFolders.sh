 #!/bin/bash
 
# The script goes through subdirectories in the current directory
# runs FASTQC on the available fastq files, stores the results
# in folder names fastqc_fastq and finally multiqc is run too

# get the name of current directory
currentDir=$(pwd)

# create folder in current directory, where all fastqc files will be stored
mkdir fastqc_fastq

fastqcDir="${currentDir}/fastqc_fastq"
echo "$fastqcDir"

# go through all subdirectiories
for d in */  
do
	# do not run fastqc in the subdirectory with the fastqc results
	if [ "$d" != "fastqc_fastq/" ]
    then
        echo "$d"
    
    	# change path to subdirectory
    	cd $d
    	
    	for zippedFastq in *.fq.gz
    	do
    	
    	#run fastqc and put results in the above directory
    	fastqc -o $fastqcDir $zippedFastq
    	
    	done
    
    	# go back to the original directory
    	cd ..
    fi
    
done


echo "  "
echo "Done!"

multiqc .