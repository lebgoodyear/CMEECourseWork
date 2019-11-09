############################# Practical on coalescence theory #################################

# Estimate the effective population size for two different populations of killer whales, using both
# Watterson's and Tajima's estimations of theta. 
# Calculates the site frequncy spectrum for the two populations

# clear workspace
rm(ls=(list))

# imports
library(dplyr)

# load data
kwn <- as.matrix(read.csv("../Data/killer_whale_North.csv", 
                 header = F, 
                 colClasses=rep("numeric"),
                 stringsAsFactors = F))
kws <- as.matrix(read.csv("../Data/killer_whale_South.csv", 
                 header = F, 
                 colClasses=rep("numeric"),
                 stringsAsFactors = F))

# theta = 4N*mu, where mu is the mutation rate and 2N is the population size

# calculate Tajima's estimate of theta

# Tajima's estimate of theta is the average number of pairwise differences
# Tajima's estimate of theta = pi = sum[i<j] (d [i,j] / n(n − 1)/  2
# where n = no of sequences, di,j = number of differences between sequence i and j

pi_tot <- 0
pi <- function(x) {
  # calculate the average number of pairwise differences
  n <- nrow(x)
  for (i in 1:(n-1)) {
    for (j in (i+1):n ) {
      pi_tot <- pi_tot + sum(abs(x[i,]-x[j,]))
    }
  }
  return(pi_tot/((n*(n-1))/2))
}

# calulate Watterson's estimate
# theta_W = S / (sum[k=1:n-1](1/k))
# where S is the number of SNPs and n is the no of sequences

# first locate SNP positions
sites <- c()
SNPs <- function(x) {
  # function loops over columns in dataset and chooses only those with exactly one repeated value
  for (i in 1:ncol(x)) {
    if (length(unique(x[,i])) == 2) { # positions with only one allele
      sites <- c(sites, i)
    }
  }  
  return(sites)
}

denom <- 0
theta_W <- function(x) {
  # calculates an estimate of theta using number of SNPs
  n <- nrow(x)
  for (i in 1:(n-1)) {
    denom <- denom + 1/i
  }
  return(length(SNPs(x))/denom)
}

# calculate estimated population size given mu and using our calculations for theta

# theta = 4N * mu, where 2N  = population size, mu = rate of mutation per site
# because mu is per site, we need to multiply by the length of the sequnce 
# (i.e. number of sites we are looking at)

# calculate estimated population using Tajima's estimation of theta
Ne_pi <- function(x) {
  # calculates estimated population using Tajima
  Ne_calc <- (pi(x)) / (2 * mu * (ncol(x)))
  return(Ne_calc)
}

# calculate estimated population using Watterson's estimation of theta
mu <- 1e-8
Ne_W <- function(x) {
  # calculates estimated population using Watterson
  Ne_calc <- (theta_W(x)) / (2 * mu  * (ncol(x)))
  return(Ne_calc)
}

cat("\nEstimated population for Northern killer whale using Tajima is", Ne_pi(kwn),
    "\nEstimated population for Northern killer whale using Watterson is", Ne_W(kwn),
    "\nEstimated population for Southern killer whale using Tajima is", Ne_pi(kws),
    "\nEstimated population for Southern killer whale using Watterson is", Ne_W(kws), "\n")

# calculate and plot the (unfolded) site frequency spectrum for each population

# 0 indicates the ancestoral allele and 1 indicates the derived allele
# calculate frequencies of the derived allele

sites <- as.matrix()
sfs <- function(x) {
  # calculates sfs by finding locations of SNPs and the frequencies of "1"
  # allele at each location
  
  # find SNP locations
  for (i in 1:ncol(x)) {
    if (length(unique(x[,i])) == 2) { 
      sites <- cbind(sites, c(x[,i]))
    }
  }
  # find frequencies for "1" allele
  frequencies <- c()
  for (j in (1:ncol(sites))) {
    freq <- as.double(length(which((sites[,j]) == 1)))
    # add alleles frequencies to frequency vector
    frequencies <- c(frequencies, freq)
  }
  # create sfs
  freq_spec <- rep(0, (nrow(sites)-1))
  for (k in (1:length(freq_spec))) {
    freq_spec[k] <- length(which(frequencies == k))
  }
  return(freq_spec/ncol(sites)) # divisions to get proportions rather than counts
}

# plot results
barplot(t(cbind(sfs(kws), sfs(kwn))), # t puts corresponding bars from the dataset next to each other
        beside = T,
        names.arg = seq(1:19),
        xlab = "Allele frequency",
        ylab = "Proportion of allele frequency",
        legend = c("Southern Killer Whales", "Northern Killer Whales"))

cat("\nThe population with the greatest estimated population has a higher 
    proportion of singletons")
  
  