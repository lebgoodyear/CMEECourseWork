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

nofitIDs = [] # create empty list for any IDs it was not possible to fit to
# define generalised functional response equation
# where a is equivalent to the gradient of the initial part of the slope
# h is handling time, which is the maximum y-value
def GFR(GFR_params, x, y):
    a = GFR_params["a"]
    q = GFR_params["q"]
    h = GFR_params["h"]

    model = (a * (x ** (q + 1))) / (1 + h * a * (x ** (q + 1)))

    return y - model

def sample_starts(df, maxiters):
    # initialise empty data frame to store possible starting values
    test = pandas.DataFrame(columns = ["Trial_a", "Trial_q", "Trial_h", "AIC"])
    # find starting values for parameters from initial estimates
    a = numpy.random.normal(df['initial_a'][1], 1, maxiters)
    h = numpy.random.normal(df['initial_h'][1], 1, maxiters)
    # sample initial input parameters from crd dataframe (calculated in R) by for loop to find most appropriate starting values (lowest AIC)
    for k in range(0, maxiters):
        GFR_params = lmfit.Parameters()
        GFR_params.add("a", value = a[k])
        GFR_params.add("q", value = 0, min=-2, max = 2)
        GFR_params.add("h", value = h[k])
        # try to fit the general functional response model to every starting value in the sample of 100, catching any that fail and saving the IDs to a list
        try:
            GFR_fit = lmfit.minimize(GFR, GFR_params, args = (df["ResDensity"], df["N_TraitValue"]))
            #y_values = crd_sub["N_TraitValue"] + GFR_fit.residual
            #import ipdb; ipdb.set_trace()
        except ValueError:
            print("Errored at ID", i, " - no Holling fit possible")
            nofitIDs = notfitIDs.append(i)
            pass # we can pass safely after failing IDs have been caught
        test = test.append({"Trial_a" : GFR_fit.params["a"].value, "Trial_q" : GFR_fit.params["q"].value, "Trial_h" : GFR_fit.params["h"].value, "AIC": GFR_fit.aic}, ignore_index = True)
    test = test[test.AIC == min(test.AIC)] # choose lowest AIC as starting values for model
    return test

# create a list of IDs
IDs = crd['ID']

# insert new columns into the dataframe for the final estimate of each parameter
crd.insert(5, "Fit_a", "")
crd.insert(6, "Fit_q", "")
crd.insert(7, "Fit_h", "")
crd.insert(8, "GFR_AIC", "")

# create for loop to fit Holling for all data subsets
fits = pandas.DataFrame() # initilise empty dataframe to save all data for each ID
for i in numpy.unique(IDs):
    maxiters = 3
    crd_sub = crd[crd.ID == i] # subset by each ID
    crd_sub = crd_sub.reset_index(drop=True) # reset index so can easily loop over just these elements
    # run function to find best starting values
    starts = sample_starts(crd_sub, maxiters)
    for j in range(len(crd_sub)):
    # extract final fit parameters for plotting in R
        crd_sub.iloc[j,5] = starts.iloc[0,0]
        crd_sub.iloc[j,6] = starts.iloc[0,1]
        crd_sub.iloc[j,7] = starts.iloc[0,2]
        crd_sub.iloc[j,8] = starts.iloc[0,3]
        fits = fits.append(crd_sub.iloc[j]) # add ID i row to data frame
    fits = fits.reindex(crd_sub.columns, axis=1) # put the columns back to the original order
        
fits = fits.reset_index(drop=True)
fits['ID'] = fits['ID'].astype(numpy.int64)
print("Errors occurred at these IDs:", nofitIDs)

#GFR_fit.params.pretty_print()
#print(lmfit.fit_report(h_fit))

# save final dataframe with all initial data and fits to a csv for R to import for plotting
fits.to_csv("../Data/crd_fits_GFR.csv")    



