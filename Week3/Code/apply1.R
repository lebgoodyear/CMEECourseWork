######## Practice script looking at using apply on some of R's inbuilt functions ########

# Uses the apply function to calculate the means and variance of each row and the means
# of each column of a random matrix.

# Author: Lucy Goodyear (lucy.goodyear19@imperial.ac.uk)
# Version: 0.0.1

# clear workspace
rm(list=ls())

# build a random matrix
M <- matrix(rnorm(100), 10, 10)

# take the mean of each row
RowMeans <- apply(M, 1, mean)
print(RowMeans)

# now take the variance
RowVars <- apply(M, 1 ,var)
print(RowVars)

# take means by column
ColMeans <- apply(M, 2, mean)
print(ColMeans)
