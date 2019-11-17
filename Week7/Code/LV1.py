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
## dR/dt = rR - aCR
## dC/dt = -zC + eaCR
## where C and R are consumer (predator) and resource (prey) population abundance
# (measured in number per area), 
## r is the intrinsic (per capita) growth rate of the resource population (per time),
## a is the per capita "search rate" for the resource (area per time) multipled by 
# its attack success probability, which determines the encounter and consumption
# rate of the consumer on the resource
## z is the mortality rate (per time)
## e is the consumer's efficiency (a fraction) in converting resource to consumer biomass

# imports
import scipy as sc
import scipy.integrate as integrate
import matplotlib.pylab as p

# define a function that returns the growth rate of consumer and resource populations
# at any given time step

def dCR_dt(RC0, t = 0):
    """
    Calculates the growth rate of consumer and resource populations
    at a given time, using the Lotka-Volterra model.

    Parameters:
        RC0 (array) : the densities of both populations at time t
        t (int) : the given time (t = 0 is the default (optional))

    Returns:
        sc.array([dRdt, dCdt]) : an array containing the growth rate of the populations

    """
    R = RC0[0]
    C = RC0[1]
    dRdt = r * R - a * R * C
    dCdt = -z * C + e * a * R * C

    return sc.array([dRdt, dCdt])

type(dCR_dt)
# so we can see that dCR_dt has been stored as a function object

# assign some parameter values
r = 1.
a = 0.1
z = 1.5
e = 0.75

# define the time vector (units are arbitrary here)
t = sc.linspace(0, 15, 1000)

# set the initial abundances for the two populations
R0 = 10
C0 = 5
# convert into an array
RC0 = sc.array([R0, C0])

def main():

    # numerically integrate this system forward from the above starting conditions
    pops, infodict = integrate.odeint(dCR_dt, RC0, t, full_output = True)
    # where pops contains the result (the population trajectories)
    # and infodict is a dictionary that contains information on how the integration went
    type(infodict)
    infodict.keys()
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
    p.title('Consumer-Resource population dynamics')
    # save figure as pdf
    f1.savefig('../Results/LV1_plot1.pdf') 

    # visualise the data in terms of resource and consumer density with respect to each other
    f2 = p.figure()
    # add everything (data, axes etc.) to the figure
    p.plot(pops[:,0], pops[:,1], 'r-') 
    p.xlabel('Resource density')
    p.ylabel('Consumer density')
    p.title('Consumer-Resource population dynamics')
    p.grid()
    # save figure as pdf
    f2.savefig('../Results/LV1_plot2.pdf') 

if __name__ == "__main__":
    main()