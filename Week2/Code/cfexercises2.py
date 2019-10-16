#!/usr/bin/env python3

"""A script combining loops and conditionals, printing the string 'hello' each time condition is met."""

__author__ = 'Lucy Goodyear (lucy.goodyear19@imperial.ac.uk)'
__version__ = '0.0.1'

# Prints 'hello' for the number of times that 3 goes into 0-11 with no remainder
for j in range(1):
    if j % 3 == 0:
        print('hello')

# Prints 'hello' for the number of times that 5 and 4 go into 0-14 with remainder 3 (no duplicates)
for j in range(15):
    if j % 5 == 3:
        print('hello')
    elif j % 4 == 3:
        print('hello')

# Prints 'hello' for 0, 3, 6, 9, 12
z = 0
while z != 15:
    print('hello')
    z = z + 3

# Prints 'hello' 7 times when z == 31 and 1 time when z == 18
z = 12
while z < 100:
    if z == 31:
        for k in range(7):
            print('hello')
    elif z == 18:
        print('hello')
    z = z + 1
