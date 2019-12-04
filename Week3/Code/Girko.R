#################### Plotting Girko's Circular Law #################################

# Plots Girko's circular law and saves figure as a pdf. It first builds a function
# that returns an ellipse then and produces a N by N matrix containing randomly 
# normally distributed values. The eigenvalues are calulcated for this matrix and 
# then plotted on an Argand diagram (real numbers on the x-axis and imaginary 
# numbers on the y-axis). Onto this Argand diagram, adds an ellipe with a radius of 
# square root of N to show how the points fit into the shape of this ellipse.

# Author: Lucy Goodyear (lucy.goodyear19@imperial.ac.uk)
# Version: 0.0.1

# clear workspace
rm(list=ls())

# imports
library(ggplot2)

build_ellipse <- function(hradius, vradius){ # function that returns an ellipse
    npoints = 250
    a <- seq(0, 2 * pi, length = npoints + 1)
    x <- hradius * cos(a)
    y <- vradius * sin(a)
    return(data.frame(x = x, y= y))
} 

N <- 250 # assign size of matrix

M <- matrix(rnorm(N * N), N, N) # build the matrix

eigvals <- eigen(M)$values # find the eigenvalues

eigDF <- data.frame("Real" = Re(eigvals), "Imaginary" = Im(eigvals)) # build a dataframe

my_radius <- sqrt(N) # The radius of the circle is sqrt(N)

ellDF <- build_ellipse(my_radius, my_radius) # dataframe to plot the ellipse

names(ellDF) <- c("Real", "Imaginary") # rename the columns

# plot the eigenvalues
p <- ggplot(eigDF, aes(x = Real, y = Imaginary))
p <- p +
  geom_point(shape = I(3)) +
  theme(legend.position = "none")

# now add the vertical and horizontal line
p <- p + geom_hline(aes(yintercept = 0))
p <- p + geom_vline(aes(xintercept = 0))

# finally, add the ellipse
p <- p + geom_polygon(data = ellDF, aes(x = Real, y = Imaginary, alpha = 1/20, fill = "red"))

# print plot to pdf
pdf("../Results/Girko.pdf")
p
dev.off()


