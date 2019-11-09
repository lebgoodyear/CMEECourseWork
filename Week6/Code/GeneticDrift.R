####### Practical on genetic drift, mutation and divergence #########

# given three gecko species and a proposed (but unlabeled) topology,
# obtain an estimate of the divergence time between bent-toed and western banded geckos by 
# 1) first calculating the genetic divergence between the two species and both species and the
# leopard gecko to place them on a given topology
# 2) calculate the rate of substitution (mutation rate) using the molecular clock, given the 
# time divergence for both species and the leopard gecko and the above calculated genetics divergences
# 3) calculate the time divergence using the mutation rate and the genetic divergence

# clear workspace
rm(ls=(list))

# load data
lg <- read.csv("../Data/leopard_gecko.csv", 
                  stringsAsFactors = F, 
                  header = F, 
                  colClasses = c("character"))

wbg <- read.csv("../Data/western_banded_gecko.csv", 
                  stringsAsFactors = F, 
                  header = F, 
                  colClasses = c("character"))

btg <- read.csv("../Data/bent-toed_gecko.csv", 
                  stringsAsFactors = F, 
                  header = F, 
                  colClasses = c("character"))


# identify which positions the the diverged sites, as they are fixed for different alleles in different species
fixed <- c()
count_fixed <- function(x) {
  # function loops over columns in dataset and chooses only those with exactly one repeated value
  for (i in 1:ncol(x)) {
    if (length(unique(x[,i])) == 1) { # positions with only one allele
      fixed <- c(fixed, i)
    }
  }  
  return(fixed)
}

# compare fixed sites between all 3 species, pairwise
sites <- c()
div_sites <- c()
all_sites <-data.frame(matrix())
compare2 <- function(x, y) {
  # function loops over combined dataframe to find sites with different alleles
  sites <- intersect(count_fixed(x), count_fixed(y)) # only compare non-heterozygous sites in both species
  all_sites <- rbind(x[,sites], y[,sites]) # combine into one dataframe
  for (i in 1:ncol(all_sites)) {
    if (length(unique(all_sites[,i])) == 2) { # locate sites where the two species have different alleles
      div_sites <- c(div_sites, i)
    }
  }
  return(div_sites)
}

gen_divs <- function(x, y) {
  # function compares non-heterozygous sites between species, locates those with differences
  # and calculates the genetics divergence from the number of these sites
  sites <- intersect(count_fixed(x), count_fixed(y)) # only compare non-heterozygous sites in both species
  all_sites <- rbind(x[,sites], y[,sites]) # combine into one dataframe
  for (i in 1:ncol(all_sites)) {
    if (length(unique(all_sites[,i])) == 2) { # locate sites where the two species have different alleles
      div_sites <- c(div_sites, i)
    }
  }
  gen_div <- sum(length(div_sites)/ncol(all_sites)) # calculate genetic divergence
  return(gen_div)
}

cat("\n Genetic divergence of leopard gecko and western banded gecko is", gen_divs(lg, wbg),
    "\n Genetic divergence of leopard gecko and bent-toed gecko is", gen_divs(lg, btg),
    "\n Genetic divergence of western banded and bent-toed gecko is", gen_divs(wbg, btg))

# we can see that leopard gecko diverged earlier from the other two geckos (30Mya)
# calculate an estimate of the divergence time between the bent-toed and the western banded gecko

# first calculate rate of substitution, mu, from leopard gecko and bent-toed gecko using molecular 
# clock: E[dAB] = 2(mu) * tAB
E_lg_btg <- length(compare2(lg, btg)) # expected number of nucleotide differences separating sequences of the same genes in the two species
tAB_lg_btg <- 30 # divergence time given
mu <- E_lg_btg / (2 * tAB_lg_btg)

# calculate tAB for bent-toed gecko and western banded gecko
tAB_wbg_btg <- length(compare2(wbg, btg)) / (2 * mu)

cat("The estimated divergence time between western banded geckos and bent-toed geckos is",
    round(tAB_wbg_btg, 2), "million years")

