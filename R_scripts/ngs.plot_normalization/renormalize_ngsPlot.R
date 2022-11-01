# clear workspace
rm(list = ls())
#get zip file you want processed
zip_name <-file.choose()
#set the working directory to the folder, where the zip file is placed
setwd(dirname(zip_name))

# searches for text file containing normalization factors- make sure, that it is the only 
#text file placed into the folder containing the zip file
norm_file <-list.files(path = dirname(zip_name), pattern = "*txt$", all.files = FALSE,
                       full.names = FALSE)
## created a table with name of BAM files and corresponding normalization factors
norm_factors<- read.delim(paste(dirname(zip_name),norm_file, sep = "/"),header = F, sep="\t")
colnames(norm_factors) <- c("bam.file", "normFactor")

# remove the normalization text file name from work space
rm(norm_file)

#move the working directory to the unzipped folder
unzip(zip_name)
unlink(zip_name)
setwd(sapply(strsplit(zip_name, ".z"), "[", 1))
load("avgprof.RData") ## Load Rdata file created by ngsplot preferably in an empty environment.

#undo the original normalization
raw.counts <- t(t(regcovMat)*(v.lib.size/1e6))

#add normalization factors to already existing table with plotting informatin-\
# the for loop just makes sure, that the order of the BAM files in the normalization configuration file
#matches their order in the configuration file for potting
ctg.tbl$norm.factors <- rep(0, dim(ctg.tbl)[1])
for (i in 1:dim(ctg.tbl)[1]){
  ctg.tbl$norm.factors[norm_factors$bam.file[i] == ctg.tbl$cov] <- norm_factors$normFactor[i]
}
# remove norm_factors, as these are place into the ctg.tbl now
rm(norm_factors)

# normalize the data with our custom normalization factors
regcovMat <- t(t(raw.counts)/(ctg.tbl$norm.factors))
rm(zip_name)

unlink("avgprof.txt")
unlink("avgprof.RData")
#rewrite avgprof.txt file with the new data and save the new workspace
write.table(regcovMat, file="avgprof.txt", row.names=F, sep="\t", quote=F)
save(list=ls(all=TRUE),file="avgprof.RData") ## Overwrite avgprof.RData to contain custom normalised regcovMat.






