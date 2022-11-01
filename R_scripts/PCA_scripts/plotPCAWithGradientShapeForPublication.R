#use this script to generate PCA plots with data points in gradient coloring based on quantitative biomarker used for analyses.  It differs from plotPCAWithGradient.R in that it allows you to specify the shape of the data points based on some other attribute such as gender.

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
  #if you want to plot with different shapes for an attribute like gender, use something like this
  gender <<- samples_original16_52wk_with_dHAZ_gender$gender
  
  fac <<- apply( as.data.frame(colData(x)[, intgroup, drop=FALSE]), 1, paste, collapse=" : ")
  
  #change HAZ below to name of whatever biomarker you're investigating
  dHAZ <<- as.numeric(fac)
  
  #plot parameters- change HAZ in next command to name of biomarker above
  #change PC1 and PC2 to generate plots of other principal components
  pca1<-ggplot(data=as.data.frame(pca$x),aes(PC1,PC2,colour=dHAZ))
  
  #use one of the options below- they vary in color and aesthetics
  #pca2<-pca1 + geom_point() + scale_colour_gradient2()
  #pca2<-pca1 + geom_point(size=3) + scale_colour_gradient(low="pink",high="dark blue")
  #pca2<-pca1 + geom_point(size=3) + scale_colour_gradient(low="red")
  #pca2<-pca1 + geom_point(size=4) + scale_colour_gradient(low="dark blue",high="light blue")
  
  #use this to change data point shapes (replace numbers 16 and 15 for other shapes)
  
  #pca2<-pca1 + geom_point(aes(shape=gender),size=4)  + scale_colour_gradient(low="dark blue",high="light blue") + scale_shape_manual(values=c(16,15))  
  
  #pca2<-pca1 + geom_point(size=4) + scale_colour_gradient2(low="red",mid="yellow", high="blue",midpoint=-2)
  #pca2<-pca1 + geom_point(size=4) + scale_colour_gradient2(low="red",mid="yellow", high="blue",midpoint=-1)
  
  #I used the following for publication, which sets the color gradient and the datapoint shape- note guide=FALSE hides the gender shape legend
  pca2<-pca1 + geom_point(aes(shape=gender),size=4) + scale_colour_gradient(low="red", high="blue")+ scale_shape_manual(values=c(16,15),guide=FALSE)
  
  #for no gender differences use this
  pca2<-pca1 + geom_point(size=4) + scale_colour_gradient(low="red", high="blue")
  
  #pca2<-pca1 + geom_point(size=3) + scale_colour_gradient2(low="red",mid="white", high="dark blue",midpoint=-2)
  #pca2<-pca1 + geom_point(size=3) + scale_colour_gradient2(low="red",mid="light blue", high="light blue",midpoint=-2)
  #pca2<-pca1 + geom_point(size=4) + scale_colour_gradient() 
  #pca2<-pca1 + geom_point(size=4) + scale_colour_gradient(colours=rainbow(2))
  #pca2<-pca1 + geom_point(size=4) + scale_colour_gradient2(low="#dd1c77",mid="#c994c7", high="#e7e1ef",midpoint=-2)

#for specifying the shape of the data point use and with aspect ratio = 1
pca3<-pca2 + theme(text=element_text(size=20)) + theme(axis.text.y=element_text(colour="black"))+theme(axis.text.x=element_text(colour="black"))+theme(panel.background=element_rect(fill="white"))+ theme(panel.background = element_rect(colour = "black",size=0.8)) + theme(aspect.ratio=1)+theme(axis.title.y=element_text(margin=margin(0,20,0,0)))+theme(axis.title.x=element_text(margin=margin(20,0,0,0)))+theme(legend.text.align = 1) 

#use this instead of above to reposition the legend within the plot frame ((0,0) means lower left and (1,1) means upper right))

pca3<-pca2 + theme(text=element_text(size=26)) + theme(axis.text.y=element_text(colour="black"))+theme(axis.text.x=element_text(colour="black"))+theme(panel.background=element_rect(fill="white"))+ theme(panel.background = element_rect(colour = "black",size=0.8)) + theme(aspect.ratio=1)+theme(axis.title.y=element_text(margin=margin(0,3,0,0)))+theme(axis.title.x=element_text(margin=margin(20,0,0,0)))+theme(legend.text.align = 1)+ theme(legend.position = c(0.15, 0.8))                                                                                                                                                                                      #add this curly bracket at end
}

#now generate plot using this command 
print(plotPCAWithGradient(rld))

#then save a copy of it
ggsave("my_PCA_plot.pdf", width = 6, height = 6)

#or this command, as appropriate 
print(plotPCAWithGradient(vsd))

#if you want the statistics associated with the pca (e.g. proportion of variation in in each pc), use
summary(pca)
