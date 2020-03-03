#!/bin/bash
# Author: Lucy Goodyear lucy.goodyear19@imperial.ac.uk
# Script: run_MiniProject.sh
# Desc: Compiles a .tex file, producing a pdf
# Arguments: None
# Date: Feb 2020

echo "Beginning MiniProject execution"

echo "Running data preparation script..."
Rscript DataPrep.R
echo "Data preparation script completed"

echo "Running model fitting script..."
python3 Fit_Models.py
echo "Model fitting script completed"

echo "Running plotting script..."
Rscript Plot_Models.R
echo "Completed plotting script"

echo "Compiling .tex file..."
latex MiniProject.tex

mv MiniProject.pdf ../Results/MiniProject.pdf 

# cleanup
rm *.log
rm *.bbl
rm *.xml
rm *-blx.bib
rm *.dvi
rm *.aux

open ../Results/MiniProject.pdf

echo "Compiling completed, pdf produced"
echo "End of bash script — miniproject finished"

# exit