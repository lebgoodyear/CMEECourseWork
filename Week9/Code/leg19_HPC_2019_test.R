# CMEE 2019 HPC excercises R code HPC run code proforma

name <- "Lucy Goodyear"
preferred_name <- "Lucy"
email <- "leg19@imperial.ac.uk"
username <- "leg19"
personal_speciation_rate <- 0.002216 # will be assigned to each person individually in class and 
# should be between 0.002 and 0.007

rm(list=ls()) # good practice 
source("leg19_HPC_2019_main.R")
# it should take a faction of a second to source your file
# if it takes longer you're using the main file to do actual simulations
# it should be used only for defining functions that will be useful for your cluster run and which will be marked automatically

# do what you like here to test your functions (this won't be marked)
# for example

## Question 1
species_richness(c(1,4,4,5,1,6,1))
# should return 4

## Question 2
init_community_max(7)
# should return (1,2,3,4,5,6,7)

## Question 3
init_community_min(4)
# should return (1,1,1,1)

## Tests
species_richness(init_community_max(7))
# should return 7
species_richness(init_community_min(4))
# should return 1

## Question 4
choose_two(4)
# should return one of the following vectors with equal probability:
# (1,2), (1,3), (1,4), (2,1), (2,3), (2,4), (3,1), (3,2), (3,4), (4,1),
# (4,2), (4,3)

## Question 5
neutral_step(c(10,5,13))
# should return one of the following community states with equal probability
# (5,5,13), (13,5,13), (10,10,13), (10,13,13), (10,5,5), (10,5,10)

## Question 7
neutral_time_series(community = init_community_max(7), duration = 20)
# should return a vector length 21 with the first value being 7
# check length
length(neutral_time_series(community = init_community_max(7), duration = 20))

## Question 9
neutral_step_speciation(c(10,5,13), speciation_rate = 0.2)
# should behave either like test Question 5 or, if speciation occurs, return any of the
# followng vectors:
# (14,5,13), (10,14,13), (10,5,14)
# where 14 is the index of the new species

## Question 11
neutral_time_series_speciation(community = init_community_max(7), speciation_rate = 0.2, duration = 20)
# should return a vector of length 21 with decreasing then stabilising species richness

## Question 12
question_12()
# should plot two time series on same plot that converge

## Question 13
species_abundance(c(1,5,3,6,5,6,1,1))
# should return the vector (3,2,2,1)

## Question 14
octaves(c(100,64,63,5,4,3,2,2,1,1,1,1))
# should return the vector (4,3,2,0,0,1,2)

## Question 15
sum_vect(c(1,3),c(1,0,5,2))
# should return the vector (2,3,5,2)

## Question 16
question_16()
# should plot a bar chart of the means species abundance distribution (as octaves)

## Question 20
process_cluster_results()
# should plot 4 bar plots representing the results of the 4 different initial community sizes
# from the cluster run
# should also output four vectors corresponding to the octave outputs that plot these 4 bar charts

# you may also like to use this file for playing around and debugging
# but please make sure it's all tidied up by the time it's made its way into the main.R file or other files.

