################## boilerplate R script ######################

# Contains an example function and test print outs.

# Author: Lucy Goodyear (lucy.goodyear19@imperial.ac.uk)
# Version: 0.0.1

# clear workspace
rm(list=ls())

MyFunction <- function(Arg1, Arg2){

    # statements involving Arg1, Arg2
    print(paste("Argument", as.character(Arg1), "is a", class(Arg1))) # print Arg1's type
    print(paste("Argument", as.character(Arg2), "is a", class(Arg2))) # print Arg2's type

    return (c(Arg1, Arg2)) # this is optional but very useful
}

MyFunction(1, 2) # test the function
MyFunction("Riki", "Tiki") # a different test

