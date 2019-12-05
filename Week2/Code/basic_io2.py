#!/usr/bin/env python3

"""A script that uses a for loop to write the numbers 0-99 into a .txt file with a new line between each number"""

__author__ = 'Lucy Goodyear (lucy.goodyear19@imperial.ac.uk)'
__version__ = '0.0.1'

# create the list of numbers 0-99
list_to_save = range(100)

f = open('../Results/testout.txt','w')
# save the elements of the list to the file above
for i in list_to_save:
    f.write(str(i) + '\n') # add a new line at the end
    print(i)

f.close()