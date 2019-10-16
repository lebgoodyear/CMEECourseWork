#!/usr/bin/env python3

"""Populates a dictionary from a given list of tuples"""

__author__ = 'Lucy Goodyear (lucy.goodyear19@imperial.ac.uk)'
__version__ = '0.0.1'

taxa = [ ('Myotis lucifugus','Chiroptera'),
         ('Gerbillus henleyi','Rodentia',),
         ('Peromyscus crinitus', 'Rodentia'),
         ('Mus domesticus', 'Rodentia'),
         ('Cleithrionomys rutilus', 'Rodentia'),
         ('Microgale dobsoni', 'Afrosoricida'),
         ('Microgale talazaci', 'Afrosoricida'),
         ('Lyacon pictus', 'Carnivora'),
         ('Arctocephalus gazella', 'Carnivora'),
         ('Canis lupus', 'Carnivora'),
        ]

# write a short python script to populate a dictionary called taxa_dic 
# derived from  taxa so that it maps order names to sets of taxa. 
# e.g. 'Chiroptera' : set(['Myotis lucifugus']) etc. 

# create a dictionary of empty sets indexed by the orders 
taxa_dic = {order : set() for species, order in taxa}

# create a for loop over the tuples to find the taxa that are mapped to 
# by the orders and add them to the dictionary as a value
for taxa_tuple in taxa:
        taxa_dic[taxa_tuple[1]].add(taxa_tuple[0])

print(taxa_dic)        