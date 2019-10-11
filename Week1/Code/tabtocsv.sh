#!/bin/bash
# Author: Lucy Goodyear lucy.goodyear19@imperial.ac.uk
# Script: tabtocsv.sh
# Desc: Substitutes the tabs in the files with commas
# Saves the output into a .csv files
# Arguments: 1 -> tab delimited files
# Date: Oct 2019
echo "Creating a comma delimited version of $1 ..."
cat $1.txt | tr -s "\t" "," >> $1.csv
echo "Done!"
exit