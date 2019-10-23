# This function calculates heights of trees given the distance
# of each tree from its base and angle to its top, using the 
# trigonometric formula

# height = distance * tan(radians)

# Arguments:
# degrees: The angle of elevation of tree
# distance: The distance from base of tree (e.g. metres)

# Output:
# the heights of the trees, same units as "distance"

# loads data from a csv
Tree_data <- read.csv("../Data/trees.csv")

TreeHeight <- function(degrees, distance){
    radians <- degrees * pi / 180
    height <- distance * tan(radians)
 
    #print(paste("Tree height is", height))

    return(height)
}

TreeHeight(37, 40)

Tree_data$Tree.Height.m <- TreeHeight(Tree_data$Angle.degrees, Tree_data$Distance.m)

write.csv(TreeDF, "../Results/TreeHts.csv")

