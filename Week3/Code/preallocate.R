############### Two methods of creating a matrix ################

# Two methods of creating a matrix, one without using preallocation 
# (function, f) and one using preallocaiton (function, g). The 
# times taken for each function to run are printed to allow comparison.

# Author: Lucy Goodyear (lucy.goodyear19@imperial.ac.uk)
# Version: 0.0.1

# clear workspace
rm(list=ls())

# initialise empty variable
a <- NA

# function to add the numbers 1 to 10000 to a using a for loop
f <- function(a) {
    for (i in 1:10000) {
        a <- c(a, i)
        
        # in-function print commands have been commented out 
        # to increase speed
        
        #print(a)
        #print(object.size(a))
    }
}

# initialise and preallocate empty matrix
a <- rep(NA, 10)

# function to insert the numbers 1 to 10000 into preallocated matrix
g <- function(a) {
    for (i in 1:10000) {
        a[i] <- i
        
        # in-function print commands have been commented out 
        # to increase speed
        
        #print(a)
        #print(object.size(a))
    }
}

# compare difference in computing times:

# time taken for first function
print("Time taken without preallocation:")
print(system.time(f(a)))

# time taken for second function
print("Time taken with preallocation:")
print(system.time(g(a)))