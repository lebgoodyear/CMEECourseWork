#!/usr/bin/env python3

""" Uses a discrete time for loop to solve the Lotka-Volterra model.

Contains one function that calculates the growth rate of resource and consumer
populations at a given time step. Initial parameters are then set and the scipy
integrate subpackage is used to solve the Lotka-Volterra system. The results are 
plotted in two different graphs, showing the change of the two population densities
over time and also the change in the two population densities with respect to each other.

"""

__author__ = 'Lucy Goodyear (lucy.goodyear19@imperial.ac.uk)'
__version__ = '0.0.1'

## Explanation of the Lotka-Volterra model:

## Lotka-Volterra model is for modelling a predator-prey system in 2-D space
## dR/dt = rR(1-R/K) - aCR
## dC/dt = -zC + eaCR
## where C and R are consumer (predator) and resource (prey) population abundance
# (measured in number per area), 
## r is the intrinsic (per capita) growth rate of the resource population (per time),
## a is the per capita "search rate" for the resource (area per time) multipled by 
# its attack success probability, which determines the encounter and consumption
# rate of the consumer on the resource
## z is the mortality rate (per time)
## e is the consumer's efficiency (a fraction) in converting resource to consumer biomass
## K is the carrying capacity

# imports
import scipy as sc
import scipy.integrate as integrate
import matplotlib.pylab as p
import sys

# define a function that returns the growth rate of consumer and resource populations
# at discrete time intervals
def RC_d(R0, C0):
    """
    Calculates the growth rate of consumer and resource populations
    at a discrete time intervals, using the Lotka-Volterra model.

    Parameters:
        R0 (float) : the population density of resource population at time t
        C0 (float) : the population density of consumer population at time t

    Returns:
        RC (array) : an array containing the growth rate of the populations

    """
    died = False
    RC = sc.zeros((len(t),),dtype ='f,f')
    RC[0] = R0, C0
    for i in range(0, len(t)-1):
        RC[i+1][0] = RC[i][0] * (1 + (r * (1 - RC[i][0] / K)) - a * RC[i][1])
        RC[i+1][1] = RC[i][1] * (1 - z + e * a * RC[i][0])
        if RC[i+1][0] > K:
            RC[i+1][0] = K
        elif RC[i+1][0] < 0.:
            RC[i+1][0] = 0.
            died = True
        if RC[i+1][1] > K:
            RC[i+1][1] = K
        elif RC[i+1][1] < 0.:
            RC[i+1][1] = 0.
            died = True
        if died:
            print("Extinction occured")
            break

    return RC

# set intial parameters
K = 30
# if user arguments are given, use those, otherwise use the default arguments
if len(sys.argv) == 5:
    r = float(sys.argv[1])
    a = float(sys.argv[2])
    z = float(sys.argv[3])
    e = float(sys.argv[4])
else:
    print("No arguments provided, defaults used")
    r = 1.
    a = 0.1
    z = 1.5
    e = 0.75

# set the initial abundances for the two populations
R0 = 10
C0 = 5

# define the time vector (units are arbitrary here)
t = sc.linspace(0, 15, 1000)

# run the function on our initial population densities and
# convert output to a list
RC = list(RC_d(R0, C0))
R = [x[0] for x in RC] # extract resource population densities
C = [x[1] for x in RC] # extract consumer population densities

# visualise the results by plotting them using matplotlib
# first open an empty figure
f1 = p.figure()
# add everything (data, axes etc.) to the figure
p.plot(t, R, 'g-', label = 'Resource density') 
p.plot(t, C, 'b-', label = 'Consumer density')
p.legend(loc = 'best')
p.xlabel('Time (arbitrary units)')
p.xlim(left = 0, right = 2)
p.ylabel('Population density')
p.suptitle('Consumer-Resource population dynamics')
p.title("r = %.2f a = %.2f z = %.2f e = %.2f" %(r, a, z, e), fontsize = 10)
p.show()
# save figure as pdf
f1.savefig('../Results/LV3_model1.pdf') 

# visualise the data in terms of resource and consumer density with respect to each other
f2 = p.figure()
# add everything (data, axes etc.) to the figure
p.plot(R, C, 'r-') 
p.xlabel('Resource density')
p.ylabel('Consumer density')
p.suptitle('Consumer-Resource population dynamics')
p.title("r = %.2f a = %.2f z = %.2f e = %.2f" %(r, a, z, e), fontsize = 10)
p.grid()
p.show()
# save figure as pdf
f2.savefig('../Results/LV3_model2.pdf') 



