#!/bin/bash
# DESCRIPTION!!!
#go through all subdirectories

count_table='count_table.txt'
master='_master.bed'
bamNames='bamNames.txt'

#go through the subdirectories within our directory
for folder in */
	do
		#change pathway to the subdirectory and make a new subdirectory there for results
		cd $folder
		
		#change the H3K4me3 BED file so it has only 3 columns
		for sample in *.bed
 			do  
   			id_bed="$( cut -d '-' -f 1 <<< "$sample" )"
   			echo $id_bed
   			awk '{print $1 "\t" $2 "\t" $3}' $sample > $id_bed.bed
   			rm $sample
		done
		
		#get id of the samples, transform broadpeak to bed
		for sample in *.broadPeak 
 			do  
 			IDcount="$( cut -d '_' -f 1 <<< "$sample" )"
 			echo $IDcount
   			id="$( cut -d '.' -f 1 <<< "$sample" )"
   			awk '{print $1 "\t" $2 "\t" $3}' $sample > $id.bed
		done
		
		#make master BED file for the two samples
		echo "Making master bed"
		cat *.bed | sort -k1,1 -k2,2n | bedtools merge -i stdin > $IDcount$master
		
		#get bam names just to make sure
		ls *.bam > $IDcount$bamNames
		
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
