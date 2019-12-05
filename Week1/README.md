# CMEE Coursework Week 1 Repository

*Author: Lucy Goodyear*  
*Created: 10/10/19*

This repository contains all the CMEE coursework from Week 1, covering bash scripting, LaTeX and Git, and includes the following directories:

**Code** contains the scripts/programs.

**Data** is the data needed to run those scripts.

**Results** is where the outpout from those scripts is sent to.

**Sandbox** is a miscellaneous directory containing experimental code and data.

## Requirements

All code has been created for Mac so there may be a few differences in commands with respect to Linux. MacTeX or equivalent is required for LaTeX related files and imagemagick is needed for the tiff2png script to run.


## List of scripts
1. [UnixPrac1](#1.UnixPrac1)
2. [boilerplate](#2.-boilerplate)
3. [tabtocsv](#3.-tabtocsv)
4. [variables](#4.-variables)
5. [MyExampleScript](#5.-MyExampleScript)
6. [Countlines](#6.-CountLines)
7. [ConcatenateTwoFiles](#7.-ConcatenateTwoFiles)
8. [tiff2png](#8.-tiff2png)
9. [csvtospace](#9.-csvtospace)
10. [FirstExample](#10.-FirstExample)
11. [FirstBiblio](#11.-FirstBiblio)
12. [CompileLaTeX](#12.-CompileLaTeX)


### 1. UnixPrac1

A .txt containing a collection of single line commands to perform different counts on a set of .fasta files containing genetic code.

### 2. boilerplate

This is my first .sh script, printing "This is a shell script!".

### 3. tabtocsv

This .sh script converts the tabs to commas in a given text file (without changing the original file) and saves result as txt file in the **Results** directory.

### 4. variables

This .sh script assigns values to variables and shows how these values can be replaced during the running of the script. There are two separate scripts, one with strings and one with integers.

### 5. MyExampleScript

This .sh script shows two ways of assigning variables, printing both to screen.

### 6. CountLines

This .sh script counts lines in a file (provided as a command line argument).

### 7. ConcatenateTwoFiles

This .sh script combines two files into a third. It requires three arguments: 1) first file (and realtive path) to be merged, 2) second file (and relative path) to be merged and 3) name and relative path of file to be created from merged files

### 8. tiff2png

This .sh script converts a given .tiff (provided as a command line argument) to a .png, saving the png in the **Results** directory.

### 9. csvtospace

This .sh script converts a given .csv file (provided as a command line argument) to a space delimited .txt file (without changing the original file) and saves the result in the **Results** folder.

### 10. FirstExample

This .tex file contains my first LaTeX code for a simple document with title, abstract, 2 sections, equations and one bibliography reference using BibTeX.

### 11. FirstBiblio

This .bib file contains a BibTeX reference taken from Google Scholar for use in FirstExample.tex.

### 12. CompileLaTeX

This .sh script compiles a LaTeX .tex file (provided as a command line argument) with BibTeX and creates a pdf. It also removes all the unnecessary files that are created at the same time. If a path, such as ../Results/, is provided as a second command line argument, the resulting pdf will be moved to that directory. Note that this second argument is optional.