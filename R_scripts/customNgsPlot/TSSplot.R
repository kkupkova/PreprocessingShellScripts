rm(list = ls())
library(ggplot2)
#upload average normalized coverage
tss <- read.delim("meanNormCov.txt",header = F, sep="\t")

#generate datafram, si it can be plotted by ggplot
data <- data.frame(tss= t(tss), osa = seq(-length(tss)/2, length(tss)/2,length.out =  length(tss)))

#plot data
p1 <- ggplot(data, aes(x=osa, y=tss))
p1 + geom_point(color = "royalblue4") + 
  xlab('TSS')+ 
  ylab('normcov')
