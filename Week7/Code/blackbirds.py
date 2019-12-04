#!/usr/bin/env python3

"""Uses regex to capture Kingdom, Phylum and Species name from a text file of 
blackbird taxonomic information.

Prepares data by reading the file, replacing tabs and newlines with spaces and
removing any non_ASCII symbols. Regex is then used to print Kingdom, Phylum and
Species name in a list of tuples.

"""

__author__ = 'Lucy Goodyear (lucy.goodyear19@imperial.ac.uk)'
__version__ = '0.0.1'

# imports
import re

# Read the file (using a different, more python 3 way, just for fun!)
with open('../Data/blackbirds.txt', 'r') as f:
    text = f.read()

# replace \t's and \n's with spaces:
text = text.replace('\t',' ')
text = text.replace('\n',' ')
# You may want to make other changes to the text. 

# In particular, note that there are "strange characters" (these are accents and
# non-ascii symbols) because we don't care for them, first transform to ASCII:

text = text.encode('ascii', 'ignore') # first encode into ascii bytes
text = text.decode('ascii', 'ignore') # Now decode back to string

# Now extend this script so that it captures the Kingdom, Phylum and Species
# name for each species and prints it out to screen neatly.

# Hint: you may want to use re.findall(my_reg, text)... Keep in mind that there
# are multiple ways to skin this cat! Your solution could involve multiple
# regular expression calls (easier!), or a single one (harder!)

matches = re.findall(r"(Kingdom\s+\w+\s).+?(Phylum\s+\w+\s).+?(Species\s+[A-Z][a-z]+\s+\w+\s)", text)
print(matches)