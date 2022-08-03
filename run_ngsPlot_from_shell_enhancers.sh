 #!/bin/bash

echo -e What is the name of your output folder?
read folder
mkdir $folder

for i in *.bam
 do 
 	# ID= everything before "."
 	id="$( cut -d '.' -f 1 <<< "$i" )"
 	echo $id
 	echo $i
 	
 	ngs.plot.r -G hg19 -R enhancer -C $i -O $id -T H3K27ac_enhancers -FS 15 -LWD 6
 	
done

#move all pdfs and zips to the new folder and unzip the zip files
mv *.pdf $folder
mv *.zip $folder

#change directory to the newly created one
cd $folder

#unzip the zipped files
for i in *.zip
do
	unzip $i
done

#go back folder up
cd ..
