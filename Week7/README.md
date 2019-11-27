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

Python packages:
- networkx
- pandas
- scipy
- numpy
- re

IPython 7.8.0

R v.3.6.1

R packages:

- igraph

All code has been created for Mac so there may be a few differences in commands with respect to Linux.

## List of scripts
1. [LV1](#1.-LV1)
2. [LV2](#2.-LV2)
3. [Profileme](#3.-Profileme)
4. [Profileme2](#4.-Profileme2)
5. [timeitme](#5.-timeitme)
6. [LV3](#6.-LV3)
7. [LV4](#7.-LV4)
8. [run_LV](#8.-run_LV)
9. [DrawFW](#9.-DrawFW)
10. [Nets(R)](#10.-Nets(R))
11. [Nets(python)](#10.-Nets(python))
12. [regexs](#11.-regexs)
13. [blackbirds](#12.-blackbirds)
14. [TestR(R)](#14.-TestR(R))
15. [TestR(python)](#15.TestR(python))
16. [using_os](#16.-using_os)
17. [fmr](#17.-fmr)
18. [run_fmr_R](#18.-run_fmr_R)
19. [MyFirstJupyterNb](#19.-MyFirstJupyterNb)

### 1. LV1

A .py script that uses numerical integration to solve the Lotka-Volterra model. It contains one function that calculates the growth rate of resource and consumer populations at a given time step one main function that contains the rest of the script. Initial parameters are then set and the scipy integrate subpackage is used to solve the Lotka-Volterra system. The results are plotted in two different graphs, showing the change of the two population densities over time and also the change in the two population densities with respect to each other.

### 2. LV2

A .py script that uses numerical integration to solve the Lotka-Volterra model, including carrying capacity K, and allows user inputs for certain parameters. It contains one function that calculates the growth rate of resource and consumer populations at a given time step and one main function that contains the rest of the script. Within the main programme, this function is redefined as a partial to allow the fixed parameters to be passed to the function. Initial parameters are inputted by user, otherwise defaults are used, and the scipy integrate subpackage is used to solve the Lotka-Volterra system. The results are plotted in two different graphs, showing the change of the two population densities over time and also the change in the 
two population densities with respect to each other.


### 3. Profileme

A .py script that contains three functions for practising profiling. One function, my_squares, squares the input, one, my_join, joins string together and the third, run_my_funcs, runs the other two functions. A sample of run_my_funcs is called at the end to allow profiling.

### 4. Profileme2

A .py script that contains improved versions of the three functions from Profileme for practising profiling. One function, my_squares, squares the input using a list comprehension (there is also a commented out version that uses preallocation, which is slower than the list comprehension), one, my_join, joins string together using an explicit string concatenation and the third, run_my_funcs, runs the other two functions as before. A sample of run_my_funcs is called at the end to allow profiling.

### 5. timeitme

A .ipy script that compares the speed of for loops and list comprehensions and the join method for strings by importing the functions from Profileme.py and Profileme2.py and using the ipython timeit function. It also compares this to a simpler approach using time.time().

### 6. LV3

A .py script that uses a discrete time for loop to solve the Lotka-Volterra model including carrying capacity K, and allows user inputs for certain parameters. It contains one function that calculates population densities of resource and consumer populations at a given time step by running a for loop over the time steps and calculating the populations densities at each step, and one main function that contains the rest of the script. Initial parameters are inputted by user (otherwise defaults are used) and passed to the function, which solves the Lotka-Volterra system at discrete time intervals. The results are plotted in two different graphs, showing the change of the two population densities over time and also the change in the two population densities with respect to each other.

### 7. LV4

A .py script that uses a discrete time for loop to solve the Lotka-Volterra model including carrying capacity K and Gaussian Fluctuation E, and allows user inputs for certain parameters. Contains one function that calculates population densities of resource and consumer populations at a given time step by running a for loop over the time steps and calculating the populations densities at each step, and one main function that contains the rest of the script. Initial parameters are inputted by user (otherwise defaults are used) and passed to the function, which solves the Lotka-Volterra system at discrete time intervals. The results are plotted in two different graphs, showing the change of the two population densities over time and also the change in the two population densities with respect to each other.

### 8. run_LV

A .py script that profiles four scripts that solve the Lotka-Volterra model, comparing the time taken for the ten longest calls in each.

### 9. DrawFW

A .py script that represents a sample food web network as an adjacency list and plots the network using networkx, where the size of the node represents the body mass of the species. It contains one function that generates a random adjacency list, containing the Ids of species that interact (based on comparison to the connectance probability). Body sizes are generated for each species, saved in an array and then visualised using matplotlib. Networkx is then used to plot the food web network.

### 10. Nets(R)

A .R script that visualizes the QMEE CDT collaboration network using igraph, coloring the the nodes by the type of node (organization type: "University","Hosting Partner", "Non-hosting Partner") and weighting the edges by number of PhD students. This was not wriiten by me but used as a basis for the python script of the same name.

### 11. Nets(python)

A .py script that visualizes the QMEE CDT collaboration network using networkx, coloring the the nodes by the type of node (organization type: "University","Hosting Partner", "Non-hosting Partner") and weighting the edges by number of PhD students. This is a python version of the R-script of the same name.

### 12. regexs

A .py script containing various examples using regex to search for matches in strings, text files and also a webpage.


### 13. blackbirds

A .py script that uses regex to capture Kingdom, Phylum and Species name from a text file of blackbird taxonomic information. It prepares the data by reading the file, replacing tabs and newlines with spaces and removing any non_ASCII symbols. Regex is then used to print Kingdom, Phylum and Species name in a list of tuples.

### 14. TestR(R)

A simple .R script that prints a string.

### 15. TestR(python)

A .py script that runs the test R script of the same name.

### 16. using_os

A .py script that produces a list of files and directories from your home directory using the subprocess.os module. It creates three separate lists: files and directories starting with an upper case "C"; files and directories starting with an upper case "C" or a lower case "c"; and finally only directories starting with an upper case "C" or a lower case "c".

### 17. fmr

A .R script that plots log(field metabolic rate) against log(body mass) for the Nagy et al 1999 dataset to a file fmr.pdf. This script was not written by me and is only used for practicing running R scripts from python in the python script run_fmr_R.py.


### 18. run_fmr_R

A .py script that uses the subprocess module to run an R-script that produces a pdf. Prints the R output to screen and includes try and except to kill the process if it takes longer than 30 seconds and also includes an if statement to print whether the R-script ran successfully.

### 19. MyFirstJupyterNb

A Jupyter Notebook (.ipynb) practising various Jupyter capabilities, including symbolic variables and differentiation.