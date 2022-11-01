#first load libraries
library(Biobase)
library(DESeq2)
library(gplots)

#then define rld and/or vsd (either or both can be used for PCA)
rld<-rlogTransformation(dds,blind=TRUE)
vsd<-varianceStabilizingTransformation(dds,blind=TRUE)

#now specify what x is
x<-rld 

#or
x<-vsd

#now run through line 31
plotPCAWithSampleNamesDA = function(x, intgroup="condition", ntop=500)
{
  library("RColorBrewer")
  library("genefilter")
  library("lattice")
  
  rv = rowVars(assay(x))
  select = order(rv, decreasing=TRUE)[seq_len(min(ntop, length(rv)))]
  #note next line was originally pca = prcomp(t(assay(x)[select,])); this makes pca a global environment variable so can retrieve stats using summary(pca)
  pca <<- prcomp(t(assay(x)[select,]))
  
  # extract sample names (e.g. mctrl1, mctrl2, etc)
  names = colnames(x)
  
  #fac <<- factor(apply( as.data.frame(colData(x)[, intgroup, drop=FALSE]), 1, paste, collapse=" : "))
  fac <<- apply( as.data.frame(colData(x)[, intgroup, drop=FALSE]), 1, paste, collapse=" : ")
  fac2 <<- as.numeric(fac)

  #fac = apply( as.data.frame(colData(x)[, intgroup, drop=FALSE]), 1, paste, collapse=" : ")
  #print(fac)
  #set multiple colors-skip if you just want colors for each condition rather than each sample
  #if( nlevels(fac) >= 3 )
    #colours = brewer.pal(nlevels(fac), "Dark2")
  #else  
    #colours = c( "lightgreen", "dodgerblue" )
  
  #plot parameters
  pca1<-ggplot(data=as.data.frame(pca$x),aes(PC1,PC2,colour=fac2))
  #pca2<-pca1 + geom_point() + scale_colour_gradient2()
  #pca2<-pca1 + geom_point(size=3) + scale_colour_gradient(low="pink",high="dark blue")
  #pca2<-pca1 + geom_point(size=3) + scale_colour_gradient(low="red")
  #pca2<-pca1 + geom_point(size=3) + scale_colour_gradient(low="dark blue",high="light blue")
  pca2<-pca1 + geom_point(size=4) + scale_colour_gradient2(low="red",mid="yellow", high="dodgerblue4",midpoint=-2)
  #pca2<-pca1 + geom_point(size=3) + scale_colour_gradient2(low="red",mid="white", high="dark blue",midpoint=-2)
  #pca2<-pca1 + geom_point(size=3) + scale_colour_gradient2(low="red",mid="light blue", high="light blue",midpoint=-2)
  #pca2<-pca1 + geom_point(size=3) + scale_colour_gradient()
  #pca2<-pca1 + geom_point(size=4) + scale_colour_gradient(colours=rainbow(2))

#add this curly bracket at end
}

#now generate plot using this command 
#print(plotPCAWithSampleNamesDA(rld,intgroup=c("condition")))
print(plotPCAWithSampleNamesDA(rld))

#or this command, as appropriate 
print(plotPCAWithSampleNamesDA(vsd))

#if you want the statistics associated with the pca (e.g. proportion of variation in in each pc), use
summary(pca)
