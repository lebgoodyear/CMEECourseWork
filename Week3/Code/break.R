############## Practice using break command ####################

# uses break command to break out of a simple loop. 

# Author: Lucy Goodyear (lucy.goodyear19@imperial.ac.uk)
# Version: 0.0.1

# clear workspace
rm(list=ls())

# while loop that prints the numbers i equals 1-9 
# (breaks out of loop when i is 10)
i <- 0 # initialise i
while (i < Inf) {
    if (i == 10) {
        break
    } # break out of while loop
    else {
        cat("i equals ", i, "\n")
        i <- i + 1 # update i
    }
}
