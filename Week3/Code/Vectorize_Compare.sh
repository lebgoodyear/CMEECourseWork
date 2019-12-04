#!/bin/bash
# Author: Lucy Goodyear lucy.goodyear19@imperial.ac.uk
# Script: Vectorize_Compare.sh
# Desc: runs 2 R scripts and 2 python scripts that run loops and vectorized versions
# of blocks of code, comparing times.
# Arguments: None
# Date: Dec 2019

# compare running times for Vectorize1 in python and R
printf "\nRunning Vectorize1.py\n"
TIMEFORMAT='Vectorize1 in python: time taken is '%R
time python3 Vectorize1.py
printf "\nRunning Vectorize1.R\n"
TIMEFORMAT='Vectorize1 in R: time taken is '%R
time Rscript Vectorize1.R

# compare running times for Vectorize2 in python and R
printf "\nRunning Vectorize2.py\n"
TIMEFORMAT='Vectorize2 in python: time taken is '%R
time python3 Vectorize2.py
printf "\nRunning Vectorize2.R\n"
TIMEFORMAT='Vectorize2 in R: time taken is '%R
time Rscript Vectorize2.R