# use this script for computing background in "sparse" data such as H3K4me3 data in human cells; this script uses all the data including the (many) bins with zero reads.  Compare the results using the script Fit_NonZeroBkgrdRC_Exp.R which excludes the zero bins.  To begin, set working directory to location of files, then use the following to spcify which file to analyze.
rc_filename <- "binned_18wk150-1666.txt"
#in the above, my_file.txt is in 3 column BED format and column 4 is the number of reads in each bin
#after that, run the script beginning at line 9
#(the following two lines are for running this script on the command line)
args <- commandArgs(TRUE)
rc_filename <- args[1]
#as stated above, if specifying rc_filename <- "my_file" from the working directory, then run script beginning at line 9.
read_counts = read.table(rc_filename, sep="\t")
counts_k = numeric()
ratio = numeric()
n = 30 #max number of reads per bin visualized 
m = 9 #max number of reads per bin used to fit background to exponential distribution
q = 500 #max number of reads per bin for violin plot
x_fit = 0:m
x_view = 0:n
for (k in 0:n) {
  counts_k = c(counts_k, sum(read_counts[,4]==k))
}
for (k in 1:n) {
  ratio = c(ratio, counts_k[k+1]/counts_k[k])
}

mean_ratio = mean(ratio[1:m])
ratio_filename = paste(rc_filename, ".n", n, ".m", m, ".AllBins.read_counts_ratio.png", sep="")
png(ratio_filename)
plot(1:n, ratio, xlab="number of reads per bin", ylab="ratio", ylim=c(0,1))
lines(1:n, rep(mean_ratio,n), col="red")
graphics.off()

log_exp_model = lm(log(counts_k[1:(m+1)]) ~ x_fit)
intercept = as.numeric(log_exp_model$coefficients[1])
lambda = -as.numeric(log_exp_model$coefficients[2])
y = intercept - lambda*x_view 
fit_filename = paste(rc_filename, ".n", n, ".m", m, ".AllBins.log_counts_expdist_fit.png", sep="")
png(fit_filename)
plot(x_view, log(counts_k), xlab="number of reads per bin", ylab="ln(number of bins)", main=paste("ln exp dist fit: intercept =", round(intercept, digits=2), "lambda =", round(lambda, digits=2)))
lines(x_view, y, col="red")
graphics.off()

B0 = exp(intercept)
BTotal1 = B0 * exp(-lambda)/(1-exp(-lambda))**2
ExpBkgPerBin = 1/(exp(lambda)-1)
NumberBins = nrow(read_counts)
BTotal2 = NumberBins * ExpBkgPerBin
SampleMeanBkgPerBin = mean(read_counts[read_counts[,4]<m+1, 4])
TotalReads = sum(read_counts[,4])
TotalSignal1 = TotalReads - BTotal1
TotalSignal2 = TotalReads - BTotal2
ScaleFactor1 = BTotal1/10000000
ScaleFactor2 = BTotal2/10000000
ScaledSignal1 = (TotalReads - BTotal1)/ScaleFactor1
#ScaledSignal1 is the estimate of scaled, background subtracted reads in peaks
ScaledSignal2 = (TotalReads - BTotal2)/ScaleFactor2

summary_stats = cbind(intercept, lambda, B0, BTotal1, BTotal2, ExpBkgPerBin, SampleMeanBkgPerBin, TotalSignal1, TotalSignal2, ScaleFactor1, ScaleFactor2, ScaledSignal1, ScaledSignal2)
summary_stats_filename = paste(rc_filename, ".n", n, ".m", m, ".AllBins.expfit.stats.xls", sep="")
write.table(summary_stats, summary_stats_filename, quote=F, sep="\t", row.names=F)

library(vioplot)
vioplot_filename = paste(rc_filename, ".n", n, ".m", m, ".q", q, ".AllBins.vioplot.png", sep="")
png(vioplot_filename)
vioplot(read_counts[,4]/ScaleFactor1, ylim=c(0,q))
graphics.off()
