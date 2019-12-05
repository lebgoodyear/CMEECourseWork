#!/usr/bin/env python3

"""
Practice example for using the debugger.

Contains one function with a written-in error for the debugger to detect.
"""

__author__ = 'Lucy Goodyear (lucy.goodyear19@imperial.ac.uk)'
__version__ = '0.0.1'

def makeabug(x):
    """Simple numerical function with an error (dividing by 0) for debugger to detect"""
    y = x**4
    z = 0.
    y = y/z
    return y

# call makeabug function to view error/debug
makeabug(25)

