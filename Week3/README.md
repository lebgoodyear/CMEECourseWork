# CMEE Coursework Week 3 Repository

*Author: Lucy Goodyear*  
*Created: 14/10/19*

This repository contains all the CMEE coursework from Week 3 on R.

**Code** contains the scripts/programs.

**Data** is the data needed to run those scripts.

**Results** is where the outpout from those scripts is sent to.

**Sandbox** is a miscellaneous directory containing experimental code and data.

## Requirements

R v.3.6.1

## List of scripts

1. [basic_io](#1.-basic_io)
2. [control_flow](#2.-control_flow)
3. [break](#3.-break)
4. [next](#4.-next)
5. [boilerplate](#5.-boilerplate)
6. [TreeHeight](#6.-TreeHeight)
7. [Vectorize1](#7.-Vectorize1)
8. [preallocate](#8.-preallocate)
9. [apply1](#9.-apply1)
10. [apply2](#10.-apply2)
11. [sample](#11.-sample)
12. [Ricker](#12.-Ricker)
13. [Vectorize2](#13.-Vectorize2)
14. [try](#14.-try)
15. [browser](#15.-browser)
16. [TAutoCorr](#16.-TAutoCorr)
17. [autocorrelation](#17.-autocorrelation)
18. [DataWrang](#18.-DataWrang)
19. [DataWrangTidy](#19.-DataWrangTidy)
20. [PP_Lattice](#20.-PP_Lattice)
21. [Girko](#21.-Girko)
22. [MyBars](#22.-MyBars)
23. [PlotLin](#23.-PlotLin)
24. [PP_Regress](#24.-PP_Regress)
25. [PP_Regress_Loc](#25.-PP_Regress_Loc)
26. [Mapping](#26.-Mapping)


### 1. basic_io

A simple .R script to illustrate R input-output. It runs line by line and checks inputs and outputs to understand what is happening.

###  2. control_flow

A .R script that practises different control flow tools.

### 3. break

A .R script that uses ```break``` to break out of a simple loop.

### 4. next

A .R script that uses next to skip to the next iteration of a loop. The loop checks which numbers between 1 and 10 are odd by using the modulo operation and then all odd numbers are printed. 

### 5. boilerplate

A boilerplate .R script with a boilerplate function and test print outs.

### 6. TreeHeight

This .R script contains a function that calculates heights of trees given the distance of each tree from its base and angle to its top, using the trigonometric formula. This function is called on a sample pair of parameters and then on a loaded data set of trees, the results of which are saved into a csv.

### 7. Vectorize1

A .R script that contains two methods for calculating the sum of a matrix. The first uses a for loop and the second the inbuilt 'sum' function. The prints show which method is faster.

### 8. preallocate

A .R script that contains two methods of creating a matrix, one without using preallocation (function, f) and one using preallocaiton (function, g). The times taken for each function to run are printed to allow comparison.

### 9. apply1

A .R practice script looking at using apply on some of R's inbuilt functions.

### 10. apply2

A .R practice script looking at using apply on my own function.

### 11. sample

A .R script that generates 50 normal random numbers and runs a function to randomly select a smaple of those. If the sample contains more than 30 unique elements, the mean is then calculated and printed for each sample. 100 iterations are done this function, first using vectorisation and then a for loop.

### 12. Ricker

A .R script that runs a simulation of the Ricker model and plots a line graph showing the model for ten generations.

### 13. Vectorize2

A .R script that runs two simulations of the stochastic (with Gaussian fluctuations) Ricker equation. One contains two for loops, the other has been vectorised. The times taken for the two models to run are compared at the end.

### 14. try

A .R script to practise catching errors and debugging. It contains one function with a custom made error.

### 15. browser

A practice .R script that inserts a breakpoint into the code and enters browser mode.

### 16. TAutoCorr

A .R script that loads and plots a dataset of temperatures by year in Key West. It creates two lists offset from each other by one year, which allows the correltaion to be calculated for successive years. It then calculates the correlation coefficient for 10,000 random permutations of the temperature in order to compare significance.

### 17. autocorrelation

A .Rnw script that produces a pdf from latex code with the embedded TAutoCorr R script. It includes the graph of the temperatures in Key West data set and the autocorrelation results as well as a summary of the results and conclusions drawn.

### 18. DataWrang

A .R script that wrangles a dataset called "PoundHillData" found in the **Data** directory. It processes the data to turn it into a format that we can manipulate and visualise.

### 19. DataWrangTidy

A .R script based on DataWrang.R (described above). The ```reshape2``` package has been replaced with the ```dplyr``` package and corresponding commands have been modified accordingly.

### 20. PP_Lattice

A .R script that uses a dataset containing predator-prey body size information to plot 3 lattice graphs showing predator and prey masses and the ratio between them by types of food interaction. It also calculates mean and median for the above subsets and saves the results to a csv.

### 21. Girko

A .R script that plots Girko's circular law and saves figure as a pdf. It first builds a function that returns an ellipse then and produces a N by N matrix containing randoly normally distributed values. The eigenvalues are calulcated for this matrix and then plotted on an Argand diagram with real numbers on the x-axis and imaginary numbers on the y-axis. Onto this Argand diagram, add an ellipe with a radius of square root of N to show how the points fit into the shape of this ellipse.

### 22. MyBars

A .R script that loads data from a .txt file and plots it as three line ranges (using ggplot2) with annotations for particular values.

### 23. PlotLin

A .R script that performs a linear regression on some sample data, plots the data with the regression line and then annotates the plot with a mathematical equation. This is then saved as pdf into the **Results** directory.

### 24. PP_Regress

A .R script that plots graphs from predator and prey size data, including linear regressions, differentiated by predator lifestage, facected by type of feeding interaction and saves to pdf. It also calculates linear regression results corresponding to the lines fitted in the figure and saves as csv demlimited table.

### 25. PP_Regress_Loc

### 26. Mapping

A .R script that plots a map showing spaital spread of species from a loaded dataset. It plots an empty world map using the maps package and adds data points from the dataset, which contains species and corresponding longitudes and latitudes. it contains comments on possible biases.


