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
    PC2 ~ PC1, groups=fac, data=as.data.frame(pca$x), pch=16, cex=1.5,
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
print(plotPCAWithSampleNamesDA(rld,intgroup=c("condition")))

#or this command, as appropriate 
print(plotPCAWithSampleNamesDA(vsd,intgroup=c("condition")))

#to generate the same plot but without labels & with legend, use this
print(plotPCA(rld,intgroup=c("condition")))

#or this, as appropriate
print(plotPCA(vsd,intgroup=c("condition")))

#if you want the statistics associated with the pca (e.g. proportion of variation in in each pc), use
summary(pca)