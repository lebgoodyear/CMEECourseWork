########## Practical on population subdivision and demographic inferences ###############

# Assesses whether there has been distance by isolation in a turtle species found at 4 different
# location using 3 methods:
# 1) calculate F_ST pairwise for the 4 different turtle subpopulations
# 2) build a tree of all the samples and check for clustering
# 3) conduct a Principle Component Analysis

# Script contains one function, calcF_ST, which calculates allele frequencies for each SNP 
# in 2 populations, then calculates H_T and H_S, which are then used to calculate F_ST

# clear workspace
rm(ls=(list))

# load data
turtle_al <- as.matrix(read.csv("../Data/turtle.csv", 
                          header = F, 
                          colClasses=rep("numeric"),
                          stringsAsFactors = F))
turtle_ge <- as.matrix(read.csv("../Data/turtle.genotypes.csv", 
                          header = F, 
                          colClasses=rep("numeric"),
                          stringsAsFactors = F))

### 1) calculate F_ST between locations using haplotype

calcF_ST <- function(pop1, pop2) {
  # calculates allele frequencies for each SNP in the 2 populations, then calculates H_T and H_S, 
  # which are then used to calculate F_ST
  # note, only works for populations of equal sizes
  
  # sum each SNP column and divide by sample size to get allele freqs for the 2 populations
  # note, MAR argument specifies if we apply the function over rows(1) or columns(2)
  fA1 <- as.numeric(apply(FUN=sum, X=pop1, MAR=2)/nrow(pop1)) 
  fA2 <- as.numeric(apply(FUN=sum, X=pop2, MAR=2)/nrow(pop2))
  # initiate and preallocate empty vector
  F_ST <- rep(NA, length(fA1))
  for (i in 1:length(F_ST)) {
  # calculate H_T for two populations
  H_T <- fA1[i] * (1 - fA1[i]) + fA2[i] * (1 - fA2[i]) + ((abs(fA1[i] - fA2[i])) ^2 ) / 2
  # calculate H_S for two populations
  H_S <- fA1[i] * (1 - fA1[i]) + fA2[i] * (1 - fA2[i]) 
  # create vector of F_ST containing F_ST for all SNPs
  F_ST[i] <- (H_T - H_S) / H_T
  }
  return(F_ST)
}

# we are only interested in SNPs with an allele frequency greater than 0.03 for allele 1
# across whole population (all locations)
SNPs <- which(apply(FUN = sum, turtle_al, MAR = 2) / nrow(turtle_al) > 0.03)

# print results
cat("\nAverage F_ST values for pairwise comparisions:",
    "\nA vs B:", mean(calcF_ST(turtle_al[1:20, SNPs], turtle_al[21:40, SNPs]), na.rm = T),
    "\nA vs C:", mean(calcF_ST(turtle_al[1:20, SNPs], turtle_al[41:60, SNPs]), na.rm = T),
    "\nA vs D:", mean(calcF_ST(turtle_al[1:20, SNPs], turtle_al[61:80, SNPs]), na.rm = T),
    "\nB vs C:", mean(calcF_ST(turtle_al[21:40, SNPs], turtle_al[41:60, SNPs]), na.rm = T),
    "\nB vs D:", mean(calcF_ST(turtle_al[21:40, SNPs], turtle_al[61:80, SNPs]), na.rm = T),
    "\nC vs D:", mean(calcF_ST(turtle_al[41:60, SNPs], turtle_al[61:80, SNPs]), na.rm = T),
    "\n")

# these values vindicate a certain degree of population subdivision, 
# particularly between A and the others.

# There is no evidence for isolation by distance because A has a similar 
# degree of subdivision for all other locations. 
# However there is evidence of admixture. Admixture is the mixing of DNA between
# previously isolated species. We can see that it is likely that C and D
# mate together more than, for example, A and C so admixture is likely to
# have occurred between populations at C and D.

### 2) Another method of doing this would be to build a tree of all the samples
# and then check for clustering
# we do this by building a distance matrix and then a tree

# first assign location labels to each row in the genotype dataset
locations <- rep(c("A","B","C","D"), each=10)

distance <- dist(turtle_ge)
tree <- hclust(distance)
plot(tree, labels=locations)

# Evidence of admixture is much easier to see from the tree

### 3) Another method of doing this would be to do a principle component analysis (pca)

locations <- rep(c("A","B","C","D"), each=10)
cols <- rep(c("blue","red","yellow","green"), each=5)

# create index of genotype frequencies greater than 0.03
# note, * 2 on denominator because we are counting alleles, not genotypes
index <- which(apply(FUN=sum, X=turtle_ge, MAR=2)/(nrow(turtle_ge)*2)>0.03)

# perform pca using in-built R function
pca <- prcomp(turtle_ge[,index], center=T, scale=T)

# print the summary of the pca
summary(pca)

# plot the results
plot(pca$x[,1], pca$x[,2], col=cols, pch=1)
legend("topright", legend=sort(unique(locations)), col=unique(cols), pch=1)


  