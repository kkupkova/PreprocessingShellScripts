#!/bin/bash
# replaces blank spaces with tab - places original file to directory called spaces
mkdir spaces
for i in *.bedGraph
do
	# id= everything before "."
	id="$( cut -d '.' -f 1 <<< "$i" )"
	echo "Following bedGraph is processed: ${id}"
	
	# define output names
	output="${id}_xxx.bedGraph"
	
	# replace blanks with tabs within the file
	tr [:blank:] \\t < $i > $output
	
	# move the unedited file to folder "spaces" and rename the new file with original name
	mv $i spaces
	mv $output $i
done
