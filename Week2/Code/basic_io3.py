#!/usr/bin/env python3

"""A script to store a dictionary for later use using the pickle package"""

__author__ = 'Lucy Goodyear (lucy.goodyear19@imperial.ac.uk)'
__version__ = '0.0.1'

# imports
import pickle

# create a dictionary
my_dictionary = {"a key": 10, "another key": 11}

f = open('../Sandbox/testp.p','wb') # note the b: accept binary
# save my_dictionary into file f using pickle
pickle.dump(my_dictionary, f) # note: pickle can be used to save objects other than dictionaries
f.close()

# load the data again
f = open('../Sandbox/testp.p','rb')
another_dictionary = pickle.load(f)
f.close()

print(another_dictionary)