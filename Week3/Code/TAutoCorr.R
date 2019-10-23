#############################################################################
##################### Autocorrelation in weather ############################
#############################################################################

# imports
library(dplyr)

# load weather data
load("../Data/KeyWestAnnualMeanTemperature.Rdata")

# plot tmperatures over time on line graph
plot(ats$Year,
        ats$Temp, 
        xlab = "Temp (Degrees Centigrade)",
        ylab = "Year",
        main = "Key West Annual Mean Temperature",
        type = "l")

# create two lists of tmperatures, one with the first row deleted and then
# realigned with the second list so temps between suuccesive years can be
# easily compared
Temp_t0 <- c(ats[2:100,2])
Temp_t1 <- c(ats[1:99,2])

# calculate the correlation between successive years
CorCoeff <- cor(Temp_t0, Temp_t1)
print(CorCoeff)

# create matrix of 10000 random permututions of temperature column
Temps1 <- replicate(10000,  sample(ats$Temp,replace = F))

# for each permutation, realign as before and then calculate correlation
RdmCors <- vector("numeric", 10000)
for (i in 1 : 10000) {
        RdmTemps <- cor( Temps1[2:100,i], Temps1[1:99,i])
        RdmCors[i] <- RdmTemps
}

# calculate the fraction of correlation coefficients more significant than
# that of successive years (CorCoeff)
sum(RdmCors > CorCoeff) + sum (RdmCors < -CorCoeff)



