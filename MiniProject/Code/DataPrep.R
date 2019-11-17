################### Data Preparation ###################

library(ggplot2)
library(dplyr)

frd <- read.csv("../Data/Crat.csv")

frd <- subset(frd, !is.na(frd$TraitValue)) # remove any NAs

qplot(x = log(frd$ResDensity), y = log(frd$TraitValue), colour = frd$ID)+
  geom_point()

# minimum number of values needed for fitting is 4 so check all unique IDs
# have a minimum of 4 datasets
x <- as.data.frame(matrix())
IDs <- as.data.frame(table(frd$ID))
y <- as.character(IDs$Var1)
for (i in (1:length(y))) {
  if (IDs[i,2] < 4) {
    x <- rbind(x, y[i])
  }
}
# we can see from the above that are no factors with less than 4 values so
# all can be used for fitting
  