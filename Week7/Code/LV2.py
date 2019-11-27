#!/usr/bin/env python3

""" Uses numerical integration to solve the Lotka-Volterra model, including carrying 
capacity K, and allows user inputs for certain parameters.

Contains one function that calculates the growth rate of resource and consumer
populations at a given time step and one main function that contains the rest of the script. 
Within the main programme, this function is redefined as a partial to allow the fixed parameters 
to be passed to the function. Initial parameters are inputted by user, otherwise defaults are used, 
and the scipy integrate subpackage is used to solve the Lotka-Volterra system. The results are 
plotted in two different graphs, showing the change of the two population densities over time and 
also the change in the two population densities with respect to each other.

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
import functools

# define a function that returns the growth rate of consumer and resource populations
# at any given time step

def dCR_dt(RC0, t, r, a, z, e, K):
    """
    Calculates the growth rate of consumer and resource populations
    at a given time, using the Lotka-Volterra model.

    Parameters:
        RC0 (array) : the densities of both populations at time t
        t (int) : the given time (units are arbitrary)
        r (float) : intrinsic (per capita) growth rate of the resource population (per time)
        a (float) : per capita "search rate" for the resource (area per time) multipled by 
                    its attack success probability
        z (float) : mortality rate (per time)
        e (float) : consumer's efficiency (a fraction) in converting resource to consumer biomass
        K (int) : carrying capacity

    Returns:
        sc.array([dRdt, dCdt]) : an array containing the growth rate of the populations

    """
    R = RC0[0]
    C = RC0[1]
    dRdt = r * R * (1 - R / K) - a * R * C
    dCdt = -z * C + e * a * R * C

    return sc.array([dRdt, dCdt])

type(dCR_dt)
# so we can see that dCR_dt has been stored as a function object

def main(r = 3.5, a = 0.2, z = 2.9, e = 0.9):
    '''
    Solves the Lotka-Voltera system, including carrying capacity, K, by numerical integration and plots 
    two different graphs, one showing the change of the two population densities over time and the other 
    showing the change in the two population densities with respect to each other. Both plots are saved 
    to the Results folder as pdfs.

    Parameters:
    Initial parameters are inputted by user, otherwise defaults are used.
    r (float) : intrinsic (per capita) growth rate of the resource population (per time)
    a (float) : per capita "search rate" for the resource (area per time) multipled by 
                    its attack success probability
    z (float) : mortality rate (per time)
    e (float) : consumer's efficiency (a fraction) in converting resource to consumer biomass
    '''
    # set intial parameters
    K = 50

    # define the time vector (units are arbitrary here)
    t = sc.linspace(0, 15, 1000)

    # set the initial abundances for the two populations
    R0 = 7
    C0 = 10
    # convert into an array
    RC0 = sc.array([R0, C0])

    # define a partial function to enable r, a, z, e, K to be passed to dCR_dt
    dCR_dt_partial = functools.partial(dCR_dt, r = r, a = a, z = z, e = e, K = K)

    # numerically integrate this system forward from the above starting conditions
    pops, infodict = integrate.odeint(dCR_dt_partial, RC0, t, full_output = True)
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
    p.title("r = %.2f,  a = %.2f,  z = %.2f,  e = %.2f" %(r, a, z, e), fontsize = 10)
    # save figure as pdf
    f1.savefig('../Results/LV2_plot1.pdf') 

    # visualise the data in terms of resource and consumer density with respect to each other
    f2 = p.figure()
    # add everything (data, axes etc.) to the figure
    p.plot(pops[:,0], pops[:,1], 'r-') 
    p.xlabel('Resource density')
    p.ylabel('Consumer density')
    p.suptitle('Consumer-Resource population dynamics')
    p.title("r = %.2f,  a = %.2f,  z = %.2f,  e = %.2f" %(r, a, z, e), fontsize = 10)
    p.grid()
    # save figure as pdf
    f2.savefig('../Results/LV2_plot2.pdf') 
    print("Stabilised prey population density: ", pops[-1, 0])
    print("Stabilised predator population density: ", pops[-1, 1])

if __name__ == "__main__":
    # if user arguments are given, use those, otherwise use the default arguments
    if len(sys.argv) == 5:
        r = float(sys.argv[1])
        a = float(sys.argv[2])
        z = float(sys.argv[3])
        e = float(sys.argv[4])
        main(r, a, z, e)
    else:
        print("Requires r, a, z, e arguments.\nThese were not provided so defaults used:\nr = 3.5, a = 0.2, z = 2.9, e = 0.9")
        main()



