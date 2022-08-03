 #!/bin/bash

# Script for getting coverage values at certain regions :
# inputs are: BED file with desired regions and bigWig files to be plotted onto it
# there are two modes of plotting - 
#                    1: regions are scaled to same size, 
#                    2: centers of regions are taken and +- 10 kb on both sides (arguments a, b)
# 1) give a name of a folder to be created - creates 2 folders- 
#                    1:name_scaleRegions, 
#                    2: name_referencePoint .... for the results of the two modes accordingly
# 2) drag a BED file to be used, to a console
# 3) goes through the bigWig files - runs computeMatrix - arguments explained within a loop

# create folders where the outputs should be placed - both for scale regions and reference point option
echo -e What is the name of your output folder?
read folder

folderScale="${folder}_scaleRegions2000bpSurround"
folderReference="${folder}_referencePoint"
mkdir $folderScale
mkdir $folderReference

# what is the BED file that the reads should be mapped on?
echo -e What is the BED file?
read bedFile

# go through the bigWig files and map them agains the BED file
# 
for i in *.bw
 do 
 	# id= everything before "."
 	id="$( cut -d '.' -f 1 <<< "$i" )"
 	echo $id
 	
 	# define output names
 	gzOutput="${id}.gz"
 	matrixOutput="${id}.tab"
 	regionsOutput="${id}.bed"
 	
#  	1) run scale-regions mode
#  	computeMatrix scale-regions \ #option with the scaled regions
#  	-S $i \ #input is the bigWig file
#  	-R $bedFile \ #BED file that bigWig is mapped on
#  	-o $gzOutput \ # output name - used for plotMatrix
#  	--outFileNameMatrix $matrixOutput \ # the actual matrix values
#  	--outFileSortedRegions $regionsOutput \ #bed regions without zeros
#  	--sortRegions descent \ #sort regions for heatmap
#  	--sortUsing mean \ # use mean value to sort regions
#  	-p "max/2" # use maximum number of processors /2
#   -b 2000 /
#   -a 2000 # add +- 2 kb behind
 	
 	computeMatrix scale-regions \
 	-S $i \
 	-R $bedFile \
 	-o $gzOutput \
 	--outFileNameMatrix $matrixOutput \
 	--outFileSortedRegions $regionsOutput \
 	--sortRegions descend \
 	--sortUsing mean \
 	-p "max/2" \
 	-b 2000 \
 	-a 2000
 	
 	# move results to designated folder
 	mv $gzOutput $folderScale
 	mv $matrixOutput $folderScale
 	mv $regionsOutput $folderScale
 	
#  	2) run reference-point mode
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
#  	-b 10000 \ # 10kb upstream from reference
#  	-a 10000 # 10 kb downstream from reference
 	

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
 	-b 10000 \
 	-a 10000
 	
 	# move results to designated folder
 	mv $gzOutput $folderReference
 	mv $matrixOutput $folderReference
 	mv $regionsOutput $folderReference
done


