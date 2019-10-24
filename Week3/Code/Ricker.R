############### A simulation of the Ricker model ################

Ricker <- function(N0 = 1, r = 1, K = 10, generations = 50) {
  
  # runs a simulation of the Ricker model
  # returns a vector of length generations
  
  N <- rep(NA, generations) # creates a vector of NA
  
  N[1] <- N0
  for (t in 2: generations) {
      N[t] <- N[t-1] * exp(r * (1.0 - (N[t-1] / K)))
  }
  return (N)
}

# plot a line graph of the Ricker function with 10 generations
plot(Ricker(generations = 10), type = "l")
  