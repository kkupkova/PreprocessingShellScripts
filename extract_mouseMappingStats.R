rm(list = ls())
library(tidyverse)

# give path to stats file
statsFile = "/Users/lilcrusher/epigen_mal/mouse/H3K4me3_liver/BATCH_2/PROCES_FASTQ/2map_mouse/mouseStats.txt"
statsText = readLines(statsFile)
pathToFile = dirname(statsFile)

# get statrting indexes for each sample (starts with Multiseed)
startIndex = grep(statsText, pattern = "^Multiseed")

# 1) total number of reads
readsProcessed = parse_number(statsText[(startIndex +1)])
# 2) reads that aligned exactly one time
oneTime = parse_number(statsText[(startIndex +4)])
# 3) percent of reads that aligned exactly one time
percentOneTime = round(oneTime / readsProcessed *100, digits = 2)
# 4) number of reads that aligned more than one time
moreTimes = parse_number(statsText[(startIndex +5)])
# 5)  percent of reads that aligned more than one time
moreTimesPercent = round(moreTimes / readsProcessed *100, digits = 2)
# 6 ) reads that aligned zero times
zeroTimes = parse_number(statsText[(startIndex +3)])
# 7)  percent of reads that aligned zero times
zeroTimesPercent = round(zeroTimes / readsProcessed *100, digits = 2)
# 8) overall alignment rate
overall = parse_number(statsText[(startIndex +6)])
# 9) total mapped reads
totalMapped = parse_number(statsText[(startIndex +11)])
# 10) total mapped reads after blacklist filter
totalMappedFilt = parse_number(statsText[(startIndex +15)])

# file name
fileNamePositions = startIndex = grep(statsText, pattern = "^Mapping")
fastqFile = statsText[(fileNamePositions +1)]

summaryTable = data.frame(fastqFile, 
                          readsProcessed, 
                          oneTime, 
                          percentOneTime,
                          moreTimes, 
                          moreTimesPercent,
                          zeroTimes, 
                          zeroTimesPercent, 
                          overall, 
                          totalMapped, 
                          totalMappedFilt)

colnames(summaryTable) = c("01 processed fastq file", 
                           "02 # reads processed", 
                           "03 # reads that aligned exactly one time", 
                           "04 percent of reads that aligned exactly one time",
                           "05 # reads that aligned more than one time",
                           "06 percent of reads that aligned more than one time",
                           "07 # reads that aligned zero times",
                           "08 percent of reads that aligned zero times",
                           "09 overall alignment rate", 
                           "10 total # of mapped reads", 
                           "11 total # of mapped reads after blacklist filtering")
write.csv(summaryTable, paste0(pathToFile, "/mouseStats.csv"), quote = F, row.names = F)





