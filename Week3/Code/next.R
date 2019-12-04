############## Practice using next command ####################

# Uses next to skip to the next iteration of a loop.
# The loop checks which numbers between 1 and 10 are odd by 
# using the modulo operation and then all odd numbers are printed. 

# Author: Lucy Goodyear (lucy.goodyear19@imperial.ac.uk)
# Version: 0.0.1

# clear workspace
rm(list=ls())

# a for loop that prints only odd numbers
for (i in 1:10) {
    if ((i %% 2) == 0)
        next # pass to next iteration of loop
    print(i)
}