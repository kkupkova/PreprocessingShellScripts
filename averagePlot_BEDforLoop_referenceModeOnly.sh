 #!/bin/bash

# Script for getting coverage values at certain regions :
# run from a folder with bigWig regions to be mapped - the output folders will be 
# created within this folder
# inputs are: BED file with desired regions and bigWig files to be plotted onto it
# there are two modes of plotting - 
#                    1: regions are scaled to same size, 
#                    2: center of regions are taken and +- 10 kb on both sides (arguments a, b)
# 1) drag a folder with the bed files to a console
# 2) creates a folder for each BED file: 
#                    name_referencePoint 
# 3) goes through the bigWig files - runs computeMatrix - arguments explained within a loop

# go through all the BED files within the folder and map the bigWig files onto
# each one
echo -e What is the folder with your BED files? # drag the folder to the console
read bedFolder

for bedFile in "$bedFolder"/*.bed
 do
 
 # 
  echo "Computation on following BED file: ${bedFile}"
  
  #get the file name for creation of new folder - 1) remove path, 2) remove extension
  filename=$(basename -- "$bedFile")
  folder="${filename%.*}"
  
  #create the two folders 
  folderReference="${folder}_referencePoint_2kb"
  mkdir $folderReference
  
	# go through the bigWig files and map them agains the BED file
	for i in *.bw
	 do 
		# id= everything before "."
		id="$( cut -d '.' -f 1 <<< "$i" )"
		echo "Following bigWig is processed: ${id}"
	
		# define output names
		gzOutput="${id}.gz"
		matrixOutput="${id}.tab"
		regionsOutput="${id}.bed"

	
	#  #### run reference-point mode ###
	#  	computeMatrix reference-point \ #option with the scaled regions
	#  	-S $i \ #input is the bigWig file
	#  	-R $bedFile \ #BED file that bigWig is mapped on
	#  	-o $gzOutput \ # output name - used for plotMatrix
	#  	--outFileNameMatrix $matrixOutput \ # the actual matrix values
	#  	--outFileSortedRegions $regionsOutput \ #bed regions without zeros
	#  	--sortRegions descent \ #sort regions for heatmap
	#  	--sortUsing mean \ # use mean value to sort regions
	#  	-p "max/2" \ # use maximum number of processors /2
	#  	--referencePoint center \ # reference is the center of the region
	#  	-b 2000 \ # 2kb upstream from reference
	#  	-a 2000 # 2 kb downstream from reference
	

		computeMatrix reference-point \
		-S $i \
		-R $bedFile \
		-o $gzOutput \
		--outFileNameMatrix $matrixOutput \
		--outFileSortedRegions $regionsOutput \
		--sortRegions descend \
		--sortUsing mean \
		-p "max/2" \
		--referencePoint center \
		-b 2000 \
		-a 2000
	
		# move results to designated folder
		mv $gzOutput $folderReference
		mv $matrixOutput $folderReference
		mv $regionsOutput $folderReference
	done
done



