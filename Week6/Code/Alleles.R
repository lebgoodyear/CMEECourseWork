############## Practical on Allele and Genotype frequencies ################

# create function, analyse(x), to conduct analysis on SNPs in a dataset x

# first find SNP locations, then calculate allele and genotype frquencies and
# homozygosity and heterozygosity
# calculate expected genotype counts and test for Hardy-Weinstein Equilibrium (HWE)
# finally calculate inbreeding coefficient for SNPs that deivate from HWE

# clear workspace
rm(ls=(list))

# load packages
library(plyr)

# load bear csv data
bears <- read.csv("../Data/bears.csv", 
                  stringsAsFactors = F, 
                  header = F, 
                  colClasses = c("character"))

# function to analyse allele frequencies and compare to HWE
n_SNPs <- c()
frequencies <- c()
samples <- 20
nonHWE <- c()
IC <- c()
analyse <- function(x){
  # function to:
  # 1) identify which positions are SNPs
  # 2) calculate, print and visualise allele frequencies for each SNP
  # 3) calculate and print genotype frequencies for each SNP
  # 4) calculate (observed) homozygosity and heterozygosity for each SNP
  # 5) calculate expected genotype counts for each SNP and test for HWE
  # 6) calculate, print and visualise inbreeding coefficient for each SNP deviating from HWE
  
  
  # 1) identify which positions are SNPs
  for (i in 1:ncol(x)) {
    if (length(unique(x[,i])) == 2) { # assume species is diploid
      n_SNPs <- c(n_SNPs, i) # collate column numbers for SNPs
    }
  }
  cat("\n Number of SNPs is", length(n_SNPs))
  # subset the data by SNPs
  SNPs <- bears[,n_SNPs]
  dim(SNPs)
  
  # 2) calculate, print and visualise allele frequencies
  for (i in 1:ncol(SNPs)) {
  alleles <- unique(SNPs[,i])
  cat("\nSNP", i, ": \n", alleles)
  # calculate frequency of the second allele (arbitrary choice at this stage)
  freq <- length(which(SNPs[,i] == alleles[2])) /nrow(SNPs)
  cat(" \nallele frequency of the second allele: ", freq)
  # add alleles frequencies to frequency vector
  frequencies <- c(frequencies, freq)
  
  # 3) calculate and print genotype frequencies
  # set up empty 3-vector (for 2 homozygous genotypes and 1 heterozygous)
  geno_count <- c(0, 0, 0)
  # actual genotypes
  for (j in 1:samples) {
    index <- c((j*2)-1, (j*2)) # to take rows 1,2 then 3,4 etc.
    # count instances of allele 2
    # allele2/allele2 means the length function below = 2, + 1 means the 
    # genotype index is 3 so allele2/allele2 is the third index in the vector
    # allele2/allele1 has length 1 for allele 2 so with + 1 is the second index
    # allele1/allele1 is the first index of the vector
    genotype <- length(which(SNPs[index, i] == alleles[2])) + 1
    # increase the counter for the corresponding genotype
    geno_count[genotype] <- geno_count[genotype] + 1
  }
  cat("\ngenotype frequencies: ", geno_count)
  
  # 4) calculate and print homozygosity and heterozygosity
  homo <- (geno_count[1] + geno_count[3]) / samples
  hetero <- geno_count[2] / samples
  cat("\nhomozygosity: ", homo)
  cat("\nheterogosity: ", hetero)
  
  # 5) calculate expected genotype counts and test for HWE
  # calculate expected genotype counts from allele frequencies, under HWE
  exp_genotype_count <- c( (1-freq)^2, 2*freq*(1-freq)^2, freq^2) * samples
  # calculate chi^2 statistic
  chi <- sum((exp_genotype_count - geno_count)^2 / exp_genotype_count)
  # calculate p-value
  pv <- 1 - pchisq(chi, df = 1)
  cat("\np-value for test against HWE: ", pv)
  # subset only SNPs with p-value < 0.05
  if (pv < 0.05) {
    nonHWE <- c(nonHWE, i)
  } 
  
  # 6) calculate print and visualise inbreeding coefficient for each SNP deviating from HWE
  inbreeding <- (2*freq*(1-freq) - geno_count[2]/samples) / (2*freq*(1-freq))
  IC <- c(IC, inbreeding)
  cat("\ninbreeding coefficient:", inbreeding, "\n")
  }
  
  # plot the frequency of second allele at each SNP location
  plot(frequencies, type = "h")
  
  # plot the inbreeding coefficients
  hist(IC)
  plot(IC, type="h")
}


