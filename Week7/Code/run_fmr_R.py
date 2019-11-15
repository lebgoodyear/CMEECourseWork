#!/usr/bin/env python3

""" Uses the subprocess module to run an R-script that produces a pdf. 

Prints the R output to screen and includes try and except to kill the 
process if it takes longer than 30 seconds and also includes an if statement 
to print whether the R-script ran successfully.
"""

__author__ = 'Lucy Goodyear (lucy.goodyear19@imperial.ac.uk)'
__version__ = '0.0.1'

# imports
import subprocess
import re

# use Popen to run an Rscript through python
p = subprocess.Popen("Rscript --verbose fmr.R", stdout=subprocess.PIPE, stderr=subprocess.PIPE, shell=True)

# use try and except to timeout if p.communicate() takes too long
try:
    stdout, stderr = p.communicate(timeout = 30)
except subprocess.TimeoutExpired:
    print("fmr.R communicate failed in time limit")
    print("Killing communication...")
    p.kill()
    stdout, stderr = p.communicate() # extract outputs from before kill occured
    print("Communication killed")

print("R output:")    
print(stdout.decode())
match =  re.search(r"error", stdout.decode()) # if the output contains an error
if match: 
    print("Failure")
elif stdout.decode() is '': # if the output is empty
    print("Failure")
else:
    print("Success!")

