#!/bin/bash
# Merges two given files into a third file

# First file is copied into 3rd file
cat $1 > $3
# Second file is merged into 3rd file 
cat $2 >> $3
# Print contents of 3rd file
echo "Merged File is"
cat $3