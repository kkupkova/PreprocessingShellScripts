#use this script to generate PCA plots with data points in gradient coloring based on quantitative biomarker used for analyses

#first load libraries
library(Biobase)
library(DESeq2)
library(gplots)
library(ggplot2)

#then define rld and/or vsd (either or both can be used for PCA)
rld<-rlogTransformation(dds,blind=TRUE)
vsd<-varianceStabilizingTransformation(dds,blind=TRUE)

#now specify what x is
x<-rld 

#or
x<-vsd

#now run through line 55, having made any changes you like to biomarker labeling or coloring as noted below
plotPCAWithGradient = function(x, intgroup="condition", ntop=500)
{
  library("RColorBrewer")
  library("genefilter")
  
  rv = rowVars(assay(x))
  select = order(rv, decreasing=TRUE)[seq_len(min(ntop, length(rv)))]
  #note next line was originally pca = prcomp(t(assay(x)[select,])); this makes pca a global environment variable so can retrieve stats using summary(pca)
  pca <<- prcomp(t(assay(x)[select,]))
  
  # extract sample names (e.g. mctrl1, mctrl2, etc)
  names = colnames(x)
  
  fac <<- apply( as.data.frame(colData(x)[, intgroup, drop=FALSE]), 1, paste, collapse=" : ")
  
  #change HAZ below to name of whatever biomarker you're investigating
  dHAZ <<- as.numeric(fac)
  
  #plot parameters- change HAZ in next command to name of biomarker above
  #change PC1 and PC2 to generate plots of other principal components
  pca1<-ggplot(data=as.data.frame(pca$x),aes(PC1,PC2,colour=dHAZ))
  #use this version to match shape of data point to some other variable like gender
  pca1<-ggplot(data=as.data.frame(pca$x),aes(PC1,PC2,colour=dHAZ,shape=gender))
  
  #use one of the options below- they vary in color and aesthetics
  #pca2<-pca1 + geom_point() + scale_colour_gradient2()
  #pca2<-pca1 + geom_point(size=3) + scale_colour_gradient(low="pink",high="dark blue")
  #pca2<-pca1 + geom_point(size=3) + scale_colour_gradient(low="red")
  pca2<-pca1 + geom_point(size=4) + scale_colour_gradient(low="dark blue",high="light blue")
  #pca2<-pca1 + geom_point(size=4) + scale_colour_gradient2(low="red",mid="yellow", high="dodgerblue4",midpoint=-2)
  #pca2<-pca1 + geom_point(size=3) + scale_colour_gradient2(low="red",mid="white", high="dark blue",midpoint=-2)
  #pca2<-pca1 + geom_point(size=3) + scale_colour_gradient2(low="red",mid="light blue", high="light blue",midpoint=-2)
  #pca2<-pca1 + geom_point(size=4) + scale_colour_gradient() 
  #pca2<-pca1 + geom_point(size=4) + scale_colour_gradient(colours=rainbow(2))
  #pca2<-pca1 + geom_point(size=4) + scale_colour_gradient2(low="#dd1c77",mid="#c994c7", high="#e7e1ef",midpoint=-2)
  pca3<-pca2 + theme(text=element_text(size=18)) + theme(axis.title.y = element_text(vjust=1.5))+ theme(axis.title.x = element_text(vjust=-0.3)) + theme(axis.text.y=element_text(colour="black"))+theme(axis.text.x=element_text(colour="black"))+theme(panel.background=element_rect(fill="white"))+ theme(panel.background = element_rect(colour = "black",size=0.8)) + theme(aspect.ratio=1) 

#add this curly bracket at end
}

#now generate plot using this command 
print(plotPCAWithGradient(rld))

#then save a copy of it
ggsave("my_PCA_plot.pdf", width = 6, height = 6)

#or this command, as appropriate 
print(plotPCAWithGradient(vsd))

#if you want the statistics associated with the pca (e.g. proportion of variation in in each pc), use
summary(pca)
