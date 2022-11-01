#use this script to plot PC3 versus PC4 with sample names
#first load libraries
library(Biobase)
library(DESeq2)
library(gplots)

#then define rld and vsd (either or both can be used for PCA)
rld<-rlogTransformation(dds,blind=TRUE)
vsd<-varianceStabilizingTransformation(dds,blind=TRUE)

#now specify what x is
x<-rld 

#or
x<-vsd

#now run through line 31
plotPCAPC34WithSampleNames = function(x, intgroup="condition", ntop=500)
{
  library("RColorBrewer")
  library("genefilter")
  library("lattice")
  
  rv = rowVars(assay(x))
  select = order(rv, decreasing=TRUE)[seq_len(min(ntop, length(rv)))]
  pca = prcomp(t(assay(x)[select,]))
  
  # extract sample names
  names = colnames(x)
  
  fac = factor(apply( as.data.frame(colData(x)[, intgroup, drop=FALSE]), 1, paste, collapse=" : "))
  
  #set multiple colors-skip if you just want colors for each condition rather than each sample
  if( nlevels(fac) >= 3 )
    colours = brewer.pal(nlevels(fac), "Dark2")
  else  
    colours = c( "lightgreen", "dodgerblue" )
  
  #or set two colors, one for each of the two conditions
  colours = c( "lightgreen", "dodgerblue" )
  
  #plot parameters
  xyplot(
    PC4 ~ PC3, groups=fac, data=as.data.frame(pca$x), pch=16, cex=1.5,
    panel=function(x, y, ...) {
      panel.xyplot(x, y, ...);
      ltext(x=x, y=y, labels=names, pos=1, offset=0.8, cex=0.7)
    },
    #for no legend use this
    aspect = "iso", col=colours)
  
  #for legend use this
  aspect = "iso", col=colours,
  
  #add legend if desired
  main = draw.key(key = list(
    rect = list(col = colours),
    text = list(levels(fac)),
    rep = FALSE)))

#add this curly bracket at end
}

#now generate plot using this command 
print(plotPCAPC34WithSampleNames(rld,intgroup=c("condition")))

#or this command, as appropriate 
print(plotPCAPC34WithSampleNames(vsd,intgroup=c("condition")))

#to generate the same plot but without labels & with legend, use plotPCA_PC3-PC4_nolabels.RScript

