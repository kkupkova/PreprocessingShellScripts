#!/bin/bash

# hg18 to hg19 conversion using liftOver

for i in $(ls *.bed); do 
	liftOver $i hg18ToHg19.over.chain.gz ${i}.hg19 ${i}.unmapped;
done