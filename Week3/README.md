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

R packages:
- ggplot2
- reshape2
- ddplyr
- tidyr
- maps
- lattice

Python v.3.7.4

Python packages:
- pandas
- scipy


## List of scripts

1. [basic_io](#1.-basic_io)
2. [control_flow](#2.-control_flow)
3. [break](#3.-break)
4. [next](#4.-next)
5. [boilerplate](#5.-boilerplate)
6. [TreeHeight](#6.-TreeHeight)
7. [Vectorize1(R)](#7.-Vectorize1(R))
8. [preallocate](#8.-preallocate)
9. [apply1](#9.-apply1)
10. [apply2](#10.-apply2)
11. [sample](#11.-sample)
12. [Ricker](#12.-Ricker)
13. [Vectorize2(R)](#13.-Vectorize2(R))
14. [Vectorize1(python)](#14.-Vectorize1(python))
15. [Vectorize2(python)](#15.-Vectorize2(python))
16. [Vectorize_Compare(bash)](#16.-Vectorize_Compare(bash))
17. [try](#17.-try)
18. [browser](#18.-browser)
19. [TAutoCorr](#19.-TAutoCorr)
20. [autocorrelation](#20.-autocorrelation)
21. [DataWrang](#21.-DataWrang)
22. [DataWrangTidy](#22.-DataWrangTidy)
23. [PP_Lattice](#23.-PP_Lattice)
24. [Girko](#24.-Girko)
25. [MyBars](#25.-MyBars)
26. [PlotLin](#26.-PlotLin)
27. [PP_Regress](#27.-PP_Regress)
28. [PP_Regress_Loc](#28.-PP_Regress_Loc)
29. [Mapping](#29.-Mapping)
30. [get_TreeHeight(R)](#30.-get_TreeHeight)
31. [get_TreeHeight(python)](#31.-get_TreeHeight)
32. [run_get_TreeHeight(bash)](#32.-run_get_TreeHeight)


### 1. basic_io

A simple .R script to illustrate R input-output. It loads data from a csv, writes data to a csv and then makes changes to that csv.

###  2. control_flow

A .R script that illustrates different control flow tools.

### 3. break

A .R script that uses ```break``` to break out of a simple loop.

### 4. next

A .R script that uses next to ```skip``` to the next iteration of a loop. The loop checks which numbers between 1 and 10 are odd by using the modulo operation and then all odd numbers are printed. 

### 5. boilerplate

A boilerplate .R script with an example function and test print outs.

### 6. TreeHeight

A .R script that contains a function that calculates heights of trees given the distance of each tree from its base and angle to its top, using the trigonometric formula. This function is called on a sample pair of parameters and then on a loaded data set of trees, the results of which are saved into a csv.

### 7. Vectorize1(R)

A .R script that contains two methods for calculating the sum of a matrix. The first is a function, SumAllElements, containing a for loop and the second is the inbuilt 'sum' function. The prints show which method is faster.

### 8. preallocate

A .R script that contains two methods of creating a matrix, one without using preallocation (function, f) and one using preallocaiton (function, g). The times taken for each function to run are printed to allow comparison.

### 9. apply1

A .R practice script looking at using apply on some of R's inbuilt functions: calculating the means and variance of each row and the means
of each column of a random matrix.

### 10. apply2

A .R script that contains a function that takes one parameter, which, if the sum is greater than 0, is returned multipled by 100. The apply function is used to apply this function to a matrix by row.

### 11. sample

A .R script that contains 6 functions to test the speed of 5 different methods of calculating means. The first function, myexperiment, samples the data and calculates the mean of that sample, the other functions run "num" iterations over myexperiment to generate the means of "num" samples. The functions are then run on identical parameters and timed, with the time taken for each being printed to screen.

### 12. Ricker

A .R script that contains a function called Ricker that runs a simulation of the Ricker model and returns a vector of length generations. The script also plots a line graph showing the model for ten generations.

### 13. Vectorize2(R)

A .R script that contains two functions that run two different simulations of the stochastic (with Gaussian fluctuations) Ricker equation. One contains two for loops, stochrick, the other, stochrickvect, has been vectorised. The times taken for the two models to run are compared at the end.

### 14. Vectorize1(python)

A .py script that contains two methods for calculating the sum of a matrix. The first is a function, SumAllElements, containing a for loop and the second is the inbuilt 'sum' function. The prints show which method is faster.

### 15. Vectorize2(python)

A .py script that contains two functions that run two different simulations of the stochastic (with Gaussian fluctuations) Ricker equation. One contains two for loops, stochrick, the other, stochrickvect, has been vectorised. The times taken for the two models to run are compared at the end.

### 16. Vectorize_Compare(bash)

A .sh script that runs the four Vectorize scripts (2 R scripts and 2 python scripts) that run loops and vectorized versions
of blocks of code, comparing the times for each script.

### 17. try

A .R script to practise catching errors and debugging. It contains one function with a custom made error.

### 18. browser

A practice .R script that inserts a breakpoint into the code and enters browser mode.

### 19. TAutoCorr

A .R script that loads and plots a dataset of temperatures by year in Key West. It creates two lists offset from each other by one year, which allows the correltaion to be calculated for successive years. It then calculates the correlation coefficient for 10,000 random permutations of the temperature in order to compare significance.

### 20. autocorrelation

A .Rnw script that produces a pdf from latex code with the embedded TAutoCorr R script. It includes the graph of the temperatures in Key West data set, the autocorrelation results, including a histogram of the frequency of correlation results over the 10,000 random permutations, and a summary of the results and conclusions drawn. A pdf of the same name and contents is stored in the **Results** directory.

### 21. DataWrang

A .R script that wrangles a dataset called "PoundHillData" found in the **Data** directory. It processes the data to turn it into a format that we can manipulate and visualise.

### 22. DataWrangTidy

A .R script based on DataWrang.R (described above). The ```reshape2``` package has been replaced with the ```dplyr``` package and corresponding commands have been modified accordingly.

### 23. PP_Lattice

A .R script that uses a dataset containing predator-prey body size information to plot 3 lattice graphs showing predator and prey masses and the ratio between them by types of food interaction. It also calculates mean and median for the above subsets and saves the results to a csv.

### 24. Girko

A .R script that plots Girko's circular law and saves figure as a pdf. It first builds a function that returns an ellipse then and produces a N by N matrix containing randomly normally distributed values. The eigenvalues are calulcated for this matrix and then plotted on an Argand diagram (real numbers on the x-axis and imaginary numbers on the y-axis). Onto this Argand diagram, adds an ellipe with a radius of square root of N to show how the points fit into the shape of this ellipse.

### 25. MyBars

A .R script that loads data from a .txt file and plots it as three line ranges (using ggplot2) with annotations for particular values.

### 26. PlotLin

A .R script that performs a linear regression on some sample data, plots the data with the regression line and then annotates the plot with a mathematical equation. This is then saved as pdf into the **Results** directory.

### 27. PP_Regress

A .R script that plots graphs from predator and prey size data, including linear regressions, differentiated by predator lifestage, facected by type of feeding interaction and saves to pdf. It also calculates linear regression results corresponding to the lines fitted in the figure and saves as csv demlimited table.

### 28. PP_Regress_Loc

A .R script that calculates linear regression model for predator and prey masses separated by type of feeding interaction, predator lifestage and location and then saves results as csv demlimited table.

### 29. Mapping

A .R script that plots a map showing spaital spread of species from a loaded dataset. It plots an empty world map using the maps package and adds data points from the dataset, which contains species and corresponding longitudes and latitudes. It contains comments on possible biases.

### 30. get_TreeHeight(R)

This .R script contains a function, TreeHeight, that calculates heights of trees given the distance of each tree from its base and angle to its top, using the trigonometric formula. This function is called on data from a csv file, which has been provided by the user as a command line argument, the results of which are added as an additional column to the dataframe. The new dataframe is saved as a csv, the name of which includes the basename of the input csv.

### 31. get_TreeHeight(python)

A .py script that contains a function, TreeHeight, which calculates heights of trees given the distance of each tree from its base and angle to its top, using the trigonometric formula. In the main function, the TreeHeight function is called  on data from a csv, which has previously been provided by the user as a command line argument and then loaded as a pandas dataframe. The returns from the TreeHeight function call are added as an additional column to the dataframe, which is saved as a new csv file. The main function also strips the csv command line argument of its relative path and extension and uses that basename as the name of the resulting csv.

### 32. run_get_TreeHeight(bash)

A .sh script that runs an R-script and a python script that calculate tree heights for a data set provided externally to the two scripts. Both scripts produce the same resultant csv file, which is saved into the **Results** directory.