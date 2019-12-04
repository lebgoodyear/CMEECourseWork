#############################################################################
##################### Autocorrelation in weather ############################
#############################################################################

# loads and plots a dataset of temperatures by year in Key West. It creates two 
# lists offset from each other by one year, which allows the correltaion to be 
# calculated for successive years. It then calculates the correlation coefficient 
# for 10,000 random permutations of the temperature in order to compare significance.

# Author: Lucy Goodyear (lucy.goodyear19@imperial.ac.uk)
# Version: 0.0.1

# clear workspace
rm(list=ls())
#dev.off()

# imports
library(dplyr)

# load weather data
load("../Data/KeyWestAnnualMeanTemperature.Rdata")

# plot tmperatures over time on line graph
pdf("../Results/KWAMT.pdf")
plot(ats$Year,
     ats$Temp, 
     xlab = "Temp (Degrees Centigrade)",
     ylab = "Year",
     type = "l")
dev.off()

# create two lists of tmperatures, one with the first row deleted and then
# realigned with the second list so temps between suuccesive years can be
# easily compared
Temp_t0 <- c(ats[2:100,2])
Temp_t1 <- c(ats[1:99,2])

# calculate the correlation between successive years
CorCoeff <- cor(Temp_t0, Temp_t1)
cat("Correlation between successive years is", CorCoeff)

# create matrix of 10000 random permututions of temperature column
Temps1 <- replicate(10000,  sample(ats$Temp,replace = F))

# for each permutation, realign as before and then calculate correlation
RdmCors <- vector("numeric", 10000)
for (i in 1 : 10000) {
        RdmTemps <- cor( Temps1[2:100,i], Temps1[1:99,i])
        RdmCors[i] <- RdmTemps
}

# generate histogram comparing p-values
pdf("../Results/KWAMT_corr.pdf")
hist(RdmCors, 
     xlim = c(-0.4, 0.4),
     xlab = "Correlation Coefficients",
     main = NULL)
abline(v = CorCoeff, col = "red", lwd = 1, lty = 2)
text(CorCoeff, 1950, "correlation coefficient for\n successive years")
dev.off()

# calculate out estimated p-value (the fraction of correlation coefficients more
# significant than that of successive years (CorCoeff))
p_estimate <- (sum(RdmCors > CorCoeff) + sum (RdmCors < -CorCoeff)) / 10000

# print p_estimate to screen
cat("P-value estimate is", p_estimate)


