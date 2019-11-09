# CMEE Coursework Week 6 Repository

*Author: Lucy Goodyear*  
*Created: 09/11/19*

This repository contains all the CMEE coursework from Week 6 on genomics.

**Code** contains the scripts/programs.

**Data** is the data needed to run those scripts.

**Results** is where the outpout from those scripts is sent to.

**Sandbox** is a miscellaneous directory containing experimental code and data.

## Requirements

All code has been written in R version 3.6.1


## List of scripts
1. [Alleles](#1.Alleles)
2. [Coalescence](#2.-Coalescence)
3. [GeneticDrift](#3.-GeneticDrift)
4. [PopSubdivision](#4.-PopSubdivision)

### 1. Alleles

A .R script that creates a function, called analyse(x), which conducts analysis on SNPs in a dataset x. It first finds SNP locations, then calculates allele and genotype frquencies, homozygosity, heterozygosity and expected genotype counts and tests for Hardy-Weinstein Equilibrium (HWE). Lastly, the function calculates the inbreeding coefficient for SNPs that deivate from HWE.

### 2. Coalescence

A .R script that estimate the effective population size for two different populations of killer whales, using both Watterson's and Tajima's estimations of theta. It also calculates the site frequency spectrum for the two populations. The script contains functions that calculate Tajima's estimate of theta (pi), locations SNPs (SNPs), Watterson's estimate of theta (theta_W), estimated population using Tajima (Ne_pi), estimated population using Watterson (Ne_W) and the Site Frequency Spectrum (sfs).

### 3. GeneticDrift

A .R script that obtains an estimate of the divergence time between bent-toed and western banded geckos, given datasets of three gecko species and a proposed (but unlabeled) topology. It contains functions that identifies fixed sites for each species (count_fixed), compares the fixed sites between the species pairwise to find diverged sites (compare2) and calculates the genetic divergence pairwise (gen_divs). This data is then used to assign species to branches on the given topology and, given the time divergence between two of the species, the molecular clock is used to calculate an estimate of the rate of subsitution (mu). The desired time divergence is then calculated.

### 4. PopSubdivision

A .R script that assesses whether there has been distance by isolation in a turtle species found at 4 different location using 3 methods:
1) calculate F_ST pairwise for the 4 different turtle subpopulations
2) build a tree of all the samples and check for clustering
3) conduct a Principle Component Analysis
The script contains one function, calcF_ST, which calculates allele frequencies for each SNP in 2 populations, then calculates H_T and H_S, which are then used to calculate F_ST (method (1)).


