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
crd = pandas.read_csv("../Data/CRatMod.csv")

# a is gradient
# handling time is maximum y-value

def Holling(h_params, x, y):
    a = h_params["a"]
    q = h_params["q"]
    h = h_params["h"]

    model = (a * (x ** (q + 1))) / (1 + h * a * (x ** (q + 1)))

    return y - model

h_params = lmfit.Parameters()
h_params.add("a", value = 0.0015 )
h_params.add("q", value = 0)
h_params.add("h", value = 0.65)

# test for one data subset
crd_sub = crd[crd['ID'] == 39835]

h_fit = lmfit.minimize(Holling, h_params, args = (crd_sub["ResDensity"], crd_sub["N_TraitValue"]), method = "leastsquares")
y_values = crd_sub["N_TraitValue"] + h_fit.residual
h_fit.params.pretty_print()
print(lmfit.fit_report(h_fit))

# create for loop to fit Holling for all data subsets
number = [39835, 39836]
subs = crd[crd.ID.isin(number)]

# subs.insert(2, "Estimated", "")
# subs.insert(3, "a", "")
# subs.insert(4, "q", "")
# subs.insert(5, "h", "")

frames = pandas.DataFrame()
final = pandas.DataFrame()
for i in number:# numpy.nditer(numpy.unique(subs['ID'])):
    subs_sub = subs[subs.ID == i]
    #try:
    h_fit = lmfit.minimize(Holling, h_params, args = (subs_sub["ResDensity"], subs_sub["N_TraitValue"]), method = "leastsquares")
    y_values = subs_sub["N_TraitValue"] + h_fit.residual
    #except ... :
    #
    for j in range(len(subs_sub)):
        # extract values for plotting in R
        subs_sub.loc[j,('EstimatedTraitValues')] = y_values[j]
        subs_sub.loc[j,('a')] = h_fit.params["a"].value
        subs_sub.loc[j,('q')] = h_fit.params["q"].value
        subs_sub.loc[j,('h')] = h_fit.params["h"].value
    
        frames = frames.append(subs_sub.loc[j])

    final = final.append(frames)

# result = pd.concat(frames, keys=['ID'])
final.to_csv("../Data/crd_fits")    

# test plot
import matplotlib.pylab as p
#p.ylim((0, 0.8))
p.plot(crd_sub["ResDensity"], crd_sub["N_TraitValue"], "k+")
p.plot(crd_sub["ResDensity"], y_values, 'r')
p.show()


