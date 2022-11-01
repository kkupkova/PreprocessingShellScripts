#!/bin/bash

#1. Obtain general information for the ChIP-seq datasets

#echo -e "tf\ttreatment\tGEO_number\tcell_line\tquality\tnumberOfPeaks" >prostate_multiTFBS_info.txt

#for i in $(ls *.bed); do tf=`echo $i | cut -d "_" -f 1`; \
#	treatment=`echo $i | cut -d "_" -f 2`;
#	GEO_number=`echo $i | cut -d "_" -f 3`;
#	cell_line=`echo $i | cut -d "_" -f 4`;
#	quality=`echo $i | cut -d "_" -f 5`;
#	numberOfPeaks=`wc -l $i | cut -d " " -f 1`;
#	printf "%s\t%s\t%s\t%s\t%s\t%d\n" $tf $treatment $GEO_number $cell_line $quality $numberOfPeaks >>prostate_multiTFBS_info.txt;
#done

#2. Multi-intersect the datasets

echo -e "bedtools multiinter -i \\" >multiIntersect.txt

GEO_ID=()

for i in $(ls *.bed*); do \
	sort -k1,1 -k2,2n $i >${i}.sorted;
	printf "${i}.sorted " >>multiIntersect.txt;
	temp=`echo $i | cut -d "_" -f 3`;
	GEO_ID+=("$temp");
done

names=`echo "${GEO_ID[@]}"`
echo "-header -names $names >>intersectResults.txt" >>multiIntersect.txt