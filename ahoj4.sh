computeMatrix scale-regions \
		-S 1471_normalized.bw \
		   1407_normalized.bw \
		   1457_normalized.bw \
		   1409_normalized.bw \
		   1398_normalized.bw \
		   1548_normalized.bw \
		   1661_normalized.bw \
		   1557_normalized.bw \
		   1580_normalized.bw \
		   1578_normalized.bw \
		   1666_normalized.bw \
		   1333_normalized.bw \
		   1686_normalized.bw \
		   1684_normalized.bw \
		   1392_normalized.bw \
		-R /Users/lilcrusher/epigen_mal/H3K9me3/average_profiles_18wk/spiky_regions_peaks/neg_proximal_spikes.bed \
		-o deltaHAZ_sorted_negProxSpikes.mat.gz \
		--outFileNameMatrix deltaHAZ_sorted_negProxSpikes.tab \
		--outFileSortedRegions deltaHAZ_sorted_negProxSpikes.bed \
		--missingDataAsZero \
		--smartLabels \
		--sortRegions descend \
		-p "max/2" \
		-b 0 \
		-a 0
