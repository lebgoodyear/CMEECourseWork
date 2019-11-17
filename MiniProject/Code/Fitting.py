#!/usr/bin/env python3

""" Fits NLLS model to data

"""

__author__ = 'Lucy Goodyear (lucy.goodyear19@imperial.ac.uk)'
__version__ = '0.0.1'

# imports

# load the data
crd = open("../Data/CRatMod.csv")

def polynomial(x, a, b, c, d)
    return a + b * x + c * x ** 2 + d * x ** 3

QuadFit = lmfit(TraitValue ~ polynomial(ResDensity, a, b, c, d), 
                data = crd, 
                start = list(a = .1, b = .1, c = .1, d = .1))

