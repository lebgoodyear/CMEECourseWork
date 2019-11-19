################# PLotting Data and Fits ####################

# load packages
library(ggplot2)

# define Holling function to plotting
Holling <- function (a, q, h, x) {
  return (a * (x ^ (q + 1)) / (1 + h * a * (x) ^ (q + 1)))
}

e <- read.csv("../Data/crd_w_estimates")

qplot(x = e$ResDensity, y = e$N_TraitValue,
      xlab = "Resource Density", ylab = "Trait Value") +
  geom_point()
qplot(x = e$ResDensity, y = Holling(4.314e-10, 1.3, -5.376e-10, e$ResDensity),
xlab = "Resource Density", ylab = "Trait Value", add = T)