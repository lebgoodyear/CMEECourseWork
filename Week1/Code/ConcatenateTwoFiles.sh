#!/bin/bash
# Author: Lucy Goodyear lucy.goodyear19@imperial.ac.uk
# Script: ConcatenateTwoFiles.sh
# Desc: Merges two given files into a third file
# Arguments: 1) First file (and relative path) to be merged
#            2) Second file (and relative path) to be merged
#            3) Name and relative path of file to be created
#               from merged files
# Date: Oct 2019

# check a csv file has been provided as a command line argument
if ["$1" == ""] || ["$2" == ""] || ["$3" == ""] 
then
    echo "Please provide two files to merge and the name of the third file to be created"
    exit
fi

# First file is copied into 3rd file
cat $1 > $3
# Second file is merged into 3rd file 
cat $2 >> $3
# Print contents of 3rd file
echo "Merged File is"
cat $3

# exit