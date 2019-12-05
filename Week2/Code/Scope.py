#!/usr/bin/env python3

"""
Contains five separate scripts exemplifying variable scope. 
Global and local variables are printed at various stages, 
inside and outside of functions.
"""

__author__ = 'Lucy Goodyear (lucy.goodyear19@imperial.ac.uk)'
__version__ = '0.0.1'


## Script 1

_a_global = 10 # a global variable

if _a_global >= 5:
    _b_global = _a_global + 5 # also a global variable

def a_function():
    """
    Defines 2 variables within the function and 
    another variable a loop within the function, 
    all of which are local variables.
    """

    _a_global = 5 # a local variable

    if _a_global >= 5:
        _b_global = _a_global + 5 # also a local variable
    
    _a_local = 4

    print("Inside the function, the value of _a_global is ", _a_global)
    print("Inside the function, the value of _b_global is ", _b_global)
    print("Inside the function, the value of _a_global is ", _a_local)

    return None

# call the function
a_function()

print("Outside the function, the value of _a_global is ", _a_global)
print("Outside the function, the value of _b_global is ", _b_global)


## Script 2

_a_global = 10 # a global variable

def a_function():
    """defines a local variable within the function"""
    _a_local = 4

    print("Inside the function, the value of _a_local is ", _a_local)
    print("Inside the function, the value of _a_global is ", _a_global)

    return None

# call the function
a_function()

print("Outside the function, the value of _a_global is", _a_global)


## Script 3

_a_global = 10 # a global variable

print("Outside the function, the value of _a_global is", _a_global)

def a_function():
    """defines two variables to observe variable scope"""
    global _a_global # define variable as a gloabl variable
    _a_global = 5 # reassign global variable within function
    _a_local = 4
    print("Inside the function, the value of _a_global is", _a_global)
    print("Inside the function, the value of _a_global is", _a_local)
    return None

# call the function
a_function()

print("Outside the function, the value of _a_globa is now", _a_global)


## Script 4

def a_function():
    """contains a variable and a nested function to change that variable"""
    _a_global = 10

    def _a_function2():
        """reassigns a variable within a function"""
        global _a_global # define variable as global variable
        _a_global = 20 # reassign global variable within nested function
    
    print("Before calling a_function, value of _a_global is ", _a_global)

    _a_function2() # call one function inside the other function

    print("After calling _a_functio2, value of _a_global is ", _a_global)

    return None

# call the function
a_function()

print("The value of a_global in main workspace / namespace is ", _a_global)


## Script 5

_a_global = 10 # a global variable

def a_function():
    """contains a nested function to change a global variable"""

    def _a_function2():
        """reassigns a global variable"""
        global _a_global
        _a_global = 20

    print("Before calling a_function, value of _a_global is ", _a_global)

    _a_function2() # call one function inside the other function

    print("After calling _a_function2, value of _a_global is", _a_global)

# call the function
a_function()

print("The value of _a_global in main workspace / namespace is ", _a_global)