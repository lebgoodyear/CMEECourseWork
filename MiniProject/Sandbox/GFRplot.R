################# PLotting Data and Fits ####################

# load packages
library(ggplot2)

# define Holling function to plotting
GFR <- function (a, q, h, x) {
  return (a * (x ^ (q + 1)) / (1 + h * a * (x) ^ (q + 1)))
}

fits <- read.csv("../Data/crd_fits_GFR.csv")
fits <- subset(fits, !is.na(fits$Fit_a))
# check which datasets had no polynomial fitted
# nofits <- subset(fits, is.na(fits$Fit_a))
#for (i in dropd_IDs) {
#dropd_IDs <- c(unique(nofits$ID))
#  p <- subset(nofits, nofits$ID == i) # subset and plot the data by ID
#  print(qplot(x = p$log_ResDensity, y = p$log_N_TraitValue,
#              xlab = "log of Resource Density", ylab = "Log of Trait Value",
#              main = paste("ID", i)) +
#        geom_point())
#}
# viewing these datasets, it is unsurprising that a polynomial could not be fitted

IDs <- c(unique(fits$ID))
pdf(paste("../Results/Explore_Plots/GFRIDs.pdf"),
    8, 4.5, onefile = TRUE) # save all plots to one pdf
for (i in IDs) {
  p <- subset(fits, fits$ID == i) # subset and plot the data by ID
  x <- seq(min(p$ResDensity), max(p$ResDensity), (max(p$ResDensity) - min(p$ResDensity))/1000) 
  y <- GFR(p$Fit_a[1], p$Fit_q[1], p$Fit_h[1], x)
  data_to_plot <- data.frame(x, y)
  print(ggplot(aes(x = ResDensity,
                   y = N_TraitValue),
                   data = p) +
          xlab("Resource Density") + 
          ylab("Trait Value") +
          ggtitle(paste("ID", i)) +
          geom_point() +
          geom_line(data = data_to_plot, 
                    mapping = aes(x, y)))
}
dev.off()

