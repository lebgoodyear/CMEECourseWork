###################### Stochastic (with gaussian fluctuations)######################
################################### Ricker Eqn. ####################################

import scipy as sc
import scipy.stats as scs
import timeit

def stochrick(p0=sc.random.uniform(.5,1.5,size=1000),r=1.2,K=1,sigma=0.2,numyears=100):
  # runs a simulation of the stochastic Ricker eqn
  
  #initialize
    N = sc.zeros((numyears, len(p0)))
    N[1,] = p0
  
    for pop in range(len(p0)): 
        for yr in range(2, numyears): #for each pop, loop through the years
            N[yr,pop] = N[yr-1,pop] * sc.exp(r*(1-N[yr-1,pop]/K)+sc.random.normal(0, sigma, size = len(p0))
    return(N)

# Now write another function called stochrickvect that vectorizes the above 
# to the extent possible, with improved performance: 

def stochrickvect(p0=sc.random.uniform(.5,1.5,size=1000),r=1.2,K=1,sigma=0.2,numyears=100):
    
    N = sc.zeros((numyears,len(p0)))
    N[1] = p0
  
    for yr in range(2, numyears): # loops through populations by year
      
        N[yr,] = N[yr-1,] * sc.exp(r * (1 - N[yr-1,] / K) + sc.random.normal(0, sigma, size = len(p0))
    return(N)

# compare times for the vectorised and non-vectorised functions
start = time.time()
(M)
end = time.time()
print("Using loops, the time taken is:")
print(end - start)

start = time.time()
sc.sum(M)
end = time.time()
print("Using in-built scipy sum function, the time taken is:")
print(end - start)

