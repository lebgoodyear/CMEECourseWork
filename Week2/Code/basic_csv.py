#!/usr/bin/env python3

"""A script that reads and writes .csv files.

The script reads a csv (using the csv package) and then prints it as a list,
explicitly stating the species name after each row (on a new line). 
The script then writes a subset of each row from the first csv into a different csv.

"""

__author__ = 'Lucy Goodyear (lucy.goodyear19@imperial.ac.uk)'
__version__ = '0.0.1'

# imports
import csv # csv package to read and write .csv files

# read a file containing
# 'Species', 'Infraorder', 'Family', 'Distribution', 'Body mass male (kg)'
f = open('../Data/testcsv.csv', 'r')

csvread = csv.reader(f) 
firstline = True
# reads and prints the rows in the .csv file
for row in csvread:
    print(row)
    if firstline:
        firstline = False
        continue
    print("The species is", row[0])

f.close()

# Write a file containing only species name and body mass
f = open('../Data/testcsv.csv', 'r')
g = open('../Results/bodymass.csv','w')

csvread = csv.reader(f)
csvwrite = csv.writer(g)
for row in csvread:
    print(row)
    csvwrite.writerow([row[0], row[4]])

f.close()
g.close()
