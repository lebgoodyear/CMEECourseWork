################### Data Preparation ###################

# load packages
library(ggplot2)

# read csv (more easily viewed in rstudio)
crd <- read.csv("../Data/CRat.csv")

crd <- subset(crd, !is.na(crd$N_TraitValue)) # remove any NAs

# subset by relelvant data columns
crd <- as.data.frame(cbind(crd$ID, crd$N_TraitValue, crd$ResDensity))
names(crd) <- c("ID", "N_TraitValue", "ResDensity")

# initial plot of data
qplot(x = log(crd$ResDensity), y = log(crd$N_TraitValue), colour = crd$ID,
      xlab = "Resource Density", ylab = "Trait Value") +
  geom_point()

# minimum number of values needed for fitting is 4 so check all unique IDs
# have a minimum of 5 records
x <- as.data.frame(matrix())
IDs_Count <- as.data.frame(table(crd$ID))
IDs <- as.numeric(levels(IDs_Count$Var1))[IDs_Count$Var1]
for (i in (1:length(IDs))) {
  if (IDs_Count[i,2] < 5) {
    x <- rbind(x, IDs[i])
  }
}
if (is.null(x)) {
  print("The following IDs contain fewer than 5 records so are not suitable for modelling", x)
} else {
  print("There are no IDs with fewer than 5 records so all IDs can be used for modelling")
}
# we can see there are no IDs with fewer than 5 records so no
# IDs need to be removed
# view some random datasets to get a feel for the data
pdf(paste("../Results/Explore_Plots/IDs.pdf"),
    8, 4.5, onefile = TRUE)
for (i in IDs) {
  # open blank pdf page using a relative path
  p <- subset(crd, crd$ID == i)
  print(qplot(x = p$ResDensity, y = p$N_TraitValue,
              xlab = "Resource Density", ylab = "Trait Value",
              main = paste("ID", i)) +
    geom_point())
}
dev.off()

# save subsetted data to new csv to be imported by python
write.csv(crd, "../Data/CRatMod.csv")

CRatMod <- read.csv("../Data/CRatMod.csv")


  