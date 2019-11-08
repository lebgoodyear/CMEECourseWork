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

args <- commandArgs(trailingOnly=TRUE)
print(args)

for (args in args) {
    if (length(args) == 1) {
        Tree_data <- read.csv(args[1])
    }
    else {
        Tree_data <- read.csv("../Data/trees.csv")
    }
}

# add column to Tree_data to include tree heights, calculated by the TreeHeight function
Tree_data$Tree.Height.m <- TreeHeight(Tree_data$Angle.degrees, Tree_data$Distance.m)

# write data to a csv
write.csv(Tree_data, "../Results/TreeHts.csv")
