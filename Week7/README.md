# CMEE Coursework Week 7 Repository

*Author: Lucy Goodyear*  
*Created: 13/11/19*

This repository contains all the CMEE coursework from Week 7 on Python.

**Code** contains the scripts/programs.

**Data** is the data needed to run those scripts.

**Results** is where the outpout from those scripts is sent to.

**Sandbox** is a miscellaneous directory containing experimental code and data.

## Requirements

Python v.3.7

All code has been created for Mac so there may be a few differences in commands with respect to Linux.

## List of scripts
1. [LV1](#1.-LV1)
2. [LV2](#2.-LV2)
3. [Profileme](#3.-Profileme)
4. [Profileme2](#4.-Profileme2)
5. [timeitme](#5.-timeitme)
6. [LV3](#6.-LV3)
7. [LV4](#7.-LV4)
8. [LV_run](#8.-LV_run)
9. [DrawFW](#9.-DrawFW)
10. [Nets](#10.-Nets)
11. [regexs](#11.-regexs)
12. [blackbirds](#12.-blackbirds)
13. [using_os](#13.-using_os)
14. [run_fmr_R](#12.-run_fmr_R)

### 1. LV1

A .py script that uses numerical integration to solve the Lotka-Volterra model. It contains one function that calculates the growth rate of resource and consumer populations at a given time step. Initial parameters are then set and the scipy integrate subpackage is used to solve the Lotka-Volterra system. The results are plotted in two different graphs, showing the change of the two population densities over time and also the change in the two population densities with respect to each other.

### 2. LV2



### 3. Profileme

A .py script that contains three functions for practising profiling. One function, my_squares, squares the input, one, my_join, joins string together and the third, run_my_funcs, runs the other two functions. A sample of run_my_funcs is called at the end to allow profiling from the command line or from within python3/ipython.

### 4. Profileme2

A .py script that contains improved versions of the three functions from 
Profileme for practising profiling. One function, my_squares, squares the input using a list comprehension (there is also a commented out version that uses preallocation, which is slower than the list comprehension), one, my_join, joins string together using an explicit string concatenation and the third, run_my_funcs, runs the other two functions as before. A sample of run_my_funcs is called at the end to allow profiling from the command line or from within python3/ipython.

### 5. timeitme

A .ipy script that compares the speed of for loops and list comprehensions and the join method for strings by importing the functions from Profileme.py and Profileme2.py and using the ipython timeit function. It also compares this to a simpler approach using time.time().

### 6. LV3



### 7. LV4



### 8. LV_run



### 9. DrawFW

A .py script that represents a sample food web network as an adjacency list and plots the network using networkx, where the size of the node represents the body mass of the species. It contains one function that generates a random adjacency list, containing the Ids of species that interact (based on comparison to the connectance probability). Body sizes are generated for each species, saved in an array and then visualised using matplotlib. Networkx is then used to plot the food 
web network.

### 10. Nets



### 11. regexs

A .py script containing various examples using regex to search for matches in strings, text files and also a webpage.


### 12. blackbirds

A .py script that uses regex to capture Kingdom, Phylum and Species name from a text file of blackbird taxonomic information. It prepares the data by reading the file, replacing tabs and newlines with spaces and removing any non_ASCII symbols. Regex is then used to print Kingdom, Phylum and Species name in a list of tuples.

### 13. using_os

A .py script that produces a list of files and directories from your home directory using the subprocess.os module. It creates three separate lists: files and directories starting with an upper case "C"; files and directories starting with an upper case "C" or a lower case "c"; and finally only directories starting with an upper case "C" or a lower case "c".


### 14. run_fmr_R