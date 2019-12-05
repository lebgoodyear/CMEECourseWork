#!/bin/bash
# Author: Lucy Goodyear lucy.goodyear19@imperial.ac.uk
# Script: tabtocsv.sh
# Desc: Substitutes the tabs in the files with commas
# Saves the output into a .csv files
# Arguments: 1) tab delimited file to be converted
# Date: Oct 2019

# check that a tab delimited file to convert has been provided
if [ "$1" == "" ] 
then
    echo "Please provide a tab delimited file"
    exit
fi

# convert tab delimited file into comma delimited file
echo "Creating a comma delimited version of $1 ..."
cat ../Data/$1.txt | tr -s "\t" "," >> ../Results/$1.csv # Move resulting txt file into Results directory
echo "Done!"

# exit