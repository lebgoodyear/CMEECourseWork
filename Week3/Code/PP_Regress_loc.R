################### Calculating a linear model for predator and prey masses ##########################
####################### by feeding type, predator lifestage and location #############################

# Calculates linear regression model for predator and prey masses separated by type of 
# feeding interaction, predator lifestage, location and then saves as csv demlimited table.

# Author: Lucy Goodyear (lucy.goodyear19@imperial.ac.uk)
# Version: 0.0.1

# clear workspace
rm(list=ls())

# imports
library(dplyr)

# load the data
MyDF <- read.csv("../Data/EcolArchives-E089-51-D1.csv")
dim(MyDF) # check the size of the data frame you loaded

# convert masses in mg to g
for (i in 1:nrow(MyDF)){
  if (MyDF$Prey.mass.unit[i] == "mg"){
    MyDF$Prey.mass.unit[i] = "g"
    MyDF$Prey.mass[i] = MyDF$Prey.mass[i] / 1000
  }
}

# calculate the regression models
LM <- MyDF %>% 
         # first remove subset that contains only 2 examples, both with same species of prey and predator, 
         # because f-statistic can't be calculated on this (and no linear regression line can be drawn)
         filter(Record.number != "30914" & Record.number != "30929") %>%
         # remove subset corresponding to filters below because all predator masses are the same so no linear
         # model can be fitted
         filter(Type.of.feeding.interaction != "predacious" | Predator.lifestage != "adult" | Location != "Gulf of Maine, New England") %>%
         # subset only the data needed and group by feeeding type, predator lifestage and location
         dplyr::select(Record.number, Predator.mass, Prey.mass, Predator.lifestage, Type.of.feeding.interaction, Location) %>%
         group_by(Type.of.feeding.interaction, Predator.lifestage, Location) %>%
         # do linear model calculations and store specific values as columns to dataframe
         do(mod=lm(Predator.mass ~ Prey.mass, data = .)) %>%
         mutate(Regression.slope = summary(mod)$coeff[2],
                Regression.intercept = summary(mod)$coeff[1],
                R.squared = summary(mod)$adj.r.squared,
                Fstatistic = summary(mod)$fstatistic[1],
                P.value = summary(mod)$coeff[8]) %>%
         dplyr::select(-mod) # remove column created by mod=lm command

# save the regression results to a csv delimited table
write.csv(LM, "../Results/PP_Regress_Loc_Results.csv")
