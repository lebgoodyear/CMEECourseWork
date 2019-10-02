#!/bin/bash
#Author: Lucy Goodyear lucy.goodyear@imperial.ac.uk
#Script: tabtocsv.sh
#Desc: substitute the tabs in the files with commas
#Saves the output into a .csv files
#Arguments: 1-> tab delimited files
#Date: Oct 2019
echo "Creating a comm delimited version of $1 ..."
cat $1 | tr -s "\t" "," >> $1.csv
echo "Done!"
exit