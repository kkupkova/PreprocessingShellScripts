#use this script to plot PC3 versus PC4 without sample names
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

#now run through line 32
plotPCAPC34NoNames = function(x, intgroup="condition", ntop=500)
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
    colours = c( "dodgerblue", "firebrick3" )
  
  #or set two colors, one for each of the two conditions
  colours = c( "dodgerblue", "firebrick3" )
  
  #plot parameters
  xyplot(
    PC4 ~ PC3, groups=fac, data=as.data.frame(pca$x), pch=16, cex=1.5,
    panel=function(x, y, ...) {
      panel.xyplot(x, y, ...)
    },
    #for no legend use this- also set axis label font sizes with cex
    aspect = "iso", col=colours, scales=list(cex=1.5), xlab=list(cex=1.5),ylab=list(cex=1.5))

  #for legend use this
  aspect = "iso", col=colours, scales=list(cex=1.5), xlab=list(cex=1.5),ylab=list(cex=1.5),
  
  #add legend if desired
  main = draw.key(key = list(
    rect = list(col = colours),
    text = list(levels(fac)),
    rep = FALSE)))

#add this curly bracket at end
}

#now generate plot using this command 
print(plotPCAPC34NoNames(rld,intgroup=c("condition")))

#or this command, as appropriate 
print(plotPCAPC34NoNames(vsd,intgroup=c("condition")))

#then save a copy of it
ggsave("my_PCA_plot.pdf", width = 6, height = 6)

#if ggsave document can't be opened, do this instead

pdf("my_PCA_plot.pdf")
print(plotPCAPC34NoNames(rld,intgroup=c("condition")))
dev.off()

#if you want the statistics associated with the pca (e.g. proportion of variation in in each pc), use
summary(pca)
