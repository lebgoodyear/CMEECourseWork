############## R input-output ####################

# illustrates R input-output: loads data from a csv, 
# writes data to a csv and then makes changes to that csv

# Author: Lucy Goodyear (lucy.goodyear19@imperial.ac.uk)
# Version: 0.0.1

# clear workspace
rm(list=ls())

# A simple script to illustrate R input-output.
# Run line by line and check inputs outputs to understand what is happening.

MyData <- read.csv("../Data/trees.csv", header = TRUE) # import with headers

write.csv(MyData, "../Results/MyData.csv") # write it out as a new file

write.table(MyData[1,], file = "../Results/MyData.csv", append = TRUE) # append to it

write.csv(MyData, "../Results/MyData.csv", row.names = TRUE) # write row names

write.table(MyData, "../Results/MyData.csv", col.names = FALSE) # ignore column names