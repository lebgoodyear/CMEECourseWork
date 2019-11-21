################# PLotting Data and Fits ####################

# load packages
library(ggplot2)

# define Holling function to plotting
#Holling <- function (a, q, h, x) {
#  return (a * (x ^ (q + 1)) / (1 + h * a * (x) ^ (q + 1)))
#}

fits <- read.csv("../Data/crd_fits")
fits <- subset(fits, !is.na(fits$Poly1))
fits <- subset()

#IDs <- c(unique(fits$ID))
#pdf(paste("../Results/Explore_Plots/polyIDs.pdf"),
#    8, 4.5, onefile = TRUE) # save all plots to one pdf
#for (i in IDs) {
#  p <- subset(fits, fits$ID == i) # subset and plot the data by ID
  qplot(x = p$log_ResDensity, y = p$log_N_TraitValue,
              xlab = "log of Resource Density", ylab = "Log of Trait Value",
              main = paste("ID", i)) +
          geom_point() +
  
ggplot(aes(x = log_ResDensity,
           y = log_N_TraitValue),
           data = p) +
           xlab("log of Resource Density") + 
           ylab("Log of Trait Value") +
           ggtitle(paste("ID", i)) +
      geom_point() +
       geom_line(data = data_to_plot, 
                 mapping = aes(x, y))
    
x = seq(min(p$log_ResDensity), max(p$log_ResDensity), 0.1) 
y = p$Poly4[1] + p$Poly3[1]*x + 
    p$Poly2[1]*x^2 + (p$Poly1[1])*x^3

data_to_plot <- data.frame(x, y)
#}
dev.off()

qplot(x = fits$log_ResDensity, y = fits$log_N_TraitValue,
      xlab = "Resource Density", ylab = "Trait Value") +
  geom_point() +
  geom_line(fits$Estimated)