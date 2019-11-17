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