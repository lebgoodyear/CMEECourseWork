############## Speed of loops vs in-built functions ###############

# Contains two methods for calculating the sum of a matrix. 
# The first is a function, SumAllElements, containing a for loop and the second 
# is the inbuilt 'sum' function. The prints show which method is faster.

# Author: Lucy Goodyear (lucy.goodyear19@imperial.ac.uk)
# Version: 0.0.1

# clear workspace
rm(list=ls())

# create 1000 by 1000 matrix with random uniform numbers
M <- matrix(runif(1000000), 1000, 1000)

# calculate sum of matrix using for loop
SumAllElements <- function(M){
    Dimensions <- dim(M)
    Tot <- 0
    for (i in 1: Dimensions[1]){
        for (j in 1:Dimensions[2]){
            Tot <- Tot + M[i, j]
        }
    }
    return (Tot)
}

# call the SumAllElements function on matrix M and time it
print(paste("Using loops, the time taken is:", system.time(SumAllElements(M))[3]))

# sum all elements of matrix M using the in-built function "sum" and time it
print(paste("Using the in-built vectorized function, the time taken is:", system.time(sum(M))[3]))
            
            