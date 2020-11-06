#!/bin/bash

# go through all bedGraphs and get the total sum of opened regions = 
# 1) get peak size (column 5)
# 2) multiply signa by peak size (column6)
# 3) sum the signal weighted by the peak size
# the results are saved to a file called totalOpen_/origName/.txt

for i in *.bedGraph
do
 id="$( cut -d '.' -f 1 <<< "$i" )"
 echo "Following bedGraph is processed: ${id}"

 fileName="totalOpen_${id}.txt"
	
 # simple sum of 4th column
 #awk '{ sum+=$4} END {print sum}' $i > $fileName
	
 # 1) get peak width - 2) multiply signal by peak width - 3) do sum of the weighted signal (since genome is the same size, 
 # this should be the correct representation
 awk 'BEGIN { OFS = "\t" } { $5 = $3 - $2 } 1' $i | awk 'BEGIN { OFS = "\t" } { $6 = $4 * $5 } 1' | awk '{ sum+=$6} END {print sum}' > $fileName
done
