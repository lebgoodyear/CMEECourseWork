#!/usr/bin/env python3

"""Some mathematical functions showing different conditionals"""

__author__ = 'Lucy Goodyear (lucy.goodyear19@imperial.ac.uk)'
__version__ = '0.0.1'

## Imports
import sys

def foo_1(x):
    """Finds the square root"""
    return x ** 0.5

def foo_2(x, y):
    """Returns the largest of two numbers"""
    if x > y:
        return x
    return y

def foo_3(x, y, z):
    """Returns 3 numbers in a different order"""
    if x > y:
        tmp = y
        y = x
        x = tmp
    if y > z:
        tmp = z
        z = y
        y = tmp
    return [x, y, z] ## if z < x, run again to get the numbers in numerical order

def foo_4(x):
    """Calculates the factorial of x, multiplying from 1 up to x"""
    result = 1
    for i in range(1, x + 1):
        result = result * i
    return result

def foo_5(x):
    """Recursively calculates the factorial of x"""
    if x == 1:
        return 1
    return x * foo_5(x - 1)

def foo_6(x):
    """Calculates the factorial of x, multiplying from x down to 1"""
    facto = 1
    while x >= 1:
        facto = facto * x
        x = x - 1
    return facto

def main(argv):
    """Some examples using the functions above"""
    print(foo_1(5))
    print(foo_1(25))
    print(foo_2(8, 23))
    print(foo_2(19, 10))
    print(foo_3(5, 8, 2))
    print(foo_3(17, 3, 12))
    print(foo_4(5))
    print(foo_4(3))
    print(foo_5(5))
    print(foo_5(3))
    print(foo_6(5))
    print(foo_6(3))
    return 0

if __name__ == "__main__":
    """Makes sure the "main" function is called from the command line"""
    status = main(sys.argv)
    sys.exit(status)
