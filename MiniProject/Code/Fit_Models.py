#!/usr/bin/env python3

"""
Loads consumer-resource functional response data and fits both a polynomial and the
generalied functional response model to each ID. The script has been optimised 
using the mulitprocessing module from the standard python library. The best fit parameters
and statistics for both the polynomial and generalised functional response best fits are then
stored as a dataframe and saved as a csv file to be imported by the next script.

"""

__author__ = 'Lucy Goodyear (lucy.goodyear19@imperial.ac.uk)'
__version__ = '0.0.1'

# imports
import lmfit
import pandas
import numpy
import fit_functions as ff # import my functions for fitting
import multiprocessing # for parallelisation

# load the data
crd = pandas.read_csv("../Data/CRatMod.csv", index_col = 0) 

# create a list of unique IDs
unique_IDs = numpy.unique(crd['ID'])

# set number of iterations
maxiters = 6

# define fitting function to fit each ID seperately to allow parallelisation
def parallelisable_fitting(i):
    '''
    Takes an ID i and fits a generalised functional response model and a polynomial to the dataset
    corresponding to that ID. Imports functions from the fit_functions module for the fitting and adds the 
    parameters and best fit measurements to a newly created dataframe. A separate dataframe is created to
    store the results for each ID to enable parallelisation.

    Inputs:
    i (integer) : ID number for the dataset of a particular functional response

    Returns:
    fits (dataframe) : dataframe of one row containing the best fit parameters for both
                       polynomial and GFR fits
    '''

    # subset dataframe by each ID and explicitly work on a copy
    crd_sub = crd.loc[crd.ID == i].copy()
    crd_sub = crd_sub.reset_index(drop=True) # reset index so can easily loop over just these elements

    # initilise empty dataframe to save best fit parameters for ID i
    fits = pandas.DataFrame(columns=["ID", "Fit_a", "Fit_q", "Fit_h", "GFR_RSS", "GFR_AIC", "GFR_BIC",
                                     "Poly1", "Poly2", "Poly3", "Poly4", "Poly_RSS", "Poly_AIC", "Poly_BIC"])

    # set ID eaqul to i in dataframe
    fits.loc[0,"ID"] = i

    # run GFR_fit function to find best starting values for GFR and keep the fit with the lowest AIC
    GFRfit = ff.GFR_fit(crd_sub, maxiters)
    # note any IDs where a GFR model could not be fitted
    if GFRfit is None:
        print("Errored at ID", i, " - no Generalised Functional Response fit possible")
    else:
        # calculate residuals sums of squares for GFR fit
        GFRRSS = numpy.sum(GFRfit.iloc[0,3] ** 2)
        # add parameters and fit measures to subsetted dataframe
        fits.loc[0,"Fit_a"] = GFRfit.iloc[0,0] # final start value for parameter a
        fits.loc[0,"Fit_q"] = GFRfit.iloc[0,1] # final start value for parameter q
        fits.loc[0,"Fit_h"] = GFRfit.iloc[0,2] # final start value for parameter h
        fits.loc[0,"GFR_RSS"] = GFRRSS
        fits.loc[0,"GFR_AIC"] = GFRfit.iloc[0,4] # AIC
        fits.loc[0,"GFR_BIC"] = GFRfit.iloc[0,5] # BIC

    # run polynomial function to find best fitting polynomial
    PolynomialFit = ff.poly_fit(crd_sub["ResDensity"], crd_sub["N_TraitValue"])
    # note any IDs where a polynomial could not be fitted
    if PolynomialFit is None:
        print("Errored at ID", i, " - no polynomial fit possible")
    else:
        # calulcate residuals sums of squares for both fits
        PolyRSS = PolynomialFit[1][0]
        # calculate AIC and BIC for polynomial fits
        PolyAIC = len(crd_sub) + 2 + len(crd_sub) * numpy.log((2 * numpy.pi) / len(crd_sub)) + len(crd_sub) * numpy.log(PolyRSS) + 2 * (len(crd_sub) - len(PolynomialFit[0]))
        PolyBIC = len(crd_sub) + 2 + len(crd_sub) * numpy.log((2 * numpy.pi) / len(crd_sub)) + len(crd_sub) * numpy.log(PolyRSS) + numpy.log(len(crd_sub)) * (len(crd_sub) - len(PolynomialFit[0]) + 1)
        # extract final fit parameters for plotting in R
        fits.loc[0,"Poly1"] = PolynomialFit[0][0]
        fits.loc[0,"Poly2"] = PolynomialFit[0][1]
        fits.loc[0,"Poly3"] = PolynomialFit[0][2]
        fits.loc[0,"Poly4"] = PolynomialFit[0][3]
        fits.loc[0,"Poly_RSS"] = PolyRSS[0]
        fits.loc[0,"Poly_AIC"] = PolyAIC[0]
        fits.loc[0,"Poly_BIC"] = PolyBIC[0]

    return fits


# set number of workers for parallelisation
pool = multiprocessing.Pool(processes=multiprocessing.cpu_count())

# create parellelised for-loop to fit both a GFR and a polynomial to all data subsets
parallel_fits = pool.map(parallelisable_fitting, unique_IDs)

# wait for all processes to finish before moving on
pool.close()
pool.join()

# initilise empty dataframe to save best fits for each ID
all_fits = pandas.DataFrame(columns=["ID", "Fit_a", "Fit_q", "Fit_h", "GFR_RSS", "GFR_AIC", "GFR_BIC",
                                     "Poly1", "Poly2", "Poly3", "Poly4", "Poly_RSS", "Poly_AIC", "Poly_BIC"])

# append each item in list from parallelisation to one final dataframe
for fit in parallel_fits:
    all_fits = all_fits.append(fit)

all_fits = all_fits.reset_index(drop=True) # reset index
all_fits['ID'] = all_fits['ID'].astype(numpy.int64) # set data type

# save final dataframe with all initial data and fits to a csv for R to import for plotting
all_fits.to_csv("../Data/CRfits.csv")

# end of script