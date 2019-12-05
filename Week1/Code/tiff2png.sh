#!/bin/bash
# Author: Lucy Goodyear lucy.goodyear19@imperial.ac.uk
# Script: tiff2png.sh
# Desc: Converts a tiff into a png
# Arguments: tiff to be converted
# Date: Oct 2019

# check a csv file has been provided as a command line argument
if [ "$1" == "" ] 
then
    echo "Please provide a tiff to convert"
    exit
fi

# For loop to convert a tiff into a png
for f in ../Data/*.tif;
    do
        echo "Converting $f";
        convert "$f"  "$(basename "$f" .tif).png";
        mv $1.png ../Results/$1.png; # Move resulting png into Results directory
        echo "Done"
    done

# exit