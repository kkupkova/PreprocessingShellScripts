 #!/bin/bash

# go through all the computed matrices with deepTools and 
# create heatmaps

  
# go through the bigWig files and map them agains the BED file
for i in *.gz
	do 
	# id= everything before "."
	id="$( cut -d '.' -f 1 <<< "$i" )"
	echo "Following file is processed: ${id}"
	
	# define output names
	pngOutput="${id}.png"
	
	plotHeatmap -m $i \
	-o $pngOutput
	
done






