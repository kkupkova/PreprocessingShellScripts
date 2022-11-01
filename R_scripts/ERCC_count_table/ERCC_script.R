rm(list = ls())

#NOTE: the code selects the firs occurence of a given ERCC in stringtie, if this element does not contain gene_id and ref_gen_id in the last column, 
# the code will crash (but this shouldn't happen)- the solution would be selecting only trascripts from the stringtie table- not exons, but I am not sure if this 
# wouldn't cause problems somewhere else.

#--------------upload required data-----------------
#upload list of all our ERCCs
ERCC92 <- read.delim("ERCC92.gtf",header = F )
#upload count table
gene_count <- read.delim("gene_count_matrix.csv", sep=",")
# upload list of transcripts
stringtie <- read.delim("stringtie_merged.gtf", skip = 2,header = F)

#-------------- Main function ---------------------
# function takes as input following: 
# ERCC_list: data frame, where the first column contains the names or ERCCs used in the experiment
# gene_count: gene (or transcript) count table, where the first column contains the gene (transcript) names
# stringtie: output of stringtie - first column must contain our ERCCs (and then chrom names, etc.) + last column carries the information
#            about gene_id, and ref_gene_id in any order (must be separated by ";")

renameERCC <- function(ERCC_list, gene_count, stringtie){
  
  #extract from the list of transcript the rows corresponding to ERCCs =  find the first hit of our ERCC names and keep those rows
  keep_string <- stringtie[match(ERCC_list[,1], stringtie[,1]),]
  
  #Take the last column of the keep strintie table and separate the strings into substrings based on semicolon appearance
  help_list <-strsplit(as.character(keep_string[,dim(keep_string)[2]]), split = ";")
  
  # make a translation table where there will be ERCC and next to it the corresponding MSTRING name (geneID)
  translation_table <- as.data.frame(matrix(, ncol = 2, nrow = length(help_list)))
  colnames(translation_table) <- c("ERCC", "geneID")
  #go 1 by one through the help_list (the last column in stringtie) - separate the first and the third element by occurance
  #of blank space and take the elements after gene_id and ref_gene_id
  for ( i in seq(1, length(help_list))){
    helpVar <- help_list[[i]]
    
    # from helpvar get the char vectors which start with "gene_id", and which contain "ref_gene_id" and ge the last element in those char vectors
    geneID <- unlist(strsplit(helpVar[grep("^gene_id", helpVar)], split = " "))
    geneID <- geneID[length(geneID)]
    ERCC <- unlist(strsplit(helpVar[grep("ref_gene_id", helpVar)], split = " "))
    ERCC <- ERCC[length(ERCC)]
    
    translation_table[i,] <- c(ERCC, geneID)
  }
  
  
  count_table <- gene_count
  count_table[,1] <- as.character(count_table[,1])
  #replace the MSTRIG names by corresponding ERCC names
  for (i in seq(1, dim(translation_table)[1])){
    geneID <- translation_table$geneID[i]
    ERCC <- translation_table$ERCC[i]
    count_table[which(count_table[,1] == geneID),1] <- ERCC
    
  }
  return(count_table)
}

# ------------- run the function with our inputs and check if the number of ERCCs in the final count table is correct----------------------
count_table <- renameERCC(ERCC92, gene_count, stringtie)

#make sure you got the correct number of ERCCs in your final count table
length(grep("^ERCC", count_table[,1]))


