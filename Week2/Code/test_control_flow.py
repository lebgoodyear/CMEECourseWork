#!/usr/bin/env python3

"""Some functions emplifying the use of control statements"""

__author__ = 'Lucy Goodyear (lucy.goodyear19@imperial.ac.uk)'
__version__ = '0.0.1'

## imports ##
import sys # module to interface our program with the operating system
import doctest # import the doctest module

def even_or_odd(x=0): #if not specified, x should take value 0

    """Find whether a number x is even or odd.

    >>> even_or_odd(x=10)
    '10 is even!'

    >>> even_or_odd(5)
    '5 is odd!'

    whenever a float is provided, then the closest integer is used:
    >>> even_or_odd(3.2)
    '3 is odd!'

    in case of negative numbers, the positive is taken:
    >>> even_or_odd(-2)
    '-2 is even!'

    """

    # define the function to be tested

    if x % 2 == 0:
        return "%d is even!" % x
    return "%d is odd!" % x

##########

#def main(argv):
#       print(even_or_odd(22))
#       print(even_or_odd(33))
#       return 0

# if __name__ == "__main__":
#    """Makes sure the "main" function is called from the command line"""
#    status = main(sys.argv)
#    sys.exit(status)

doctest.testmod() # to run with embedded tests
