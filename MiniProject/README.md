# CMEE MiniProject Repository

*Author: Lucy Goodyear*  
*Created: 06/12/19*

This repository contains all files needed for my MiniProject.

**Code** contains the scripts/programs.

**Data** is the data needed to run those scripts.

**Results** is where the output from those scripts is sent to.

## Requirements

Python v.3.7.4

Python packages:
- pandas v.0.24.2
- numpy v.1.18.1 
- lmfit v.0.9.14

R v.3.6.1

R packages:

- ggplot2 v.3.2.1
- tidyverse v.1.3.0
- DescTools v.0.99.32
- janitor v.1.2.1

All code has been created for Mac so there may be a few differences in commands with respect to Linux. MacTeX or equivalent is required for LaTeX related files.

## List of scripts
1. [DataPrep](#1.-DataPrep)
2. [fit_functions](#2.-fit_functions)
3. [Fit_Models](#3.-Fit_Models)
4. [Plot_Analyse_Models](#4.-Plot_Analyse_Models)
5. [MiniProject](#5.-MiniProject)
6. [run_MiniProject](#6.-run_MiniProject)

### 1. DataPrep

A .R script to do intial plotting and prepare the data for fitting.

### 2. fit_functions

A .py module that contains all the necessary functions for Fit_Models to run.

### 3. Fit_Models

A .py script to fit a polynomial model and the general functional response model to the data. It imports fit_functions.

### 4. Plot_Analyse_Models

A .R script to plot the models of the data and conduct analysis.

### 5. MiniProject

A .tex and a .bib file used to generate the pdf report.

### 6. run_MiniProject

A .sh file that glues the workflow together by running all the above scripts. The whole project can be executed by running this one script from the command line.


