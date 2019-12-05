#!/usr/bin/env python3

"""A script that uses a for loop to read from a .txt file, printing the content first with and then without blank lines"""

__author__ = 'Lucy Goodyear (lucy.goodyear19@imperial.ac.uk)'
__version__ = '0.0.1'

# open a file for reading
f = open('../Data/testweek2.txt', 'r') # r for read-only
# use "implicit" for loop:
# if the object is a file, python will cycle lines
print("\nRead file:\n")
for line in f:
    print(line)

# close the file
f.close()

# same example, skip blank lines
print("\nRead file, skipping blank lines:\n")
f = open('../Data/testweek2.txt', 'r')
for line in f:
    if len(line.strip()) > 0:
        print(line)

f.close()