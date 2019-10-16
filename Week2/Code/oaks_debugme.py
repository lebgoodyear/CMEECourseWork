#!/usr/bin/env python3

"""Locates oaks by genus from given data in a .csv"""

__author__ = 'Lucy Goodyear (lucy.goodyear19@imperial.ac.uk)'
__version__ = '0.0.1'

# imports
import csv      # csv package to read and write .csv files
import sys      # enables external arguments to be read
import doctest  # enables doctesting
import re       # imported from the Standard Python Library
                # regular expressions package to search for specific patterns (e.g. quercus)

# define function to identify oaks in a dataset
def is_an_oak(name):
    """
    Returns True if genus is exactly 'quercus'

    Parameters:
        name (str):
            The latin name of a tree species

    Returns:
        Boolean: True if `name` is an oak, False otherwise
    
    Examples:
    >>> is_an_oak('Fagus sylvatica')
    False

    >>> is_an_oak('Quercus cerris')
    True

    >>> is_an_oak('Quercuss cerris')
    False

    >>> is_an_oak('Querrcus cerris')
    False
    
    """
    # use regular expressions to match genus exactly
    return True if re.match(r'\bquercus\b', name, re.IGNORECASE) else False

doctest.testmod() # runs the above doctests

def main(argv): 
    """Locates oaks and prints them into a new csv file

    Returns 0 on success

    """
    f = open('../Data/TestOaksData.csv','r')
    g = open('../Results/JustOaksData.csv','w')
    taxa = csv.reader(f)
    csvwrite = csv.writer(g)
    firstline = True
    for row in taxa:
        # add header to new csv file
        if firstline:
            csvwrite.writerow([row[0], row[1]])
            firstline = False
            continue 
        print(row)
        print ("The genus is: ") 
        print(row[0] + '\n')
        # adds oaks to csv file
        if is_an_oak(row[0]):
            print('FOUND AN OAK!\n')
            csvwrite.writerow([row[0], row[1]])
    return 0
    
if (__name__ == "__main__"):
    status = main(sys.argv)
