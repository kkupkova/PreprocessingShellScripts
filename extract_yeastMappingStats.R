rm(list = ls())
library(tidyverse)

# give path to stats file
statsFile = "/Users/lilcrusher/epigen_mal/mouse/H3K4me3_liver/BATCH_2/PROCES_FASTQ/1map_yeast/yeastReport.txt"
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
# file name
fastqFile = substring(statsText[(startIndex +9)], first = 3)

summaryTable = data.frame(fastqFile, 
                          readsProcessed, 
                          oneTime, 
                          percentOneTime,
                          moreTimes, 
                          moreTimesPercent,
                          zeroTimes, 
                          zeroTimesPercent, 
                          overall)

colnames(summaryTable) = c("FASTQ file name", 
                           "01 # reads processed", 
                           "02 # reads that aligned exactly one time", 
                           "03 percent of reads that aligned exactly one time",
                           "04 # reads that aligned more than one time",
                           "05 percent of reads that aligned more than one time",
                           "06 # reads that aligned zero times",
                           "07 percent of reads that aligned zero times",
                           "08 overall alignment rate")
write.csv(summaryTable, paste0(pathToFile, "/yeastReport.csv"), quote = F, row.names = F)





