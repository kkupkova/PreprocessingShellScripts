#!/bin/bash
# DESCRIPTION!!!
#go through all subdirectories

count_table='_count_table.txt'
master='_intersected.bed'
bamNames='bamNames.txt'

#go through the subdirectories within our directory
for folder in */
	do
		#change pathway to the subdirectory and make a new subdirectory there for results
		cd $folder
		
		
		#make master BED file for the two samples
		echo "Making intersection of the peaks bed"
		
		#list all BED files into an variable called array- then use indexes to use the files
		# as input to bedtools intersect- this has to have argument a and b
		arr=( *.bed )
		echo "${arr[0]}"
		echo "${arr[1]}"
		
		IDcount="$( cut -d '_' -f 1 <<< "${arr[0]}" )"
		
		bedtools intersect -a ${arr[0]} -b ${arr[1]} > $IDcount$master
		
		
		#get the count tables- ac and me are in different format do the count tables separately
		echo "Getting count tables"
		
		for bams in *.bam 
 			do  
 			echo $bams
   			id="$( cut -d '.' -f 1 <<< "$bams" )"
   			bedtools multicov -bams $bams -bed $IDcount$master > $id$count_table
		done
		
		
		#go back to the original directory
		cd ..
done

echo "Done!"
