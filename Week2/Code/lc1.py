#!/usr/bin/env python3

"""
Some list comprehensions and for loops to print different attributes 
of birds from a tuple of tuples
"""

__author__ = 'Lucy Goodyear (lucy.goodyear19@imperial.ac.uk)'
__version__ = '0.0.1'

birds = ( ('Passerculus sandwichensis','Savannah sparrow',18.7),
          ('Delichon urbica','House martin',19),
          ('Junco phaeonotus','Yellow-eyed junco',19.5),
          ('Junco hyemalis','Dark-eyed junco',19.6),
          ('Tachycineata bicolor','Tree swallow',20.2),
         )

#(1) Write three separate list comprehensions that create three different
# lists containing the latin names, common names and mean body masses for
# each species in birds, respectively. 

print("Using list comprehensions:")

latin_lc = [species[0] for species in birds]
print("Latin names:", latin_lc)

common_name_lc = [species[1] for species in birds]
print("Common names:", common_name_lc)

mass_lc = [species[2] for species in birds]
print("Masses:", mass_lc)

# (2) Now do the same using conventional loops (you can choose to do this 
# before 1 !). 

print("Using conventional loops:")

latin_loop = []
for species in birds:
    latin_loop.append(species[0])
print("Latin names:", latin_loop)

common_name_loop = []
for species in birds:
   common_name_loop.append(species[1])
print("Common names:", common_name_loop)

mass_loop = []
for species in birds:
    mass_loop.append(species[2])
print("Masses:", mass_loop)
