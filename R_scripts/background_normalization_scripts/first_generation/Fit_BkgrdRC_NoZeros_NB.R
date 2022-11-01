args <- commandArgs(TRUE)
rc_filename <- args[1]
read_counts_zeros = read.table(rc_filename, sep="\t")
read_counts = read_counts_zeros[read_counts_zeros[,4]>0,]
cat("Done reading ", rc_filename, "\n")
library(MASS)
quan = as.numeric(quantile(read_counts[,4], probs = seq(0, 1, 0.01)))
start_quan = 97
end_quan = 99
max_quan = 99
x = seq(0,floor(quan[max_quan+1]),1)
size = numeric()
mu = numeric()
loglik = numeric()
rc_hist = hist(read_counts[read_counts[,4]<quan[max_quan+1],4],breaks=50)
hist_max_index = which.max(rc_hist$counts)
robust_hist_max = mean(c(rc_hist$counts[hist_max_index-1], rc_hist$counts[hist_max_index], rc_hist$counts[hist_max_index+1]))

for (i in start_quan:end_quan) {
	param = fitdistr(read_counts[read_counts[,4]<quan[i+1],4], "negative binomial")
	this_size = param$estimate[["size"]]
	this_mu = param$estimate[["mu"]]
	size = c(size, this_size)
	mu = c(mu, this_mu)
	loglik = c(loglik, param$loglik)
	max_nb_density = max(dnbinom(x,this_size,mu=this_mu))
	scale = robust_hist_max/max_nb_density
	png_file_name = paste("NB_Fit_SCBin_RCLT", floor(quan[i+1]), ".png", sep="")
	png(png_file_name)
	plot(rc_hist, xlab="Read Counts", main=paste("NB Fit: rc_cutoff=", floor(quan[i+1]), " size=", round(this_size, digits=2), " mu=", round(this_mu, digits=2)))
	lines(x,scale*dnbinom(x,this_size,mu=this_mu), col="red")
	graphics.off()
}

percentile = start_quan:end_quan
rc_cutoff = quan[(start_quan+1):(end_quan+1)] 
summary_stats = cbind(percentile, rc_cutoff, size, mu, loglik)
summary_stats_filename = paste(rc_filename, ".nbfit.stats.txt", sep="")
write.table(summary_stats, summary_stats_filename, quote=F, sep="\t", row.names=F)
