#I can help you install this if needed: https://github.com/andrelmartins/bigWig
#to get bigWIg install UCSC tool kit use following:$ wigToBigWig WT.Fnor.smooth.wig sacCer3.chrom.sizes WT.Fnor.smooth.bigWig
library(lattice)
library(bigWig)
library(latticeExtra)

#this function calculates the position downstream from the TSS with the highest read count
#this was used to align +1 nucleosomes across genes but is not necessary for average plots with respect to TSS
calc.highest.probe <- function(sites, wig, window = 30) {
  N = dim(sites)[1]
  result = vector(mode="integer", length=N)
  chromo = vector(mode="numeric", length=N)
  chromo.end = vector(mode="numeric", length=N)
  vector(mode="numeric", length=N)
  cur.chrom = NULL
  cur.wig = NULL
  cur.wig = load.bigWig(wig)
  stopifnot(!is.null(cur.wig))
  for (i in 1:N) {
    chrom = as.character(sites[i,1])
    if (is.null(cur.chrom) || cur.chrom != chrom) {
      cur.chrom = chrom
    }
    qStart = as.numeric(as.character(sites[i, 2]))
    qEnd = as.numeric(as.character(sites[i, 3]))
    center = (qStart + qEnd)/2
    data = query.bigWig(cur.wig, cur.chrom, qStart, qEnd)
    if (!is.null(data)) {
      maximum=max(data[,3])
      newvar = subset(data, data[,3] == maximum)
      min.distance=min(abs(((newvar[,1]+newvar[,2])/2)-center))
      num.rows = dim(newvar)[1]
      if (num.rows != 0) {
        for (j in 1:num.rows) {
          if (min(abs(((newvar[j,1]+newvar[j,2])/2)-center)) == min.distance) {
            highest.closest.probe = newvar[j,]
          }
        }
      }
      highest.closest.probe = matrix(highest.closest.probe,nrow=1, ncol=3)
      start = round((highest.closest.probe[,1]+highest.closest.probe[,2])/2) - window
      end = round((highest.closest.probe[,1]+highest.closest.probe[,2])/2) + window
      result[i] = highest.closest.probe[,3]
      chromo[i] = round((highest.closest.probe[,1] + highest.closest.probe[,2])/2)
    } else {
      chromo[i] = round((qStart + qEnd)/2)
    }
  }
  unload.bigWig(cur.wig)
  df = cbind(as.character(sites[,1]),matrix(chromo - window,nrow=N), matrix(chromo + window,nrow=N))
  df= as.data.frame(df)
  colnames(df) = c('chr', 'start', 'end')
  df[,2] = as.numeric(as.character(df[,2]))
  df[,3] = as.numeric(as.character(df[,3]))
  df[,4] = sites[,4]
  df[,5] = sites[,5]
  df[,6] = sites[,6]
  
  return(df)
}


window.step <- function(bed, bigWig, halfWindow, step) {
  windowSize = (2* halfWindow) %/% step
  midPoint = floor((as.numeric(as.character(bed[ ,2])) + as.numeric(as.character(bed[,3]))) / 2)
  start = (midPoint - halfWindow)
  end = start + windowSize * step
  if ((as.numeric(as.character(bed[1 ,2])) + as.numeric(as.character(bed[1 ,3]))) %% 2 == 0) {
    bed[ ,2] = start
    bed[ ,3] = end
  } else {
    bed[ ,2] = start
    bed[ ,3] = end
    bed[ ,2][bed[ ,6] == '-'] = bed[ ,2][bed[ ,6] == '-'] + 1
    bed[ ,3][bed[ ,6] == '-'] = bed[ ,3][bed[ ,6] == '-'] + 1
  }
  matrix.comp = bed6.step.bpQuery.bigWig(bigWig, bigWig, bed, 1, op = "avg", follow.strand = TRUE)
  res = do.call(rbind, matrix.comp)
  return(list(res, matrix.comp))
}
           
composites.test <- function (path.dir , composite.input , region =20 , step =1, grp = 'MNase') {
  vec.names = c('chr ','start ','end ')
  hmap.data = list()
  composite.df= data.frame(matrix(ncol = 6, nrow = 0))
  for (mod.bigWig in Sys.glob(file.path(path.dir , "*.bigWig"))) {
    factor.name = strsplit(strsplit(mod.bigWig , "/") [[1]][length(strsplit(mod.bigWig , "/") [[1]])], '\\.')[[1]][1]
    print(factor.name)
    vec.names = c(vec.names, factor.name)
    wiggle = load.bigWig(mod.bigWig)
    bpquery = window.step(composite.input, wiggle, region, step)
    mult.row = ncol(bpquery[[1]])
    hmap.data[[factor.name]] = bpquery[[1]]
    df.up <- data.frame(matrix(ncol = 6, nrow = mult.row))
    df.up[, 1] <- colMeans(bpquery[[1]])
    df.up[, 2] <- seq((-1 * region ) + 0.5 * step, region - 0.5 * step, by =step)
    df.up[, 3] <- matrix(data = factor.name, nrow = mult.row , ncol =1)
    df.up[, 4] <- df.up[,1]
    df.up[, 5] <- df.up[,1]
    df.up[, 6] <- matrix(data = grp, nrow = mult.row, ncol =1)
    composite.df = rbind(composite.df, df.up)
    unload.bigWig(wiggle)
  }
  colnames (composite.df) <- c('est', 'x', 'cond', 'upper', 'lower', 'grp')
  composite.df = composite.df[composite.df[,2] >= -1000 & composite.df [,2]  <= 1000 ,]
  for (cond in (1:length(hmap.data))) {
    rownames(hmap.data[[cond]]) = paste(composite.input[,1], ':', composite.input[,2], '-', composite.input[,3], sep='')
    colnames(hmap.data[[cond]]) = seq((-1 * region) + 0.5 * step, region - 0.5 * step, by = step)
  }
  return(list(composite.df , hmap.data))
}

