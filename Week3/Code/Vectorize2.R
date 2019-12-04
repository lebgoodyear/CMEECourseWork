###################### Stochastic (with gaussian fluctuations)######################
################################### Ricker Eqn. ####################################

# Contains two functions that run two different simulations of the stochastic 
# (with Gaussian fluctuations) Ricker equation. One contains two for loops, stochrick,
# the other, stochrickvect, has been vectorised. The times taken for the two models 
# to run are compared at the end.

# Author: Lucy Goodyear (lucy.goodyear19@imperial.ac.uk)
# Version: 0.0.1

# clear workspace
rm(list=ls())

# define stochastic (with Gaussian fluctuations) Ricker equation with two for loops
stochrick<-function(p0=runif(1000,.5,1.5),r=1.2,K=1,sigma=0.2,numyears=100) {
    # Runs a simulation of the stochastic Ricker equation, looping over
    # each population and each year, adding the gaussian fluctuation to 
    # each population separately.
  
    # initialise matrix of zeros
    N<-matrix(NA,numyears,length(p0))
    # set initial population density
    N[1,]<-p0
  
    for (pop in 1:length(p0)) { #loop through the populations
      
        for (yr in 2:numyears) { #for each pop, loop through the years
          
            N[yr,pop]<-N[yr-1,pop]*exp(r*(1-N[yr-1,pop]/K)+rnorm(1,0,sigma))
        }
    }
 return(N)
}

# Now write another function called stochrickvect that vectorizes the above 
# to the extent possible, with improved performance: 

stochrickvect <- function(p0=runif(1000,.5,1.5),r=1.2,K=1,sigma=0.2,numyears=100) {
    # Runs a simulation of the stochastic Ricker equation, looping over
    # each year and adding the gaussian fluctuation to all populations at once
    # each year.
  
    # initialise matrix of zeros
    N<-matrix(NA,numyears,length(p0))
    # set initial population density
    N[1,]<-p0
  
    for (yr in 2:numyears) { # loops through populations by year
      
        N[yr,] <- N[yr-1,] * exp(r * (1 - N[yr-1,] / K) + rnorm(length(p0), 0, sigma))
    }
    return(N)
}

# compare times for calling the vectorised and non-vectorised functions
print(paste("Stochastic Ricker without vectorisation takes:", system.time(res1<-stochrick())[3]))

print(paste("Vectorized Stochastic Ricker takes:", system.time(res2<-stochrickvect())[3]))

