########### Calculate tree heights from a given csv of distances and angles ##########

# Contains a function, TreeHeight, that calculates heights of trees given the distance
# of each tree from its base and angle to its top, using the trigonometric formula. 
# This function is called on data from a csv file, which has been provided by the user 
# as a command line argument, the results of which are added as an additional column to 
# the dataframe. The new dataframe is saved as a csv, the name of which includes the 
# basename of the input csv.

# Author: Lucy Goodyear (lucy.goodyear19@imperial.ac.uk)
# Version: 0.0.1

# clear workspace
rm(list=ls())

# This function calculates heights of trees given the distance
# of each tree from its base and angle to its top, using the 
# trigonometric formula

# height = distance * tan(radians)

# Arguments:
# degrees: The angle of elevation of tree
# distance: The distance from base of tree (e.g. metres)

# Output:
# the heights of the trees, same units as "distance"

TreeHeight <- function(degrees, distance){
    radians <- degrees * pi / 180
    height <- distance * tan(radians)
    # commented out print function below to improve speed with large datasets
    #print(paste("Tree height is", height))

    return(height)
}

# read command line arguments
args <- commandArgs(trailingOnly=TRUE)

# if statement to check a data file has been provided as an argument
if (length(args) == 0) {
    stop("No input file detected: please provide a data file")
} else {
    # reads input csv
    Tree_data <- read.csv(paste0(args[1]))
    namebase <- args[1]
}

# add column to Tree_data to include tree heights, calculated by the TreeHeight function
Tree_data$Tree.Height.m <- TreeHeight(Tree_data$Angle.degrees, Tree_data$Distance.m)

# use in-built "tools" package to obtain only the filename (remove relative path and extension) 
name <- tools::file_path_sans_ext(basename(namebase))

# write data to csv using the input filename
write.csv(Tree_data, paste0("../Results/", name, "_treeheights_R.csv"))
