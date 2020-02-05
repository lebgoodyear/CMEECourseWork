#!/usr/bin/env python3

""" 
Fits NLLS model to consumer resource data.

"""

__author__ = 'Lucy Goodyear (lucy.goodyear19@imperial.ac.uk)'
__version__ = '0.0.1'

# imports
import lmfit
import pandas
import numpy
import Fit_Functions

# load the data
crd = pandas.read_csv("../Data/CRatMod.csv", index_col = 0)

global nofitIDs
nofitIDs = []
# create empty list for any IDs it was not possible to fit to

# create a list of IDs
IDs = [39836, 39835] #crd['ID']

# insert new columns into the dataframe for the final estimate of each parameter
crd.insert(5, "Fit_a", "")
crd.insert(6, "Fit_q", "")
crd.insert(7, "Fit_h", "")
crd.insert(8, "GFR_RSS", "")
crd.insert(9, "GFR_AIC", "")
crd.insert(10, "GFR_BIC", "")
crd.insert(11, "Poly1", "")
crd.insert(12, "Poly2", "")
crd.insert(13, "Poly3", "")
crd.insert(14, "Poly4", "")
crd.insert(15, "Poly_RSS", "")
crd.insert(16, "Poly_AIC", "")
crd.insert(17, "Poly_BIC", "")

# create for loop to fit Holling for all data subsets
fits = pandas.DataFrame() # initilise empty dataframe to save fitting data for each record
for i in numpy.unique(IDs):
    maxiters = 3
    crd_sub = crd[crd.ID == i] # subset by each ID
    crd_sub = crd_sub.reset_index(drop=True) # reset index so can easily loop over just these elements
    # run function to find best starting values and keep the fit with the lowest AIC
    GFRfit = sample_starts(crd_sub, maxiters)
    PolynomialFit = poly_fit(crd_sub)
    GFR_RSS = numpy.sum(GFRfit.iloc[0,5] ** 2)
    PolyRSS = PolynomialFit[1][0]
    PolyAIC = len(crd_sub) + 2 + len(crd_sub) * numpy.log((2 * numpy.pi) / len(crd_sub)) + len(crd_sub) * numpy.log(PolyRSS) + 2 * (len(crd_sub) - len(PolynomialFit[0]))
    PolyBIC = len(crd_sub) + 2 + len(crd_sub) * numpy.log((2 * numpy.pi) / len(crd_sub)) + len(crd_sub) * numpy.log(PolyRSS) + numpy.log(len(crd_sub)) * (len(crd_sub) - len(PolynomialFit[0]) + 1)
    # extract final fit parameters for plotting in R
    crd_sub.drop(['ResDensity', 'N_TraitValue', 'initial_a', 'initial_h'], axis = 1) # remove all rows that no longer needed
    crd_sub.iloc[0,5] = GFRfit.iloc[0,0] # final start value for parameter a
    crd_sub.iloc[0,6] = GFRfit.iloc[0,1] # final start value for parameter q
    crd_sub.iloc[0,7] = GFRfit.iloc[0,2] # final start value for parameter h
    crd_sub.iloc[0,8] = GFR_RSS
    crd_sub.iloc[0,9] = GFRfit.iloc[0,3] # AIC
    crd_sub.iloc[0,10] = GFRfit.iloc[0,4] # ????? BIC
    crd_sub.iloc[0,11] = PolynomialFit[0][0]
    crd_sub.iloc[0,12] = PolynomialFit[0][1]
    crd_sub.iloc[0,13] = PolynomialFit[0][2]
    crd_sub.iloc[0,14] = PolynomialFit[0][3]
    crd_sub.iloc[0,15] = PolyRSS
    crd_sub.iloc[0,16] = PolyAIC
    crd_sub.iloc[0,17] = PolyBIC

    fits = fits.append(crd_sub.iloc[0]) # add the first row of each ID to data frame
    fits = fits.reindex(crd_sub.columns, axis=1) # put the columns back to the original order
        
fits = fits.reset_index(drop=True)
fits['ID'] = fits['ID'].astype(numpy.int64)
print("Errors occurred at these IDs:", nofitIDs)

#GFR_fit.params.pretty_print()
#print(lmfit.fit_report(GFR_fit))

# save final dataframe with all initial data and fits to a csv for R to import for plotting
fits.to_csv("../Data/CRfits")    



