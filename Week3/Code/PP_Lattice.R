############################# Plotting lattice graphs ##################################
######################## and calculating means and medians ##############################

# Using a dataset containing predator-prey body size information to plot 3 lattice graphs 
# showing predator and prey masses and the ratio between them by types of food interaction.
# Also calculates mean and median for the above subsets and saves to csv.

# Author: Lucy Goodyear (lucy.goodyear19@imperial.ac.uk)
# Version: 0.0.1

# clear workspace
rm(list=ls())

# imports
library(lattice)
library(dplyr)

# load the data
PPDataFrame <- read.csv("../Data/EcolArchives-E089-51-D1.csv")

# convert masses in mg to g
for (i in 1:nrow(PPDataFrame)){
  if (PPDataFrame$Prey.mass.unit[i] == "mg"){
    PPDataFrame$Prey.mass.unit[i] = "g"
    PPDataFrame$Prey.mass[i] = PPDataFrame$Prey.mass[i] / 1000
  }
}

# plot a lattice plot of predator mass by type feeding interation and save as pdf
pdf("../Results/Pred_Lattice.pdf", # open blank pdf page using a relative path
    11.7, 8.3) # these numbers are page dimensions in inches
densityplot(~log(Predator.mass) | Type.of.feeding.interaction, data = PPDataFrame)

graphics.off()

# plot a lattice plot of prey mass by type feeding interation and save as pdf
pdf("../Results/Prey_Lattice.pdf",
    11.7, 8.3)
densityplot(~log(Prey.mass) | Type.of.feeding.interaction, data = PPDataFrame)

graphics.off()

# plot a lattice plot of the size ratio of prey mass over predator mass by type feeding interation and save as pdf
pdf("../Results/SizeRatio_Lattice.pdf",
    11.7, 8.3) 
densityplot(~log(Prey.mass/Predator.mass) | Type.of.feeding.interaction, data = PPDataFrame)

graphics.off()

# save to csv mean and median of predator mass, prey mass, and size ratio by type of feeding interaction
# using ddplyr and grouping by type of feeding interaction
Averages <- PPDataFrame %>%
            group_by(Type.of.feeding.interaction) %>%
            summarise(mean(log(Predator.mass)), 
                      median(log(Predator.mass)),
                      mean(log(Prey.mass)),
                      median(log(Prey.mass)),
                      mean(log(Prey.mass/Predator.mass)),
                      median(log(Prey.mass/Predator.mass)))

# set column names
names(Averages) <- c("Feeding.Type", 
                    "Mean:log.of.predator.mass",
                    "Median:log.of.predator.mass",
                    "Mean:log.of.prey.mass",
                    "Median:log.of.prey.mass",
                    "Mean:log.of.prey.mass/predator.mass",
                    "Median:log.of.prey.mass/predator.mass")

# save to csv
write.csv(Averages, "../Results/PP_Results.csv")

