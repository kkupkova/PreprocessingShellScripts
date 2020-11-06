 #!/bin/bash

# Script for getting average + max + min coverage values at certain regions :
# Run from a folder with the bigWig files - the output folder will 
# be created within here
# inputs are: BED file with desired regions (4th columns is the peak name
# and bigWig files to be plotted onto it
# 1) drag a folder with the bed files to a console
# 2) get the intersections of the bed file and bigWig with the overlap information

# output format:
#   name - name field from bed, which should be unique
#   size - size of bed (sum of exon sizes
#   covered - # bases within exons covered by bigWig
#   sum - sum of values over all bases covered
#   mean0 - average over bases with non-covered bases counting as zeroes
#   mean - average over just covered bases
#   min  - minimum observed in the area
#   max  - maximum observed in the area


# go through all the BED files within the folder and intersect bedGraph with corresponding one
echo -e What is the folder with your BED files? # drag the folder to the console
read bedFolder


# what do peak file nemas have before ID
prefix="stitched_"
# hat do peak file names have after ID
suffix="_peaks.bed"

mkdir peakHeights


for bwFile in *.bw
do
	echo "Computation on following bw file: ${bwFile}"
	
	# get everything before _ to get the ID
	# explanation: %% remove longest matching suffix pattern
	ID=${bwFile%%_*}
	
	peakName="${bedFolder}/${prefix}${ID}${suffix}"
	echo "mapping onto following peak set: ${peakName}"

	# define output names
	output="${ID}_MACS2_stitchedPeaks.tab"
	
	# bigWigSummaryOverBed - input: bigWig and BED files + option minMax
	bigWigAverageOverBed $bwFile $peakName -minMax $output

	# move results to designated folder
	mv $output peakHeights
	
done