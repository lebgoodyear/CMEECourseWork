############## Practical on Allele and Genotype frequencies ################

# find inbreeding coefficients for different SNPs in bear genomes
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

# 1) identify which positions are SNPs

n_SNPs <- c()
for (i in 1:ncol(bears)) {
  if (length(unique(bears[,i])) == 2) { # bears are diploid
    n_SNPs <- c(n_SNPs, i) # collate column numbers for SNPs
  }
}
cat("\n Number of SNPs is", length(n_SNPs))

# subset the data by SNPs
SNPs <- bears[,n_SNPs]
dim(SNPs)

# 2) calculate, print and visualise allele frequencies

frequencies <- c()
for (i in 1:ncol(SNPs)) {
  alleles <- unique(SNPs[,i])
  cat("\nSNP", i, "with alleles", alleles)
  # calculate frequency of the second allele (arbitrary choice at this stage)
  freq <- length(which(SNPs[,i] == alleles[2])) /nrow(SNPs)
  cat(" and allele frequency of the second allele is", freq)
  # add alleles frequencies to frequency vector
  frequencies <- c(frequencies, freq)
}

# plot the frequency of second allele at each SNP location
plot(frequencies, type = "h")

# 3) calculate and print genotype frequencies
samples <- 20
for (i in 1:ncol(SNPs)) {
  alleles <- unique(SNPs[,i])
  #cat("\nSNP", i, "with alleles", alleles)
  # set up empty 3-vector (for 2 homozygous genotypes and 1 heterozygous)
  geno_count <- c(0, 0, 0)
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
  cat(" and genotype frequencies", geno_count)
}

# 4) calculate and print homozygosity and heterozygosity

samples <- 20
for (i in 1:ncol(SNPs)) {
  alleles <- unique(SNPs[,i])
  # set up empty 3-vector (for 2 homozygous genotypes and 1 heterozygous)
  geno_count <- c(0, 0, 0)
  for (j in 1:samples) {
    index <- c((j*2)-1, (j*2)) # to take rows 1,2 then 3,4 etc.
    genotype <- length(which(SNPs[index, i] == alleles[2])) + 1
    # increase the counter for the corresponding genotype
    geno_count[genotype] <- geno_count[genotype] + 1
  }
  # calulate and print homozygosity and heterozygosity
  homo <- (geno_count[1] + geno_count[3]) / samples
  hetero <- geno_count[2] / samples
  cat("\n homozygosity of SNP", i, "is ", homo)
  cat("\n heterogosity of SNP", i, "is ", hetero)
}

# 5) calculate expected genotype counts and test for HWE

nonHWE <- c()
samples <- 20
for (i in 1:ncol(SNPs)) {
  alleles <- unique(SNPs[,i])
  freq <- length(which(SNPs[,i] == alleles[2])) / nrow(SNPs)
  # calculate expected genotype counts from allele frequencies, under HWE
  exp_genotype_count <- c( (1-freq)^2, 2*freq*(1-freq)^2, freq^2) * samples
  geno_count <- c(0, 0, 0)
  # actual genotypes
  for (j in 1:samples) {
    index <- c((j*2)-1, (j*2)) # to take rows 1,2 then 3,4 etc.
    genotype <- length(which(SNPs[index, i] == alleles[2])) + 1
    # increase the counter for the corresponding genotype
    geno_count[genotype] <- geno_count[genotype] + 1
  }
  # compare actual and expected genotype counts (i.e. test HWE)
  # calculate chi^2 statistic
  chi <- sum((exp_genotype_count - geno_count)^2 / exp_genotype_count)
  # calculate p-value
  pv <- 1 - pchisq(chi, df = 1)
  cat("\n p-value for test against HWE for SNP", i, "is", pv)
  # subset only SNPs with p-value < 0.05
  if (pv < 0.05) {
    nonHWE <- c(nonHWE, i)
  }  
}

# 6) calculate print and visualise inbreeding coefficient for each SNP deviating from HWE

nonHWE <- SNPs[,nonHWE]
IC <- c()
samples <- 20
for (i in 1:ncol(nonHWE)) {
  alleles <- unique(nonHWE[,i])
  freq <- length(which(nonHWE[,i] == alleles[2])) / nrow(nonHWE)
  # calculate expected genotype counts from allele frequencies, under HWE
  exp_genotype_count <- c( (1-freq)^2, 2*freq*(1-freq)^2, freq^2) * samples
  # actual genotypes
  geno_count <- c(0, 0, 0)
  for (j in 1:samples) {
    index <- c((j*2)-1, (j*2)) # to take rows 1,2 then 3,4 etc.
    genotype <- length(which(nonHWE[index, i] == alleles[2])) + 1
    # increase the counter for the corresponding genotype
    geno_count[genotype] <- geno_count[genotype] + 1
  }
  # calculate inbreeding coefficient
  inbreeding <- (2*freq*(1-freq) - geno_count[2]/samples) / (2*freq*(1-freq))
  IC <- c(IC, inbreeding)
  cat("\n Inbreeding coefficient of SNP", i, "is", inbreeding)
}

# plot the inbreeding coefficients
hist(IC)
plot(IC, type="h")