#this generates the plot(s)
composites.func.panels.chromatin <- function(dat, fact = 'Factor ', summit = 'Summit', num =90) {
  col.lines = c(rgb(0 ,0 ,1 ,1/2), rgb(1, 0, 0, 1/2), "purple", "#0faa12")
  count = length(unique(dat$grp))
  pdf(paste('composite _', fact , '_signals_', summit , '_peaks.pdf', sep=''), width = 2 * 3.43, height = ceiling((count/2)) * 3.43)
  print(xyplot(est ~ x|grp, group = cond, data = dat, type = 'l',
               #switch x|grp and group = cond above to get different panels as shown below as alternative
               #scales = list(x= list(cex =0.8, at=seq(-(num), (num), (num)/3), relation = "free"), y = list(cex =0.8, relation ="free")), xlim =c(-(num) ,(num)),
               col = col.lines,
               auto.key = list(points = F, lines =T, cex =0.8),
               par.settings = list (superpose.symbol = list(pch = c(16) , col=col.lines), superpose.line = list(col = col.lines, lwd =3)),
               cex.axis =1.0,
               par.strip.text = list(cex =0.9 , font =1, col ='black'),
               aspect =1.0,
               between = list (y=0.5 , x =0.5) ,
# index . cond = list (c(2 ,1)),
               lwd =3,
               ylab = list(label = paste(fact," MNase signal", sep=''), cex =0.8),
               xlab = list(label = paste("Distance from ", summit , " center",sep=''), cex =0.8),
               upper = dat$upper,
               lower = dat$lower,
               strip = function(..., which.panel, bg) {
                 bg.col = c("grey85 ")# " grey40 " ,"#0 a823c ", "#0 a823c ") #blue , red green
                 strip.default(... ,which.panel = which.panel , bg =rep(bg.col, length = which.panel)[which.panel])
               }
               ))
  dev.off()
}

#this converts the TSS annotation file from UCSC to proper format
tss = read.table('/Users/dauble/data/yeast_ChIP-seq_data_2015-2016/MNase-seq/Guertin_+1_nucleosome_alignment/data_files/bw/from_dpos/reanalysis_with_renorm_files/annotations/scTSSannotations.df.txt', stringsAsFactors=FALSE) #change path as needed
tss[,6][tss[,6] == 1] = '+'
tss[,6][tss[,6] == -1] = '-'
#make the window the 200 bp d/s of the TSS
tss[,3][tss[,6] == '+'] = tss[,2][tss[,6] == '+'] + 200
tss[,2][tss[,6] == '+'] = tss[,2][tss[,6] == '+'] - 200 #

tss[,2][tss[,6] == '-'] = tss[,3][tss[,6] == '-'] - 200
tss[,3][tss[,6] == '-'] = tss[,3][tss[,6] == '-'] + 200 #

tss[,1] = paste('chr', tss[,1], sep='')
tss[,1][tss[,1] == 'chrMito'] = 'chrM'
tss = tss[tss[,2] >1000,]
#d = calc.highest.probe(tss, '/Users/dauble/data/yeast_ChIP-seq_data_2015-2016/MNase-seq/Guertin_+1_nucleosome_alignment/data_files/bw/mot1_vs_WT/', 100) #change path as needed
a = composites.test('/Users/dauble/data/yeast_ChIP-seq_data_2015-2016/MNase-seq/Guertin_+1_nucleosome_alignment/data_files/bw/from_dpos/reanalysis_with_renorm_files/', tss, region =500, step =1) #change path as needed
#s = composites.test('/Users/dauble/data/yeast_ChIP-seq_data_2015-2016/MNase-seq/Guertin_+1_nucleosome_alignment/data_files/bw/WT', d, region =1000, step =1)  #change path as needed
composites.func.panels.chromatin(a[[1]], fact = 'Average', summit = 'TSS', num =800)
#composites.func.panels.chromatin(s, fact = 'Average', summit = 'Summit', num =800)
