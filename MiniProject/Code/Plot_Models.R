################# PLotting Data and Fits ####################

# load packages
library(ggplot2)

# define Holling function to plotting
GFR <- function (a, q, h, x) {
  return (a * (x ^ (q + 1)) / (1 + h * a * (x) ^ (q + 1)))
}

fits <- read.csv("../Data/crd_fits")
fits <- subset(fits, !is.na(fits$Poly1))
# check which datasets had no model fitted
#nofits <- subset(fits, is.na(fits$Poly1))
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
pdf(paste("../Results/ID_Modelled_Plots.pdf"),
    8, 4.5, onefile = TRUE) # save all plots to one pdf
for (i in IDs) {
  p <- subset(fits, fits$ID == i) # subset and plot the data by ID
  x <- seq(min(p$ResDensity), max(p$ResDensity), (max(p$ResDensity) - min(p$ResDensity))/1000) 
  yPoly <- p$Poly1[1] + p$Poly2[1]*x + 
    p$Poly3[1]*x^2 + (p$Poly4[1])*x^3
  yGFR <- GFR(p$Fit_a[1], p$Fit_q[1], p$Fit_h[1], x)
  data_to_plot <- data.frame(x, ypoly, yGFR)
  print(ggplot(aes(x = ResDensity,
                   y = N_TraitValue),
               data = p) +
          xlab("Resource Density") + 
          ylab("Trait Value") +
          ggtitle(paste("ID", i)) +
          geom_point() +
          geom_line(data = data_to_plot, 
                    mapping = aes(x, yPoly),
                    colour = "r") +
          geom_line(data = data_to_plot,
                    mapping = aes(x, yGFR),
                    colour = "blue"))
}
dev.off()

# compare AICs to work out which model is best for each ID dataset
for (i in IDs) {
  subs <- subset(fits, fits$ID == i)
  deltaAIC <- subs$Poly_AIC - subs$GFR_AIC
  if (deltaAIC < 2) && (deltaBIC < 2) && (deltaRSS < 0) {
    cat("Polynomial Model is a better fit")
  }
  if (deltaAIC > 2) {
    cat("Generalised Functional Model is a better fit")
  }
}


