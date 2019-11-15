########## Practical on population subdivision and demographic inferences ###############

# Calculate F_ST for 4 different turtle subpopulations

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

# set the 4 locations
locations <- rep(as.factor(c("A", "B", "C", "D")), each = 20)

turtle_al <- as.data.frame(cbind(locations, turtle_al))

# total population
turtle_al <- turtle_al[-2]

# location A
turtle_locA <- dplyr::filter(turtle_al, locations == "A")

# location B
turtle_locB <- dplyr::filter(turtle_al, locations == "B")

# location C

turtle_locC <- dplyr::filter(turtle_al, locations == "C")

# location D

turtle_locD <- dplyr::filter(turtle_al, locations == "D")

# function to calculate allele frequencies per SNP
freqA <- c()
fA <- function(x) {
  for (i in 1:ncol(x)) {
  freq <- length(which(x[,i] == 1)) / (nrow(x))
  # add alleles frequencies to frequency vector
  freqA <- c(freqA, freq)
  }
  return(freqA)
}

# calculate H_S for all locations pairwise

# for location A and B
H_sub <- c()
H_S <- function(x, y) {
  for (i in 1:length(fA(x))) {
    H_sub <- c(H_sub, fA(x)[i]*(1-fA(x)[i]) + fA(y)[i]*(1-fA(y)[i]))
  }
  return(mean(H_sub))
}
  