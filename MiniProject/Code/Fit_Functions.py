#!/usr/bin/env python3

""" 
Fits NLLS model to consumer resource data.

"""

__author__ = 'Lucy Goodyear (lucy.goodyear19@imperial.ac.uk)'
__version__ = '0.0.1'

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
        # try to fit the general functional response model to every starting value in the sample of 100
        try:
            GFR_fit = lmfit.minimize(GFR, GFR_params, args = (df["ResDensity"], df["N_TraitValue"]))
        # catch any IDs fail and save them to a list
        except ValueError:
            print("Errored at ID", i, " - no Holling fit possible")
            nofitIDs = nofitIDs.append(i)
        pass # we can pass safely after failing IDs have been caught
        # append all test starting parameters to a data frame
        test = test.append({"Trial_a" : GFR_fit.params["a"].value, "Trial_q" : GFR_fit.params["q"].value, "Trial_h" : GFR_fit.params["h"].value, "RSS": GFR_fit.residual,  "AIC": GFR_fit.aic, "BIC": GFR_fit.bic}, ignore_index = True)
    test = test[test.AIC == min(test.AIC)] # choose lowest AIC as starting values for model
    return test

def poly_fit(crd_sub):
    try:
    # try to fit a polynomial to each dataset
        fit = numpy.polynomial.polynomial.polyfit(crd_sub["ResDensity"], crd_sub["N_TraitValue"], 3, full = True)
    except ValueError:
        print("Errored at ID", i, " - no polynomial fit possible")
        nofitIDs = nofitIDs.append(i)
        pass # we can pass safely after failing IDs have been caught
    if PolynomialFit[1][0].size == 0:
        print("Errored at ID", i, " - no polynomial fit possible")
        nofitIDs = nofitIDs.append(i)
    else: 
        return fit