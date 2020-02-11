#!/usr/bin/env python3


""" 
Three functions to fit NLLS models to consumer resource data:

1) GFR 
Contains the General Functional Response equation. It takes General Functional Response parameters (3: a,q,h) and x and y vectors
and returns vector containing the difference between the actual value and the model value. It is used within the GFR_fit function.

2) GFR_fit
Calculates starting values for each dataset by sampling from a Gaussian distribution with a mean of the intial input values. 
These are then modeled using the GFR function and AIC is caluclated for each set of sample values and the one with the lowest AIC is 
selected. It takes two inputs, df (the dataframe containing the datasets that are to be modeled) and maxiters (the number of samples 
to be taken from the Gaussian distribution). Output is a dataframe containing the selected starting paramenters.

3) poly_fit
Tries to fit a polynomial to each dataset, saving any IDs that cannot be fitted to a separate vector. It takes a dataframe
as input and returns a dataframe of fitting parameters as output.

"""


__author__ = 'Lucy Goodyear (lucy.goodyear19@imperial.ac.uk)'
__version__ = '0.0.1'


# imports
import lmfit
import pandas
import numpy


# function for Generalised Functional Response
def GFR(GFR_params, x, y):
    '''
    Defines generalised functional response equation. Requires a parameter object containing
    3 parameters: a, q and h, where a is equivalent to the gradient of the initial part of the 
    slope and h is handling time, which is the maximum y-value. Also requires the data to be 
    modeled as a vector of x- and a vector of y-values.

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
def GFR_fit(df, maxiters):
    '''
    Uses initial estimates to generate starting values by sampling from Gaussian distribution with those
    initial estimates as the mean. Fits the model to each sample and calculates the AIC. The AIC values 
    are then compared for each set of sample values and the set with the lowest is chosen.

    Inputs:
    df (pandas dataframe) :     pandas dataframe containing the x- and y-values to be fitted and 
                                initial estimates for a and h, which must contained in the second,
                                third, fourth and fifith colunns respectively (assumption is that 
                                first column contains an ID)
    maxiters (numierc) :        number of samples drawn from distribution

    Returns:
    test (pandas dataframe) :   pandas dataframe containing most suitable starting values
    '''

    # initialise empty data frame to store possible starting values
    test = pandas.DataFrame(columns = ["Trial_a", "Trial_q", "Trial_h", "RSS", "AIC", "BIC"])
    # find starting values for parameters from Gaussian distribution with initial estimates as mean
    a = numpy.random.normal(df.iloc[1,3], 1, maxiters)
    h = numpy.random.normal(df.iloc[1,4], 1, maxiters)
    # test sample input parameters with for loop by applying GFR model to find most appropriate starting values (lowest AIC)
    for k in range(0, maxiters):
        GFR_params = lmfit.Parameters()
        GFR_params.add("a", value = a[k])
        GFR_params.add("q", value = 0, min=-2, max = 2)
        GFR_params.add("h", value = h[k])
        # try to fit the general functional response model to starting value set k
        try:
            GFR_fit = lmfit.minimize(GFR, GFR_params, args = (df.iloc[:,1], df.iloc[:,2]))
        # catch any IDs fail and save them to a list
        except ValueError:
            return None # we can pass safely after failing IDs have been caught
        # append all test starting parameters to a data frame, inlcuding AIC, BIC and RSS
        test = test.append({"Trial_a" : GFR_fit.params["a"].value, "Trial_q" : GFR_fit.params["q"].value, "Trial_h" : GFR_fit.params["h"].value, "RSS": GFR_fit.residual,  "AIC": GFR_fit.aic, "BIC": GFR_fit.bic}, ignore_index = True)
    best_fit = test[test.AIC == min(test.AIC)] # choose lowest AIC as starting values for model
    return best_fit


def poly_fit(x, y):
    '''
    Fits a polynomial (max cubic) to a dataset of x- and y-values using try and except to catch any dataset where
    no fit is possible. Also catches fits with empty residual sums of sqaures, which are the equivalent of no fit.
    If a fit is possible, returns one object containing a ndarray of coefficients and a list of fitting statistics, 
    otherwise returns None.

    Inputs:
    x (vector) :    vector of x-values (could be column of dataframe)
    y (vector) :    vector of y-values (could be column of dataframe)

    Returns:
    fit (object containing ndarray and list) :   ndarray of coefficients and a list of fitting statistics
    None :                                       None
    '''

    # try to fit a polynomial to each dataset
    try:
        fit = numpy.polynomial.polynomial.polyfit(x, y, 3, full = True)
    except ValueError:
        return None # we can pass safely after failing IDs have been caught
    return None if fit[1][0].size == 0 else fit