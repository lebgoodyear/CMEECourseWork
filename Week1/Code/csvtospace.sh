#!/bin/bash
# Author: Lucy Goodyear lucy.goodyear19@imperial.ac.uk
# Script: csvtospace.sh
# Desc: Convert csv into txt file, converting commas into spaces
# Arguments: 1) csv file to be converted
# Date: Oct 2019

# check a csv file has been provided as a command line argument
if [ "$1" == "" ] 
then
    echo "Please provide a csv file to convert"
    exit
fi

# convert the csv to a space delimited file
echo "Creating a space delimited version of $1..."
cat ../Data/$1.csv | tr -s "," " " >> ../Results/$1.txt # Move resulting txt file into Results directory
echo "Done"

# exit
