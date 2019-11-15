#!/usr/bin/env python3

"""
 Contains three functions for practising profiling. One function, 
 my_squares, squares the input, one, my_join, joins string together 
 and the third, run_my_funcs, runs the other two functions. A sample
 of run_my_funcs is called at the end to allow profiling from the 
 command line or from within python3/ipython.

"""

__author__ = 'Lucy Goodyear (lucy.goodyear19@imperial.ac.uk)'
__version__ = '0.0.1'

def my_squares(iters):
    ''' squares input using a for loop

    Parameters:
        iters(int) : range over which squaring takes place
    
    Returns:
        out(list) : list of squared numbers from iters

    '''
    out = []
    for i in range(iters):
        out.append(i ** 2)
    return out

def my_join(iters, string):
      ''' joins strings together in range iters

    Parameters:
        iters(int) : range over which squaring takes place
        string(str) : specified string
    
    Returns:
        out(str) : concatenated string from string inputs
        
    '''
    out = ''
    for i in range(iters):
        out += string.join(", ")
    return out

def run_my_funcs(x, y):
     '''prints the inputs and runs the my_squares and my_join functions

    Parameters:
        x(int) : range over which squaring takes place
        y(string) : specified string
    
    Outputs:
        print(x ,y)(int, str) : prints the inputs
        
    '''
    print(x, y)
    my_squares(x)
    my_join(x, y)
    return 0

run_my_funcs(10000000, "My String")