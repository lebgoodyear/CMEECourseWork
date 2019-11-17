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
l <- as.character(IDs$Var1)
for (i in (1:length(l))) {
  if (IDs[i,2] < 4) {
    x <- rbind(x, l[i])
  }
}
# we can see from the above that are no factors with less than 4 values so
# all can be used for fitting

# view some random datasets to get a feel for the data
z <- subset(crd, crd$ID == crd$ID[1000])
qplot(x = log(z$ResDensity), y = log(z$TraitValue)) +
  geom_point()

# save subsetted data to new csv to be imported by python
write.csv(crd, "../Data/CRatMod.csv")



  