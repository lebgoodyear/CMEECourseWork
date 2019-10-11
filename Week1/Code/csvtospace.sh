#!/bin/bash
# Convert csv into txt file, converting commas into spaces

echo "Creating a space delimited version of $1..."
cat ../Data/$1.csv | tr -s "," " " >> ../Results/$1.txt # Move resulting txt file into Results directory
echo "Done"
exit
