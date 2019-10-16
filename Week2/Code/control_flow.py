#!/usr/bin/env python3

"""Some functions emplifying the use of control statements"""
# docstrings are considered part of the running code (normal comments are
# stripped). Hence, you can access your docstring at run time.

__author__ = 'Lucy Goodyear (lucy.goodyear19@imperial.ac.uk)'
__version__ = '0.0.1'

## imports ##
import sys # module to interface our program with the operating system

def even_or_odd(x=0): #if not specified, x should take value 0
    """Find whether a number x is even or odd."""
    if x % 2 == 0: # the conditional if
        return "%d is even!" % x
    return "%d is odd!" % x

def largest_divisor_five(x=120):
    """Find which is the largest divisor of x among 2, 3, 4, 5."""
    largest = 0
    if x % 5 == 0:
        largest = 5
    elif x % 4 == 0: # means "else, if"
        largest = 4
    elif x % 3 == 0:
        largest = 3
    elif x % 2 == 0:
        largest = 2
    else: # when all other (if, elif) conditions are not met
        return "No divisor found for %d!" %x # each function can return a value or a variable.
    return "The largest divsisor of %d is %d" % (x, largest)

def is_prime(x=70):
    """Find whether an integer is prime."""
    for i in range(2, x): # "range" returns a sequence of integers
        if x % i == 0:
            print ("%d is not a prime: %d is a divisor" % (x, i))
            return False
    print("%d is a prime!" % x)
    return True

def find_all_primes(x=22):
    """Find all the primes up to x"""
    allprimes = []
    for i in range(2, x + 1):
        if is_prime(i):
            allprimes.append(i)
    print("There are %d primes between 2 and %d" % (len(allprimes), x))
    return allprimes
    
def main(argv):
    """The function that is called if this programme is run rather than imported.
    Prints some examples of the above functions.
    """
    print(even_or_odd(22))
    print(even_or_odd(33))
    print(largest_divisor_five(120))
    print(largest_divisor_five(121))
    print(is_prime(60))
    print(is_prime(59))
    print(find_all_primes(100))
    return 0

if __name__ == "__main__":
    """Makes sure the "main" function is called from the command line"""
    status = main(sys.argv)
    sys.exit(status)