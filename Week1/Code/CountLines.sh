#!/bin/bash
# Author: Lucy Goodyear lucy.goodyear19@imperial.ac.uk
# Script: CountLines.sh
# Desc: Counts the lines in a given file
# Arguments: 1) The file (and relative path) to count lines of
# Date: Oct 2019

# check a file has been provided as a command line argument
if [ "$1" == "" ] 
then
    echo "Please provide a file to count the lines of"
    exit
fi

# Counts the lines the file provided
NumLines=`wc -l < $1`
echo "The file $1 has $NumLines lines"

# exit