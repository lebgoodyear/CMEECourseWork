#!/bin/bash

# For loop to convert a tiff into a png
for f in ../Data/*.tif;
    do
        echo "Converting $f";
        convert "$f"  "$(basename "$f" .tif).png";
        mv $1.png ../Results/$1.png; # Move resulting png into Results directory
    done