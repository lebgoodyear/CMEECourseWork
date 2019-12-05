#!/bin/bash
# Author: Lucy Goodyear lucy.goodyear19@imperial.ac.uk
# Script: CompileLatex.sh
# Desc: Compiles a .tex file, producing a pdf
# Arguments: 1) .tex file 2) (optional) path for directory
# into which the resulting pdf will be moved
# Date: Oct 2019

# check .tex file has been provided as a command line argument
if [ "$1" == "" ] 
then
    echo "Please provide a .tex file to compile"
    exit
fi

# compile .tex files
echo "Compiling..."

pdflatex $1.tex
pdflatex $1.tex
bibtex $1
pdflatex $1.tex
pdflatex $1.tex
open $1.pdf

# if path is provided as second argument,
# such as ../Results/, the resulting pdf
# will be moved to that directory
mv $1.pdf $2$1.pdf 

# cleanup
rm *~
rm *.aux
rm *.dvi
rm *.log
rm *.nav
rm *.out
rm *.snm
rm *.toc
rm *.bbl
rm *.blg
rm *.fls

echo "Done"

# exit