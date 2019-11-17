################### Data Preparation ###################

library(ggplot2)
library(dplyr)

# read csv (more easily viewed in rstudio)
crd <- read.csv("../Data/CRat.csv")

crd <- subset(crd, !is.na(crd$TraitValue)) # remove any NAs

# subset by relelvant data columns
crd <- as.data.frame(cbind(crd$ID, crd$TraitValue, crd$ResDensity))
names(crd) <- c("ID", "TraitValue", "ResDensity")

# initial plot of data
qplot(x = log(crd$ResDensity), y = log(crd$TraitValue), colour = crd$ID)+
  geom_point()

# minimum number of values needed for fitting is 4 so check all unique IDs
# have a minimum of 4 datasets
x <- as.data.frame(matrix())
IDs <- as.data.frame(table(crd$ID))
y <- as.character(IDs$Var1)
for (i in (1:length(y))) {
  if (IDs[i,2] < 4) {
    x <- rbind(x, y[i])
  }
}

# we can see from the above that are no factors with less than 4 values so
# all can be used for fitting
write.csv(crd, "../Data/CRatMod.csv")

z <- c(crd, which(crd$ID == y[1]))
qplot(x = log(z$ResDensity), y = log(z$TraitValue)) +
  geom_point()

  