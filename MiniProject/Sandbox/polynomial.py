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

IDs = crd['ID'] # create a list of IDs

# insert new columns into the dataframe for the final estimate of each parameter
crd.insert(3, "Poly1", "")
crd.insert(4, "Poly2", "")
crd.insert(5, "Poly3", "")
crd.insert(6, "Poly4", "")
crd.insert(7, "PolyAIC", "")

# create for loop to fit a polynomial to all data subsets
fits = pandas.DataFrame() # initialise empty dataframe
for i in numpy.unique(IDs):
    crd_sub = crd[crd.ID == i] # subset by each ID
    crd_sub = crd_sub.reset_index(drop=True) # reset index so can easily loop over just these elements
    try:
        # try to fit a polynomial to each dataset
        h_fit = numpy.polyfit(crd_sub["ResDensity"], crd_sub["N_TraitValue"], 3, full = True)
    except ValueError:
         print("Errored at ID", i, " - no polynomial fit possible")
         nofitIDs = notfitIDs.append(i)
         pass # we can pass safely after failing IDs have been caught
    for j in range(len(crd_sub)):
        # add all fit data to data frame subset
        crd_sub.iloc[j,3] = h_fit[0][0]
        crd_sub.iloc[j,4] = h_fit[0][1]
        crd_sub.iloc[j,5] = h_fit[0][2]
        crd_sub.iloc[j,6] = h_fit[0][3]
        crd_sub.iloc[j,7] = len(crd_sub) + 2 + len(crd_sub) * numpy.log((2 * numpy.pi) / len(crd_sub)) + len(crd_sub) * numpy.log(h_fit[2]) + 2 * (len(crd_sub)-len(h_fit[0]))  # where h_fit[2] is SSE
        fits = fits.append(crd_sub.iloc[j]) # add ID i row to data frame
    fits = fits.reindex(crd_sub.columns, axis=1) # put the columns back to the original order

fits = fits.reset_index(drop=True) # reset row index for complete data frame
fits['ID'] = fits['ID'].astype(numpy.int64) # change ID from float back to integer

# import fit data and original data to csv for R to read for plotting
fits.to_csv("../Data/crd_polyfits")  


