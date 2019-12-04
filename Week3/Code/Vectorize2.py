#!/usr/bin/env python3

"""
Contains two functions that run two different simulations of the stochastic 
(with Gaussian fluctuations) Ricker equation. One contains two for loops, stochrick,
the other, stochrickvect, has been vectorised. The times taken for the two models 
to run are compared at the end.
"""

__author__ = 'Lucy Goodyear (lucy.goodyear19@imperial.ac.uk)'
__version__ = '0.0.1'

# imports
import scipy as sc
import scipy.stats as scs
import time

# define stochastic (with Gaussian fluctuations) Ricker equation with two for loops

def stochrick(p0=sc.random.uniform(.5,1.5,size=1000),r=1.2,K=1,sigma=0.2,numyears=100):
    '''Runs a simulation of the stochastic Ricker equation, looping over
    each population and each year, adding the gaussian fluctuation to 
    each population separately.

    Parameters:
        p0 (array) : initial populaiton denisty
        r (float) : intrinsic growth rate
        K (float) : carrying capacity
        sigma (float) : gaussian fluctuation
        numyear (integer) : number of years to loop over

    Returns:

        N (array) : population density after numyears have passed

    '''
  
    # initialise matrix of zeros
    N = sc.zeros((numyears, len(p0)))
    # set initial population density
    N[1,] = p0
  
    for pop in range(1, len(p0)): #loop through the populations

        for yr in range(2, numyears): #for each pop, loop through the years

            N[yr][pop] = N[yr-1][pop] * sc.exp(r*(1-(N[yr-1][pop]/K))) + sc.random.normal(0, sigma, 1)
    
    return N

# Now write another function called stochrickvect that vectorizes the above 
# to the extent possible, with improved performance: 

def stochrickvect(p0=sc.random.uniform(.5,1.5,size=1000),r=1.2,K=1,sigma=0.2,numyears=100):
    '''Runs a simulation of the stochastic Ricker equation, looping over
    each year and adding the gaussian fluctuation (as an array) to all populations at once
    each year.

    Parameters:
        p0 (array) : initial populaiton denisty
        r (float) : intrinsic growth rate
        K (float) : carrying capacity
        sigma (float) : gaussian fluctuation
        numyear (integer) : number of years to loop over

    Returns:

        N (array) : population density after numyears have passed

    '''

    # initialise matrix of zeros
    N = sc.zeros((numyears,len(p0)))
    # set initial population density
    N[1] = p0
  
    for yr in range(2, numyears): # loops through populations by year
      
        N[yr,] = N[yr-1,] * sc.exp(r * (1 - (N[yr-1,] / K))) + sc.random.normal(0, sigma, size = len(p0))
    
    return N 

# compare times for calling the vectorised and non-vectorised functions
start = time.time()
stochrick(p0=sc.random.uniform(.5,1.5,size=1000),r=1.2,K=1,sigma=0.2,numyears=100)
end = time.time()
print("For Stochastic Ricker using 2 for loops, the time taken is:")
print(end - start)

start = time.time()
stochrickvect(p0=sc.random.uniform(.5,1.5,size=1000),r=1.2,K=1,sigma=0.2,numyears=100)
end = time.time()
print("For Stochastic Ricker adding all stochastic terms at once, the time taken is:")
print(end - start)

