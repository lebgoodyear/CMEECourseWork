##################################################################
####################### Data Preparation #########################
##################################################################


# Author: Lucy Goodyear (lucy.goodyear19@imperial.ac.uk)
# Version: 0.0.1

# clear workspace
rm(list=ls())


########### initial set up, package and data loading #############


# load packages
library(ggplot2)

# read csv
crd <- read.csv("../Data/CRat.csv", stringsAsFactors = F)


##################### subset and filter data #####################


# subset to remove any NAs in trait value
crd <- subset(crd, !is.na(crd$N_TraitValue))

# subset by relelvant data columns: ID, trait value and resource density
crd <- as.data.frame(cbind(crd$ID, crd$N_TraitValue, crd$ResDensity))
names(crd) <- c("ID", "N_TraitValue", "ResDensity")

# initial plot of data for quick viewing
qplot(x = crd$ResDensity, y = crd$N_TraitValue, colour = crd$ID,
      xlab = "Resource Density", ylab = "Trait Value") +
  geom_point()

# minimum number of values needed for fitting is 5 so check all unique IDs
# have a minimum of 5 records
x <- c()
IDs_Count <- as.data.frame(table(crd$ID))
IDs <- as.numeric(levels(IDs_Count$Var1))[IDs_Count$Var1]
for (i in (1:length(IDs))) {
  if (IDs_Count[i,2] < 5) {
    x <- rbind(x, IDs[i])
  }
}
if (is.null(x)) {
  print("There are no IDs with fewer than 5 records so all IDs can be used for modelling")
} else {
  print("The following IDs contain fewer than 5 records so are not suitable for modelling") 
  x
}
# remove any IDs with fewer than 5 records
crd <- crd[ ! crd$ID %in% x, ]


#################### plot filtered IDs ###########################


# view all datasets to get a feel for the data
# open blank pdf page using a relative path
pdf(paste("../Results/Explore_Plots/IDs.pdf"),
    8, 4.5, onefile = TRUE) # save all plots to one pdf
for (i in (unique(crd$ID))) {
  p <- subset(crd, crd$ID == i) # subset and plot the data by ID
  print(qplot(x = p$ResDensity, y = p$N_TraitValue,
              xlab = "Resource Density", ylab = "Trait Value",
              main = paste("ID", i)) +
    geom_point())
}
dev.off()


###################### starting value estimates ####################


# calculate initial starting value estimates for parameters
for (i in (unique(crd$ID))) {
  # subset data by ID
  subs <- subset(crd, crd$ID == i)
  # subset further to find the values lower than mean to estimate slope
  sub_a <- subset(subs, subs$N_TraitValue < 1.5*(mean(subs$N_TraitValue)))
  find_a <- try(summary(lm(N_TraitValue ~ ResDensity, data = sub_a)))
  start_a <- find_a$coefficients[2] 
  # re-subset to find the values higher than the mean to estimate maximum
  sub_h <- subset(subs, subs$N_TraitValue > mean(subs$N_TraitValue))
  start_h <- max(sub_h$N_TraitValue)
  # add starting values to dataframe
  for (j in (which(crd$ID == i))) {
    crd$initial_a[j] <- start_a
    crd$initial_h[j] <- start_h
  }
}


###################### save subsetted dataframe #####################


# save subsetted data to new csv to be imported by python
write.csv(crd, "../Data/CRatMod.csv")

CRatMod <- read.csv("../Data/CRatMod.csv")


  