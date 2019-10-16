#!/usr/bin/env python3

"""Illustrates the difference between importing a module and running it as the main programme."""

__author__ = 'Lucy Goodyear (lucy.goodyear19@imperial.ac.uk)'
__version__ = '0.0.1'

if __name__ == '__main__':
    print ('This program is being run by itself')
else:
    print('I am being imported from another module')

print("This module's name is: " + __name__)