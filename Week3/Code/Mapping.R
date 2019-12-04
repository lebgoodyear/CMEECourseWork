##### Plots a map showing spaital spread of species from dataset #######
########################################################################

# plots an empty world map using the maps package and adds data points
# from a dataset containing species and corresponding longitudes and 
# latitudes

# Author: Lucy Goodyear (lucy.goodyear19@imperial.ac.uk)
# Version: 0.0.1

# clear workspace
rm(list=ls())

#imports
library(maps)

# load the data
load("../Data/GPDDFiltered.RData")

# plot the map using the maps package
map(database = "world", fill=TRUE, col="darkolivegreen3", 
    bg = "cadetblue2", ylim = c(-60,90), border = "grey66")
# plot the data points onto the map
points(x = gpdd$long, y = gpdd$lat, col = "black", pch = 1, cex = 0.35)        

# Expected biases:
# Spatial bias!
# 1) Data points are from temperate regions so no weighting
# from tropical species (however analysis may be specifically
# focused on species from temperate regions)
# 2) Most data is from UK or the west coast of USA, not representative
# of actual biodiversity of species across temperate regions

