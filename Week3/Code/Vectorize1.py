#!/usr/bin/env python3

"""
Contains two methods for calculating the sum of a matrix. 
The first is a function, SumAllElements, containing a for loop and the second 
is the inbuilt 'sum' function. The prints show which method is faster.
"""

__author__ = 'Lucy Goodyear (lucy.goodyear19@imperial.ac.uk)'
__version__ = '0.0.1'

# imports
import scipy as sc
import scipy.stats as scs
import time

# create 1000 by 1000 matrix with random uniform numbers
M = sc.random.normal(size = (1000, 1000))

# calculate sum of matrix using for loop
def SumAllElements(M):
    '''
    Sums all elements of a matrix using a 
    for loop

    Parameters:
        M (matrix) : any matrix

    Returns:
        Tot (float) : the sum of all elements in M
    '''

    Tot = 0
    for i in range(0, len(M[0])):
        for j in range(0, len(M[1])):
            Tot = Tot + M[i, j]
    return Tot

# call the SumAllElements function on matrix M and time it
start = time.time()
SumAllElements(M)
end = time.time()
print("Using loops, the time taken is:")
print(end - start)

# sum all elements of matrix M using the in-built scipy function "sum" and time it
start = time.time()
sc.sum(M)
end = time.time()
print("Using in-built scipy sum function, the time taken is:")
print(end - start)