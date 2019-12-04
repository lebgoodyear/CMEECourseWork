#!/usr/bin/env python3

""" 
Contains a function, TreeHeight, that calculates heights of trees given the distance of each tree from its base 
and angle to its top, using the trigonometric formula. In the main function, the TreeHeight function is called 
on data from a csv, which has previously been provided by the user as a command line argument and then loaded 
as a pandas dataframe. The returns from the TreeHeight function call are added as an additional column to the dataframe, 
which is saved as a new csv file. The main function also strips the csv command line argument of its relative path 
and extension and uses that basename as the name of the resulting csv.

"""

__author__ = 'Lucy Goodyear (lucy.goodyear19@imperial.ac.uk)'
__version__ = '0.0.1'

# imports
import sys
import scipy as sc
import pandas as pd
from pathlib import Path

# define function to caluclate tree height
def TreeHeight(degrees, distance):
    '''
    Calculates heights of trees given the distance
    of each tree from its base and angle to its top, using the 
    trigonometric formula

    height = distance * tan(radians)

    Parameters:
        degrees (float) : The angle of elevation of tree
        distance (float) : The distance from base of tree (e.g. metres)

    Returns:
        height (float) : the heights of the trees, same units as "distance"

    '''
    radians = degrees * sc.pi / 180
    height = distance * sc.tan(radians)
    # commented out print function below to improve speed with large datasets
    #print(paste("Tree height is", height))

    return(height)

# define main programme as main function to enable arguments to be set from the command line
def main(Tree_data):
    '''
    Calls the TreeHeight function on data from a csv, which has previously been provided by the user
    as a command line argument and then loaded as a pandas dataframe. The returns from the 
    function call are added as an additional column to the dataframe, which is saved as a new csv file.
    It strips the csv command line argument of its relative path and extension and uses that basename 
    as the name of the resulting csv.
    '''
    
    # add column to Tree_data to include tree heights, calculated by the TreeHeight function
    Tree_data["Tree.Height.m"] = Tree_data.apply(lambda x: TreeHeight(x["Distance.m"], x["Angle.degrees"]), axis = 1)

    # write data to csv using the input filename (removing relative path and extension and then adding the new ones)
    Tree_data.to_csv(Path(Path('../Results/'), Path(sys.argv[1]).stem + '_treeheights_py.csv'))

if __name__ == "__main__":
    # use data file provided by user in command line
    if len(sys.argv) == 1:
        print("No input file detected: please provide a data file")
        exit()
    else:
        Tree_data = pd.read_csv(sys.argv[1])
        main(Tree_data)
