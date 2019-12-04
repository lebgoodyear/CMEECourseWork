######### Practice script looking at using apply on my own function #########

# Contains a function that takes one parameter, which, if the sum
# is greater than 0, is returned multipled by 100. The apply function 
# is used to apply this function to a matrix by row.

# Author: Lucy Goodyear (lucy.goodyear19@imperial.ac.uk)
# Version: 0.0.1

# clear workspace
rm(list=ls())

# create a function
SomeOperation <- function(v) {
    if (sum(v) > 0){
        return(v * 100)
    }
    return(v)
}

# create a test argument and use apply to run your function on
# all elements at once
M <- matrix(rnorm(100), 10, 10)
print (apply(M, 1, SomeOperation))
