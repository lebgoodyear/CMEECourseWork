#!/usr/bin/env python3

"""A script to practice various for and while loops"""

__author__ = 'Lucy Goodyear (lucy.goodyear19@imperial.ac.uk)'
__version__ = '0.0.1'

# FOR loops in Python
for i in range(5):
    print(i) # print the numbers 0-4

my_list = [0, 2, "geronimo!", 3.0, True, False]
for k in my_list:
    print(k) # print each item in the list

total = 0
summands = [0, 1, 11, 111, 1111]
for s in summands:
    total = total + s # sums by adding each element to the total
    print(total)

# WHILE loops in Python
z = 0
while z < 100:
    z = z + 1
    print(z) # prints the numbers 1-100

b = True
while b:
    print("GERONIMO! inifinte loop! ctrl+c to stop!")
# ctrl + c to stop the loop!