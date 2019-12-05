# CMEE Coursework Week 2 Repository

*Author: Lucy Goodyear*  
*Created: 11/10/19*

This repository contains all the CMEE coursework from Week 2 on Python.

**Code** contains the scripts/programs.

**Data** is the data needed to run those scripts.

**Results** is where the outpout from those scripts is sent to.

**Sandbox** is a miscellaneous directory containing experimental code and data.

## Requirements

Python v.3.7

Packages:

- re
- pickle

All code has been created for Mac so there may be a few differences in commands with respect to Linux.

## List of scripts
1. [basic_io1](#1.-basic.io1)
2. [basic_io2](#2.-basic_io2)
3. [basic_io3](#3.-basic_io3)
4. [basic_csv](#4.-basic_csv)
5. [cfexercises1](#5.-cfexercises1)
6. [loops](#6.-loops)
7. [cfexercises2](#7.-cfexercises2)
8. [oaks](#8.-oaks)
9. [scope](#9.-scope)
10. [boilerplate](#10.-boilerplate)
11. [using_name](#11.-using_name)
12. [sysargv](#12.-sysargv)
13. [control_flow](#13.-control_flow)
14. [lc1](#14.-lc1)
15. [lc2](#15.-lc2)
16. [dictionary](#16.-dictionary)
17. [tuple](#17.-tuple)
18. [test_control_flow](#18.-test_control_flow)
19. [debugme](#19.-debugme)
20. [align_seqs](#20.-align_seqs)
21. [align_seqs_fasta](#21.-align_seqs_fasta)
22. [align_seqs_better](#22.-align_seqs_better)
23. [oaks_debugme](#23.-oaks_debugme)

### 1. basic_io1

A .py script that uses a for loop to read from a .txt file, printing the content first with and then without blank lines. Requires testweek2.txt from the directory **Data**.

### 2. basic_io2

A .py script that uses a for loop to write the numbers 0-99 into a .txt file with a new line between each number. This .txt file is saved in **Results**.

### 3. basic_io3

A .py script to store a dictionary for later use using the pickle package.

### 4. basic_csv

A .py script that reads and writes .csv files. The script reads a csv (using the csv package) and then prints it as a list, explicitly stating the species name after each row (on a new line). The script then writes a subset of each row from the first csv into a different csv. Requires testcsv.csv from the directory **Data** and saves the new .csv file (bodymass.csv) into the **Results** directory.

### 5. cfexercises1

A .py script that contains six mathematical functions showing different conditionals, including doctests for each function. Main function calls all six mathematical functions on sample parameters.

### 6. loops

A .py script to practice various for and while loops.

### 7. cfexercises2

A .py script combining loops and conditionals, printing the string 'hello' each time a condition is met.

### 8. oaks

A .py script that contains one function, is_an_oak, which finds the taxa of oak trees from a list of species by returning `True` if `name` parameter starts with 'quercus '. Oaks are saved to two sets (as written and all in capitals) using both for loops and list comprehensions with the is_an_oak function. In all, four sets are printed.

### 9. scope

A .py containing five separate scripts exemplifying variable scope. Global variables are printed at various stages, inside and outside of functions.

### 10. boilerplate

A .py boilerplate for a basic programme, containing docstrings, imports, arguments, functions and an if statement to ensure that the function is called from the command line.

### 11. using_name

A .py script illustrating the difference between importing a module and running it as the main programme.

### 12. sysargv

A short .py script illustating how sys.argv works when run with different variables.

### 13. control_flow

A .py programme with some functions emplifying the use of control statements, including some examples as part of the main programme.

### 14. lc1

A .py script containing some list comprehensions and for loops to print different attributes of birds from a tuple of tuples.

### 15. lc2

A .py script that uses list comprehensions and loops to identify months with high and low rainfall from a given tuple of tuples.

### 16. dictionary

A .py scipt that populates a dictionary from a given list of tuples.

### 17. tuple

A .py script that prints data from a tuple of tuples in a more readable format.

### 18. test_control_flow

A .py programme based on [control_flow](#13.-control_flow) but containing only the even_or_odd function and with added doctests.

### 19. debugme

A .py programme containing a practice example for using the debugger. The function has a written-in error for the debugger to detect.

### 20. align_seqs

A .py programme that calculates the best alignment of two DNA sequences. It contains one function (calculate_scores), which computes a score by returning the number of matches starting from an arbitrary startpoint (chosen by user). The first alignment found with the best score overall is saved to a csv file.

### 21. align_seqs_fasta

A .py that calculates the best alignment of any two DNA sequences, with defaults if no user input is given. It contains the same function as above along with a short script to identify whether or not user inputs have been given. The first alignment found with the best score overall is saved to a csv file.

### 22. align_seqs_better

A .py that calculates the best alignment of any two DNA sequences, with defaults if no user input is given. It contains one function (calculate_scores), which computes a score by returning the number of matches starting from an arbitrary startpoint (chosen by user), as well as along with a short script to identify whether or not user inputs have been given. It also saves all combinations with the best alignment scores into a csv file.

### 23. oaks_debugme

A .py programme that locates oaks by genus from given data in a csv file. It contains two functions: one (is_an_oak) that returns `True` if the genus is exactly 'quercus' and another (main) that prints all taxa and searches for oaks, printing 'FOUND AN OAK!' when one is located and printing them into a new .csv file (with the species, genus headers) called JustOaksData.csv, saved in the Results directory. It requires the TestOaksData.csv located in the Data directory of Week2.