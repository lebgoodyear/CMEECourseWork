################### Data Preparation ###################

# load packages
library(ggplot2)

# read csv (more easily viewed in rstudio)
crd <- read.csv("../Data/CRat.csv", stringsAsFactors = F)

crd <- subset(crd, !is.na(crd$N_TraitValue)) # remove any NAs

# subset by relelvant data columns
crd <- as.data.frame(cbind(crd$ID, log(crd$N_TraitValue), log(crd$ResDensity)))
names(crd) <- c("ID", "log_N_TraitValue", "log_ResDensity")

# initial plot of data
qplot(x = crd$log_ResDensity, y = crd$log_N_TraitValue, colour = crd$ID,
      xlab = "Log of Resource Density", ylab = "Log of Trait Value") +
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

## view all datasets to get a feel for the data
# open blank pdf page using a relative path
pdf(paste("../Results/Explore_Plots/IDs.pdf"),
    8, 4.5, onefile = TRUE) # save all plots to one pdf
for (i in IDs) {
  p <- subset(crd, crd$ID == i) # subset and plot the data by ID
  print(qplot(x = p$log_ResDensity, y = p$log_N_TraitValue,
              xlab = "log of Resource Density", ylab = "Log of Trait Value",
              main = paste("ID", i)) +
    geom_point())
}
dev.off()

# calculate initial starting value estimates for parameters
number = c(39835, 39836)
for (i in crd$ID) {
  subs <- subset(crd, crd$ID == i)
  start_h <- max(subs$log_N_TraitValue)
  find_a <- try(summary(lm(log_N_TraitValue ~ log_ResDensity, data = subs)))
  start_a <- find_a$coefficients[2]
  for (j in (which(crd$ID == i))) {
    crd$a_initial[j] <- start_a
    crd$h_initial[j] <- start_h
  }
}

# save subsetted data to new csv to be imported by python
write.csv(crd, "../Data/CRatMod.csv")

CRatMod <- read.csv("../Data/CRatMod.csv")


  