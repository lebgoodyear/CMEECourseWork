#!/usr/bin/env python3

"""
Produces a list of files and directories from your home directory
using the subprocess.os module. It creates three separate lists: files and
directories starting with an upper case "C"; files and directories
starting with an upper case "C" or a lower case "c"; and finally 
only directories starting with an upper case "C" or a lower case "c".

"""

__author__ = 'Lucy Goodyear (lucy.goodyear19@imperial.ac.uk)'
__version__ = '0.0.1'""" This is blah blah"""

# Use the subprocess.os module to get a list of files and directories 
# in your ubuntu home directory 

# Hint: look in subprocess.os and/or subprocess.os.path and/or 
# subprocess.os.walk for helpful functions

# imports

import subprocess
import re

#################################
#~Get a list of files and 
#~directories in your home/ that start with an uppercase 'C'

# Type your code here:

# Get the user's home directory.
home = subprocess.os.path.expanduser("~")

# Create a list to store the results.
FilesDirsStartingWithC = []

# Use a for loop to walk through the home directory.
for dir, subdir, files in subprocess.os.walk(home):
    for x in subdir + files: 
        if re.match("C", x):
            FilesDirsStartingWithC.append(x)

print("Number of files or directories starting with C:")
print(len(FilesDirsStartingWithC))
FilesDirsStartingWithC
  
#################################
# Get files and directories in your home/ that start with either an 
# upper or lower case 'C'

# Type your code here:

# Create a list to store the results.
FilesDirsStartingWithCc = []

# Use a for loop to walk through the home directory.
for dir, subdir, files in subprocess.os.walk(home):
    for x in subdir + files:
        if re.match("C|c", x):
            FilesDirsStartingWithCc.append(x)

print("Number of files or directories starting with C or c:")
print(len(FilesDirsStartingWithCc))
FilesDirsStartingWithCc

#################################
# Get only directories in your home/ that start with either an upper or 
#~lower case 'C' 

# Type your code here:

# Create a list to store the results.
DirsStartingWithCc = []

for dir, subdir, files in subprocess.os.walk(home):
    for x in subdir: # only look in subdirectories
        if re.match("C|c", x):
            DirsStartingWithCc.append(x)

print("Number of directories starting with C or c:")
print(len(DirsStartingWithCc))
DirsStartingWithCc