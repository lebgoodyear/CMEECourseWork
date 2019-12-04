#!/usr/bin/env python3

"""
Practice running a .R script in python
"""

__author__ = 'Lucy Goodyear (lucy.goodyear19@imperial.ac.uk)'
__version__ = '0.0.1'

# imports
import subprocess

subprocess.Popen("Rscript --verbose TestR.R > ../Results/TestR.Rout 2> ../Results/TestR_errfile.Rout", shell = True).wait()
