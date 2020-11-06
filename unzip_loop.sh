#!/bin/bash
#run this script from the folder with ROSE scripts:

# for i in *.zip
# do
# 	unzip $i
# done

for i in *.gz
do
	gunzip $i
done