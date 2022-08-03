 #!/bin/bash
echo -e What is the BED file you want your BAMs to be mapped to??
read BEDfile

echo -e What is the name of your output folder?
read folder
mkdir $folder

for i in *.bam
 do 
 	# ID= everything before "."
 	id="$( cut -d '.' -f 1 <<< "$i" )"
 	echo $id
 	echo $i
 	
 	ngs.plot.r -G hg19 -R bed -C $i -O $id -T H3K4me3_ectopic -L 1000 -E $BEDfile -FS 15 -LWD 6
 	
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

# copy norm factors to the folder
cp norm_factors.txt $folder

#ngs.plot.r -G hg19 -R bed -C 1204_F-Ctrl.sorted.bam -O 1204 -T H3K4me3_ectopic -L 1500 -E ectopic_different_sizes.bed -FS 15 -LWD 6