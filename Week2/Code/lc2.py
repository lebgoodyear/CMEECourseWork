#!/usr/bin/env python3

"""
Using list comprehensions and loops to identify months with 
high and low rainfall from a given tuple of tuples
"""

__author__ = 'Lucy Goodyear (lucy.goodyear19@imperial.ac.uk)'
__version__ = '0.0.1'

# Average UK Rainfall (mm) for 1910 by month
# http://www.metoffice.gov.uk/climate/uk/datasets
rainfall = (('JAN',111.4),
            ('FEB',126.1),
            ('MAR', 49.9),
            ('APR', 95.3),
            ('MAY', 71.8),
            ('JUN', 70.2),
            ('JUL', 97.1),
            ('AUG',140.2),
            ('SEP', 27.0),
            ('OCT', 89.4),
            ('NOV',128.4),
            ('DEC',142.2),
           )

# (1) Use a list comprehension to create a list of month,rainfall tuples where
# the amount of rain was greater than 100 mm.

greater_lc = [row for row in rainfall if row[1] > 100.0]
print(greater_lc)

# (2) Use a list comprehension to create a list of just month names where the
# amount of rain was less than 50 mm. 

lower_lc = [row[0] for row in rainfall if row[1] < 50.0]
print(lower_lc)

# (3) Now do (1) and (2) using conventional loops (you can choose to do 
# this before 1 and 2 !). 

greater_loop = []
for row in rainfall:
    if row[1] > 100.0:
        greater_loop.append(row)
print(greater_loop)

lower_loop = []
for row in rainfall:
    if row[1] < 50.0:
        lower_loop.append(row[0])
print(lower_loop)
