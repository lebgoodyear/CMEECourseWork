#!/bin/bash
# Author: Lucy Goodyear lucy.goodyear19@imperial.ac.uk
# Script: run_get_TreeHeight.sh
# Desc: runs an R script and a python script that calculate tree heights
# for a data set provided externally to the two scripts. Both scripts 
# produce the same resultant csv file.
# Arguments: None
# Date: Nov 2019

# run R script with trees.csv as an example
echo "Running R script"
Rscript get_TreeHeight.R ../Data/trees.csv
echo "R script finished"

# run python script with trees.csv as an example
echo "Running python script"
python3 get_TreeHeight.py ../Data/trees.csv
echo "Python script finished"