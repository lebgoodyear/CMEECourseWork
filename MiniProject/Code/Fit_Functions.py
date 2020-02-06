#!/usr/bin/env python3


""" 
Three functions to fit NLLS models to consumer resource data:

1) GFR contains the General Functional Response equation. It takes General Functional Response parameters (3: a,q,h) and x and y vectors
and returns vector containing the difference between the actual value and the model value. It is used within the sample_starts function.

2) sample_starts calculates starting values for each dataset by sampling from a Gaussian distribution with a mean of the intial input values. 
These are then modeled using the GFR function and AIC is caluclated for each set of sample values and the one with the lowest AIC is 
selected. It takes two inputs, df (the dataframe containing the datasets that are to be modeled) and maxiters (the number of samples 
to be taken from the Gaussian distribution). Output is a dataframe containing the selected starting paramenters.

3) poly_fit tries to fit a polynomial to each dataset, saving any IDs that cannot be fitted to a separate vector. It takes a dataframe
as input and returns a dataframe of fitting parameters as output.

"""


__author__ = 'Lucy Goodyear (lucy.goodyear19@imperial.ac.uk)'
__version__ = '0.0.1'


# function for Generalised Functional Response
def GFR(GFR_params, x, y):
    '''
    Defines generalised functional response eauation, where where a is equivalent 
    to the gradient of the initial part of the slope and h is handling time, which
    is the maximum y-value.

    Inputs:
    GFR_params (paramater object):  Parameter object containing a,q,h
    x (vector) :                    Vector of x-values (could be column of dataframe)
    y (vector) :                    Vector of y-values (could be column of dataframe)

    Returns:
    y - model (vector) :              Difference between actual values and model
    '''

    a = GFR_params["a"]
    q = GFR_params["q"]
    h = GFR_params["h"]
    model = (a * (x ** (q + 1))) / (1 + h * a * (x ** (q + 1)))
    return y - model


# functional to find starting values for each of 3 parameters: a, q, h
def sample_starts(df, maxiters):
    '''
    Uses initial estimates to generate starting values by sampling from Gaussian distribution with those
    initial estimates as the mean. Fits the model to each sample and calculates the AIC. The AIC values 
    are then compared for each set of sample values and the set with the lowest is chosen.

    Inputs:
    df (pandas dataframe) :     pandas dataframe containing initial estimates for a, q, h
    maxiters (numierc) :        number of samples drawn from distribution

    Returns:
    test (pandas dataframe) :   pandas dataframe containing most suitable starting values
    '''

    # initialise empty data frame to store possible starting values
    test = pandas.DataFrame(columns = ["Trial_a", "Trial_q", "Trial_h", "AIC"])
    # find starting values for parameters from Gaussian distribution with initial estimates as mean
    a = numpy.random.normal(df['initial_a'][1], 1, maxiters)
    h = numpy.random.normal(df['initial_h'][1], 1, maxiters)
    # test sample input parameters with for loop by applying GFR model to find most appropriate starting values (lowest AIC)
    for k in range(0, maxiters):
        GFR_params = lmfit.Parameters()
        GFR_params.add("a", value = a[k])
        GFR_params.add("q", value = 0, min=-2, max = 2)
        GFR_params.add("h", value = h[k])
        # try to fit the general functional response model to starting value set k
        try:
            GFR_fit = lmfit.minimize(GFR, GFR_params, args = (df["ResDensity"], df["N_TraitValue"]))
        # catch any IDs fail and save them to a list
        except ValueError:
            print("Errored at ID", i, " - no Generalised Functional Response fit possible")
            nofitIDs = nofitIDs.append(i)
        pass # we can pass safely after failing IDs have been caught
        # append all test starting parameters to a data frame, inlcuding AIC, BIC and RSS
        test = test.append({"Trial_a" : GFR_fit.params["a"].value, "Trial_q" : GFR_fit.params["q"].value, "Trial_h" : GFR_fit.params["h"].value, "RSS": GFR_fit.residual,  "AIC": GFR_fit.aic, "BIC": GFR_fit.bic}, ignore_index = True)
    test = test[test.AIC == min(test.AIC)] # choose lowest AIC as starting values for model
    return test


def poly_fit(crd_sub):
    '''
    Fits a polynomial to each dataset in a dataframe using try and except to catch any dataset where
    no fit is possible.

    Inputs:
    crd_sub (dataframe) :   initial dataframe containing user's data

    Returns:
    fit (dataframe) :       dataframe containing polynomial fit parameters
    '''

    # try to fit a polynomial to each dataset
    try:
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