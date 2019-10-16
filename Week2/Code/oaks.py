#!/usr/bin/env python3

"""A script that finds the taxa of oak trees from a list of species"""

__author__ = 'Lucy Goodyear (lucy.goodyear19@imperial.ac.uk)'
__version__ = '0.0.1'

# imports
import doctest

taxa = [    'Quercus robur',
            'Fraxinus excelsior',
            'Pinus sylvestris',
            'Quercus cerris',
            'Quercus petraea',
        ]

def is_an_oak(name):
    """Returns True if `name` starts with quercus

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
    return name.lower().startswith('quercus ')

doctest.testmod() # runs the above doctests

# for loop to add oak species to a set
oaks_loops = set()
for species in taxa:
    if is_an_oak(species):
        oaks_loops.add(species)
print(oaks_loops)

# list comprehension to add oak species to a set 
# (same output as for loop above)
oaks_lc = set([species for species in taxa if is_an_oak(species)])
print(oaks_lc)

# for loop to add oak species in UPPER CASE to a set
oaks_loops = set()
for species in taxa:
    if is_an_oak(species):
        oaks_loops.add(species.upper())
print(oaks_loops)

# list comprehension to add oak species in UPPER CASE to a set 
# (same output as for loop above)
oaks_lc = set([species.upper() for species in taxa if is_an_oak(species)])
print(oaks_lc)
