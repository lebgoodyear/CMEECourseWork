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

# define generalised functional response equation
# where a is equivalent to the gradient of the initial part of the slope
# h is handling time, which is the maximum y-value
def Holling(h_params, x, y):
    a = h_params["a"]
    q = h_params["q"]
    h = h_params["h"]

    model = (a * (x ** (q + 1))) / (1 + h * a * (x ** (q + 1)))

    return y - model

# test for one data subset
#crd_sub = crd[crd['ID'] == 39835]

#h_fit = lmfit.minimize(Holling, h_params, args = (crd_sub["ResDensity"], crd_sub["N_TraitValue"]), method = "leastsquares")
#y_values = crd_sub["N_TraitValue"] + h_fit.residual
#h_fit.params.pretty_print()
#print(lmfit.fit_report(h_fit))


# create a list of IDs
IDs = [39835, 39836] #crd['ID']

# insert new columns into the dataframe for the final estimate of each parameter
crd.insert(2, "log_FitTraitValue", "")
crd.insert(4, "Fit_a", "")
crd.insert(5, "Fit_q", "")
crd.insert(6, "Fit_h", "")

test = pandas.DataFrame(columns = ["Trial_a", "Trial_q", "Trial_h", "AIC"])
best = pandas.DataFrame(columns = ["Trial_a", "Trial_q", "Trial_h", "AIC"])
# create for loop to fit Holling for all data subsets
nofitIDs = [] # create empty list for any IDs it was not possible to fit to
fits = pandas.DataFrame() # initilise empty dataframe to save all data for each ID

    for i in IDs:
        crd_sub = crd[crd.ID == i] # subset by each ID
        crd_sub = crd_sub.reset_index(drop=True) # reset index so can easily loop over just these elements

# find starting values for parameters from initial estimates
def find_starts(x):
    test = pandas.DataFrame(columns = ["Trial_a", "Trial_q", "Trial_h", "AIC"])
    # sample initial input parameters from crd dataframe (calculated in R) by for loop to find most appropriate starting values (lowest AIC)
    for k in range(0,100):
        a = numpy.random.normal(x['initial_a'][0], 1, 1)
        h = numpy.random.normal(x['initial_h'][0], 1, 1)
        h_params = lmfit.Parameters()
        h_params.add("a", value = a[0])
        h_params.add("q", value = 0, min=-2, max = 2)
        h_params.add("h", value = h[0])
        # try to fit the Holling model to each dataset, catching any that fail and saving the IDs to a list
        # try to firt the model to every starting value in the sample of 100
        try:
            h_fit = lmfit.minimize(Holling, h_params, args = (x["log_ResDensity"], x["log_N_TraitValue"]))
            #y_values = crd_sub["log_N_TraitValue"] + h_fit.residual
        except ValueError:
        #    print("Errored at ID", i, " - no Holling fit possible")
        #    nofitIDs = notfitIDs.append(i)
            pass # we can pass safely after failing IDs have been caught
    
        # extract final fit parameters for plotting in R
        #for j in range(len(crd_sub)):
        test = test.append({"Trial_a" : h_fit.params["a"].value, "Trial_q" : h_fit.params["q"].value, "Trial_h" : h_fit.params["h"].value, "AIC": h_fit.aic}, ignore_index = True)
    #for j in range(len(crd_sub)):
        #crd_sub.iloc[j,] = test[test.AIC == min(test.AIC)]
        #fits = fits.append(crd_sub.iloc[j])
        #fits = fits.reindex(crd_sub.columns, axis=1)
    return test[test.AIC == min(test.AIC)]
    

fits = fits.reset_index(drop=True)
fits['ID'] = fits['ID'].astype(numpy.int64)
print("Errors occurred at these IDs:", nofitIDs)

# save final dataframe with all initial data and fits to a csv for R to import for plotting
final.to_csv("../Data/crd_fits")    

# test plot
import matplotlib.pylab as p
#p.ylim((0, 0.8))
p.plot(crd_sub["ResDensity"], crd_sub["N_TraitValue"], "k+")
p.plot(crd_sub["ResDensity"], y_values, 'r')
p.show()


