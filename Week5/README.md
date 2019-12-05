# CMEE Coursework Week 5 Repository

*Author: Lucy Goodyear*  
*Created: 18/11/19*

This repository contains all the CMEE coursework from Week 5 on modelling and GIS.

**Code** contains the scripts/programs.

**Data** is the data needed to run those scripts.

**Results** is where the outpout from those scripts is sent to.

**Sandbox** is a miscellaneous directory containing experimental code and data.

## Requirements

All code has been written in R version 3.6.1

Packages required:
- minpack.lm
- ggplot2
- repr
- raster
- sf
- viridis
- units
- rgeos
- lwgeom


## List of scripts
1. [NLLS_TraitsScaling](#1.NLLS_TraitsScaling)
2. [NLLS_Albatross](#2.-NLLS_Albatross)
3. [NLLS_Fecundity](#3.-NLLS_Fecundity)
4. [NLLS_PopGrowthRate](#4.-NLLS_PopGrowthRate)
5. [GIS](#5.-GIS)


### 1. NLLS_TraitsScaling

A .R script that fits models to trait data using non-linear least squares. It includes one function containing the power law equation and uses many of R's in-built functions, including AIC and BIC. A power law model, quadratic model and a straight line are fitted to two subsets of the data (subsetted by genus) and these models are then compared. It also contains plots of the data and the fits.

### 2. NLLS_Albatross

A .R script that fits models to albatross chick growth data. It includes two functions, one for the logistic growth equation and one for the Von Bertalanffy model. These models, and a straight line, are fitted to the data and both AIC and BIC are used to compare the three models. It also contains plots of the data and the fits.

### 3. NLLS_Fecundity

A .R script that fits models to data that measures the reponse of Aedes aegypti fecundity to temperature. It includes two functions, one for a quadratic model and the other for the Briere model, which are then, along with a straight line, fitted to the data. These models are then plotted (with the data) and compared using AIC.

### 4. NLLS_PopGrowthRate

A .R script that fits three models to generated "data" on the number of bacterial cells as a function of time. It contains three functions, each representing the Baranyi, Buchanan and the modified Gompertz growth model respectively, which are then fitted to the data and plotted. It also generates some starting values for the NLLS fittings, derived from the data.

### 5. GIS

A.R script that creates maps from GIS data using different methods. It covers both rastas and vectors and converting between the two.

