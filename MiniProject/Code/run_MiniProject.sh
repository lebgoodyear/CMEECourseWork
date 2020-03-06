#!/bin/bash
# Author: Lucy Goodyear lucy.goodyear19@imperial.ac.uk
# Script: run_MiniProject.sh
# Desc: Compiles a .tex file, producing a pdf
# Arguments: None
# Date: Feb 2020

echo "Beginning MiniProject execution"

# run R data preparation script
echo "Running data preparation script..."
Rscript DataPrep.R
echo "Data preparation script completed"

# run python model fitting script
echo "Running model fitting script..."
python3 Fit_Models.py
echo "Model fitting script completed"

# run R plotting and analysis script
echo "Running plotting and analysis script..."
Rscript Plot_Analyse_Models.R
echo "Completed plotting and analysis script"

echo "Compiling .tex file..."
# word count for final report
texcount -1 -sum MiniProject.tex > MiniProject.sum
# compile latex file to produce pdf with bibliography
pdflatex MiniProject.tex
bibtex MiniProject
pdflatex MiniProject.tex

# move pdf into Results folder
mv MiniProject.pdf ../Results/MiniProject.pdf 

# cleanup
rm *.log
rm *.bbl
rm *.xml
rm *-blx.bib
rm *.aux
rm *.sum
rm *.blg
rm -r __pycache__

# open pdf for viewing
open ../Results/MiniProject.pdf

# print to screen so we know all has been completed
echo "Compiling completed, pdf produced"
echo "End of bash script — miniproject finished"

# end of script