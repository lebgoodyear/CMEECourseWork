#!/bin/bash
# Counts the lines in a given file
NumLines=`wc -l < $1`
echo "The file $1 has $NumLines lines"
echo