# use this script for computing background in "sparse" data such as H3K4me3 data in human cells; this script uses the bins with 1 or more reads (i.e. excludes the zero bins).  Compare the results using the script Fit_BkgrdRC_Exp.R which includes the zero bins.  
#this script is identical to Fit_NonZeroBkgrdRC_Exp.R except that it provides the adjusted R^2 value at the end.
#To begin, set working directory to location of files, then use the following to spcify which file to analyze.
rc_filename <- "my_file.txt"
#in the above, my_file.txt is in 3 column BED format and column 4 is the number of reads in each bin 
#after that, run the script beginning at line 8
args <- commandArgs(TRUE)
rc_filename <- args[1]
#as stated above, if specifying rc_filename <- "my_file" from the working directory, then run script beginning at line 8.
read_counts_zeros = read.table(rc_filename, sep="\t")
read_counts = read_counts_zeros[read_counts_zeros[,4]>0,]
counts_k = numeric()
ratio = numeric()
n = 30 #max number of reads per bin visualized 
m = 9 #max number of reads per bin used to fit background to exponential distribution
q = 500 #max number of reads per bin for violin plot
x_fit = 1:m
x_view = 1:n
for (k in 1:n) {
  counts_k = c(counts_k, sum(read_counts[,4]==k))
}
for (k in 1:n-1) {
  ratio = c(ratio, counts_k[k+1]/counts_k[k])
}

mean_ratio = mean(ratio[1:m-1])
ratio_filename = paste(rc_filename, ".n", n, ".m", m, ".NonZeroBins.read_counts_ratio.png", sep="")
png(ratio_filename)
plot(2:n, ratio, xlab="number of reads per bin", ylab="ratio", ylim=c(0,1))
lines(2:n, rep(mean_ratio,n-1), col="red")
graphics.off()

log_exp_model = lm(log(counts_k[1:m]) ~ x_fit)
intercept = as.numeric(log_exp_model$coefficients[1])
lambda = -as.numeric(log_exp_model$coefficients[2])
y = intercept - lambda*x_view 
fit_filename = paste(rc_filename, ".n", n, ".m", m, ".NonZeroBins.log_counts_expdist_fit.png", sep="")
png(fit_filename)
plot(x_view, log(counts_k), xlab="number of reads per bin", ylab="ln(number of bins)", main=paste("ln exp dist fit: intercept =", round(intercept, digits=2), "lambda =", round(lambda, digits=2)))
lines(x_view, y, col="red")
graphics.off()

B0 = exp(intercept)
BTotal1 = B0 * exp(-lambda)/(1-exp(-lambda))**2
ExpBkgPerBin = 1/(1-exp(-lambda))
NumberNonZeroBins = nrow(read_counts)
BTotal2 = NumberNonZeroBins * ExpBkgPerBin
SampleMeanBkgPerBin = mean(read_counts[read_counts[,4]<m+1, 4])
TotalReads = sum(read_counts[,4])
TotalSignal1 = TotalReads - BTotal1
TotalSignal2 = TotalReads - BTotal2
ScaleFactor1 = BTotal1/10000000
ScaleFactor2 = BTotal2/10000000
ScaleFactor3 = ExpBkgPerBin
ScaledSignal1 = (TotalReads - BTotal1)/ScaleFactor1
#ScaledSignal1 is the estimate of scaled, background subtracted reads in peaks
ScaledSignal2 = (TotalReads - BTotal2)/ScaleFactor2

summary_stats = cbind(intercept, lambda, B0, BTotal1, BTotal2, ExpBkgPerBin, SampleMeanBkgPerBin, TotalSignal1, TotalSignal2, ScaleFactor1, ScaleFactor2, ScaleFactor3, ScaledSignal1, ScaledSignal2)
summary_stats_filename = paste(rc_filename, ".n", n, ".m", m, ".NonZeroBins.expfit.stats.xls", sep="")
write.table(summary_stats, summary_stats_filename, quote=F, sep="\t", row.names=F)

library(vioplot)
vioplot_filename = paste(rc_filename, ".n", n, ".m", m, ".q", q, ".NonZeroBins.vioplot.png", sep="")
png(vioplot_filename)
vioplot(read_counts[,4]/ScaleFactor1, ylim=c(0,q))
graphics.off()

#print summary statistics for linear model
#summary(log_exp_model)

#print adjusted R^2
SSres_df = deviance(log_exp_model)/df
SStot = var(log(counts_k[1:(m+1)]))
adjRsqr = 1-SSres_df/SStot
print("Adjusted R^2: ");print(adjRsqr)
