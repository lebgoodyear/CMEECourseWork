#!/usr/bin/env python3

""" Uses numerical integration to solve the Lotka-Volterra model.

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
# at any given time step

def dCR_dt(pops, t = 0):
    """
    Calculates the growth rate of consumer and resource populations
    at a given time, using the Lotka-Volterra model.

    Parameters:
        pops (array) : the numbers of both populations at time t
        t (int) : the given time (t = 0 is the default (optional))

    Returns:
        sc.array([dRdt, dCdt]) : an array containing the growth rate of the populations

    """
    R = pops[0]
    C = pops[1]
    dRdt = r * R * (1 - R / K) - a * R * C
    dCdt = -z * C + e * a * R * C

    return sc.array([dRdt, dCdt])

type(dCR_dt)
# so we can see that dCR_dt has been stored as a function object

# set intial parameters
K = 50
# if user arguments are given, use those, otherwise use the default arguments
if len(sys.argv) == 5:
    r = float(sys.argv[1])
    a = float(sys.argv[2])
    z = float(sys.argv[3])
    e = float(sys.argv[4])
else:
    print("No arguments provided, defaults used")
    r = 3.5
    a = 0.2
    z = 2.9
    e = 0.9

# define the time vector (units are arbitrary here)
t = sc.linspace(0, 15, 1000)

# set the initial abundances for the two populations
R0 = 7
C0 = 10
# convert into an array
RC0 = sc.array([R0, C0])

# numerically integrate this system forward from the above starting conditions
pops, infodict = integrate.odeint(dCR_dt, RC0, t, full_output = True)
# where pops contains the result (the population trajectories)
# and infodict is a dictionary that contains information on how the integration went

# check whether integration was successful
infodict['message']

# visualise the results by plotting them using matplotlib
# first open an empty figure
f1 = p.figure()
# add everything (data, axes etc.) to the figure
p.plot(t, pops[:,0], 'g-', label = 'Resource density') 
p.plot(t, pops[:,1], 'b-', label = 'Consumer density')
p.legend(loc = 'best')
p.xlabel('Time')
p.ylabel('Population density')
p.suptitle('Consumer-Resource population dynamics')
p.title("r = %.2f a = %.2f z = %.2f e = %.2f" %(r, a, z, e), fontsize = 10)
p.show()
# save figure as pdf
f1.savefig('../Results/LV2_model1.pdf') 

# visualise the data in terms of resource and consumer density with respect to each other
f2 = p.figure()
# add everything (data, axes etc.) to the figure
p.plot(pops[:,0], pops[:,1], 'r-') 
p.xlabel('Resource density')
p.ylabel('Consumer density')
p.suptitle('Consumer-Resource population dynamics')
p.title("r = %.2f a = %.2f z = %.2f e = %.2f" %(r, a, z, e), fontsize = 10)
p.grid()
p.show()
# save figure as pdf
f2.savefig('../Results/LV2_model2.pdf') 
print("Stabilised prey population density: ", pops[-1, 0])
print("Stabilised predator population density: ", pops[-1, 1])



