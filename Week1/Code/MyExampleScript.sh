#!/bin/bash
# Author: Lucy Goodyear lucy.goodyear19@imperial.ac.uk
# Script: MyExampleScript.sh
# Desc: Shows two ways of assigning variables
# Arguments: none
# Date: Oct 2019

# assign variables
msg1="Hello"
msg2=$USER
echo # empty line for easier readability
# print variables to screen
echo "$msg1 $msg2"
# print variable contents to screen explicitly
echo "Hello $USER"
echo

# exit