######### inserts a breakpoint into the code and enters browser mode #########

# Author: Lucy Goodyear (lucy.goodyear19@imperial.ac.uk)
# Version: 0.0.1

# clear workspace
rm(list=ls())

Exponential <- function(N0 = 1, r = 1, generations = 10) {
    # runs a simulation of exponential growth
    # returns a vector of length generations

    N <- rep(NA, generations) # creates a vector of NA

    N[1] <- N0
    for (t in 2:generations) {
        N[t] <- N[t-1] * exp(r)
        browser()
    }
    return(N)
}

# plots the exponential growth
plot(Exponential(), type="1", main="Exponential growth")
