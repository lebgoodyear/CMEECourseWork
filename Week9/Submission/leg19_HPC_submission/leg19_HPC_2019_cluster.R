# CMEE 2019 HPC excercises R code HPC run code proforma
name <- "Lucy Goodyear"
preferred_name <- "Lucy"
email <- "leg19@imperial.ac.uk"
username <- "leg19"
personal_speciation_rate <- 0.002216 # will be assigned to each person individually in class and 
# should be between 0.002 and 0.007

# clear workspace
rm(list=ls())

# source R file containing all functions
# this will change for running on cluster to include path
# source("/rds/general/user/leg19/home/Week9HPC/leg19_HPC_2019_main.R")
source("leg19_HPC_2019_main.R")

# read in the job number from the cluster
iter <- as.numeric(Sys.getenv("PBS_ARRAY_INDEX"))
# test on my machine
#iter <- 76

# ensure each parallel simulation takes place with a different seed
set.seed(iter)
if ((iter >= 1) & (iter <= 25)){
  size = 500
}
if ((iter > 25) & (iter <= 50)){
  size = 1000
}
if ((iter > 50) & (iter <= 75)){
  size = 2500
}
if ((iter > 75) & (iter <= 100)){
  size = 5000
}
# save output into separate files named after the iteration
output_file_name <- paste0("Results", iter, ".rda")
# call cluster_run function with personal speciation_rate = 0.002216
cluster_run(speciation_rate = 0.002216, size = size, wall_time = 11.5*60, interval_rich = 1, interval_oct = as.numeric(size/10), burn_in_generations = 8*size, output_file_name = output_file_name)



