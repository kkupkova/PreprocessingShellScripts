rm(list = ls())
library(ggplot2)
library(reshape)
norm_fact <- read.delim("norm_factors.txt", header = T)
ID <- colnames(norm_fact)
matches <- regmatches(ID, gregexpr("[[:digit:]]+", ID))
norm_fact <-as.data.frame(cbind(t(norm_fact), as.numeric(unlist(matches))) ) 

colnames(norm_fact) <- c("factor", "ID")

dirs <- list.dirs(path = getwd())

for (i in seq(2, length(dirs))){
  #change directory
  setwd(dirs[i])
  
  
  help_ID <- unlist(strsplit(dirs[i], split = "/"))
  
  help_ID <- help_ID[length(help_ID)]
  ID  <- as.numeric(unlist(regmatches(help_ID, gregexpr("[[:digit:]]+", help_ID)))) 
  
  # do the normalization
  load("avgprof.RData") ## Load Rdata file created by ngsplot preferably in an empty environment.
  
  #undo the original normalization
  raw.counts <- t(t(regcovMat)*(v.lib.size/1e6))
  
  #add normalization factors to already existing table with plotting informatin-\
  # the for loop just makes sure, that the order of the BAM files in the normalization configuration file
  #matches their order in the configuration file for potting
  ctg.tbl$norm.factors <- norm_fact$factor[norm_fact$ID == ID]
  
  regcovMat <- t(t(raw.counts)/(ctg.tbl$norm.factors))
  
  if (i==2){
    plotTable <- t(t(raw.counts)/(ctg.tbl$norm.factors))
    columnNames <- help_ID
  }else{
    plotTable <- cbind(plotTable, t(t(raw.counts)/(ctg.tbl$norm.factors)))
    columnNames <- append(columnNames, help_ID)
  }
  
}

#set directory back
setwd(dirs[1])

plotTable <- as.data.frame(plotTable)
colnames(plotTable) <- columnNames

plotTable_MAl <- plotTable[!(grepl(columnNames, pattern = "Ctrl"))]
plotTable_Ctrl <- plotTable[grepl(columnNames, pattern = "Ctrl")]

help_table <- cbind(plotTable_Ctrl, plotTable_MAl)
help_table $ind <- seq(-1600, 1600, length.out = nrow(plotTable_MAl))


plotTable_MAl$mean <- rowMeans(plotTable_MAl)
plotTable_MAl$ind <- seq(-1600, 1600, length.out = nrow(plotTable_MAl))

#plotTable_Ctrl <- plotTable_Ctrl[,colnames(plotTable_Ctrl)!= "1407_M-Ctrl_reseq"]
plotTable_Ctrl$mean <- rowMeans(plotTable_Ctrl)
plotTable_Ctrl$ind <- seq(-1600, 1600, length.out = nrow(plotTable_Ctrl))

plotTable <- data.frame(means = c(plotTable_MAl$mean, plotTable_Ctrl$mean), 
                        ind = c(plotTable_MAl$ind, plotTable_Ctrl$ind), 
                        condition =  factor(c(rep("stunted", nrow(plotTable_MAl)), rep("control", nrow(plotTable_Ctrl)))))




p <- ggplot(plotTable, aes(x=ind, y=means, color =  condition))
p + geom_line(size=1.2) +
  xlab(paste("Distance from peak center"))+
  ylab(paste("Average of normalized mapped reads"))+
  scale_color_manual(values=c('#0C4B8E', '#BF382A'))+ggtitle("Ectopic peaks 100 kbp from TSS: H3K4me3")

help_table <- melt(help_table, id.vars= "ind", variable.name = "sample")

p <- ggplot(help_table, aes(x=ind, y=value, color =  variable))
p + geom_line(size=1.2) +
  xlab(paste("Distance from peak center"))+
  ylab(paste("Average of normalized mapped reads"))+
  scale_color_manual(values=c(rep('#0C4B8E', ncol(plotTable_Ctrl)-2), rep('#BF382A', ncol(plotTable_MAl)-2)))+ggtitle("Ectopic peaks 100 kbp from TSS: H3K4me3")

colfunc <- colorRampPalette(c('#0C4B8E', '#BF382A'))

p <- ggplot(help_table, aes(x=ind, y=value, color =  sample))
p + geom_line(size=1.2) +
  xlab(paste("Distance from peak center"))+
  ylab(paste("Average of normalized mapped reads"))+
  scale_color_manual(values=colfunc(16))+ggtitle("Ectopic peaks 100 kbp from TSS: H3K4me3")
  


p <- ggplot(help_table, aes(x=ind, y=value, color =  sample))
p + geom_line(size=1.2) +
  xlab(paste("Distance from peak center"))+
  ylab(paste("Average of normalized mapped reads"))+
  scale_color_manual(values=c("cornflowerblue","cornflowerblue","cornflowerblue", "darkblue", "cornflowerblue", "darkblue", "cornflowerblue", "darkblue",
                              "lightpink2", "darkred", "darkred", "lightpink2", "lightpink2","darkred", "darkred" , "lightpink2"))+ggtitle("Ectopic peaks 100 kbp from TSS: H3K4me3")


  
  
