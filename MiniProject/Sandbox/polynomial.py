#!/usr/bin/env python3

""" 
Fits NLLS model to data

"""

__author__ = 'Lucy Goodyear (lucy.goodyear19@imperial.ac.uk)'
__version__ = '0.0.1'

# imports
import lmfit
import pandas
import numpy

# load the data
crd = pandas.read_csv("../Data/CRatMod.csv", index_col = 0)

IDs = [39835, 39836] #crd['ID']

# insert new columns into the dataframe for the final estimate of each parameter
crd.insert(3, "Poly1", "")
crd.insert(4, "Poly2", "")
crd.insert(5, "Poly3", "")
crd.insert(6, "Poly4", "")

# create for loop to fit Holling for all data subsets
fits = pandas.DataFrame()
for i in IDs:
    crd_sub = crd[crd.ID == i] # subset by each ID
    crd_sub = crd_sub.reset_index(drop=True) # reset index so can easily loop over just these elements
    v = crd_sub["log_ResDensity"].tolist()
    h_fit = numpy.polyfit(crd_sub["log_ResDensity"], crd_sub["log_N_TraitValue"], 3)
    for j in range(len(crd_sub)):
        crd_sub.iloc[j,3] = h_fit[0], 
        crd_sub.iloc[j,4] = h_fit[1],
        crd_sub.iloc[j,5] = h_fit[2],
        crd_sub.iloc[j,6] = h_fit[3],
    fits = fits.append(crd_sub.iloc[j])
fits = fits.reindex(crd_sub.columns, axis=1)
fits = fits.reset_index(drop=True)
fits['ID'] = fits['ID'].astype(numpy.int64)

# test plot
import matplotlib.pylab as p
#p.ylim((0, 0.8))
plotpoly = numpy.poly1d(h_fit)
p.plot(crd_sub["log_ResDensity"], crd_sub["log_N_TraitValue"], "k+")
p.plot(crd_sub["log_ResDensity"], plotpoly(crd_sub["log_ResDensity"]), 'r')
p.show()
