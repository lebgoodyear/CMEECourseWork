########## Model fitting example using Non-Linear Least Squares ############


# clear workspace
rm(list = ls())
graphics.off()

# load neccesary packages
library(repr)
library(minpack.lm) # for Levenberg-Marquardt nlls fitting
library(ggplot2)


#################### Allometric scaling of traits #########################


# create a function for the power law model
powMod <- function(x, a, b) {
  return(a * x^b)
}

# load data
MyData <- read.csv("../Data/GenomeSize.csv")

# subset the data by Anisoptera and remove NAs
Data2Fit <- subset(MyData, Suborder == "Anisoptera")
Data2Fit <- Data2Fit[!is.na(Data2Fit$TotalLength),] # remove NA's

# plot data
plot(Data2Fit$TotalLength, Data2Fit$BodyWeight)

# or use ggplot to plot the data
ggplot(Data2Fit, aes(x = TotalLength,
                     y= BodyWeight)) +
  geom_point(size = (3),
             colour = "red") +
  theme_bw() +
  labs(y = "Body mass (mg)",
       x = "Total length (mm)")

# fit the model to the data using NLLS
PowFit <- nlsLM(BodyWeight ~ powMod(TotalLength, a, b), 
                data = Data2Fit, 
                start = list(a = .1, b = .1))

# use summary to see the values of the model
summary(PowFit)
# not that further statistical inference cannot be done using ANOVA,
# like for a lm

## visualise the fit
# generate a vector of body length (x-axis variable) for plotting
Lengths <- seq(min(Data2Fit$TotalLength), max(Data2Fit$TotalLength), len=200)
# calculate the predicted line by extracting the coefficent from the
# model fit
coef(PowFit)["a"]
coef(PowFit)["b"]
# use power law function on lengths and model parameters
Predic2PlotPow <- powMod(Lengths, coef(PowFit)["a"], coef(PowFit)["b"])
# plot data and the fitted model line
plot(Data2Fit$TotalLength, Data2Fit$BodyWeight)
lines(Lengths, Predic2PlotPow, col = 'blue', lwd = 2.5)

# calculate confidence intervals (CI) on the estimated parameters
# like we would in OLS fitting used for linear models
confint(PowFit)
# remember a coefficent's CI should not include 0 for it
# to be statistically signficant (different from 0)


### exercise a) plot the above graph in ggplot and add equation


ggplot(Data2Fit, aes(x = TotalLength,
                     y= BodyWeight)) +
  geom_point(size = (3),
             colour = "red") +
  stat_function(fun = function(Lengths) powMod(Lengths, a = coef(PowFit)["a"], b = coef(PowFit)["b"]),
                col = 'blue', lwd = 1.5) +
  theme_bw() +
  labs(y = "Body mass (mg)",
       x = "Total length (mm)") +
  geom_text(aes(x = 45, y = 0.25,
              label = paste("Mass == (3.94e-6)*Length ^ 2.59")), 
              parse = TRUE, size = 3, 
              colour = "blue")


### exercise b) play with starting values to see if model fitting can be 
### "broken" (until NLLS does not converge on a solution)


PowFitT <- nlsLM(BodyWeight ~ powMod(TotalLength, a, b), 
                data = Data2Fit, 
                start = list(a = -10, b = 10))

summary(PowFitT)
coef(PowFitT)["a"]
coef(PowFitT)["b"]
Lengths <- seq(min(Data2Fit$TotalLength), max(Data2Fit$TotalLength), len=200)
Predic2PlotPowT <- powMod(Lengths, coef(PowFitT)["a"], coef(PowFitT)["b"])

# plot data and the fitted model line
ggplot(Data2Fit, aes(x = TotalLength,
                     y= BodyWeight)) +
  geom_point(size = (3),
             colour = "red") +
  stat_function(fun = function(Lengths) powMod(Lengths, a = coef(PowFitT)["a"], b = coef(PowFitT)["b"]),
                col = 'blue', lwd = 1.5) +
  theme_bw() +
  labs(y = "Body mass (mg)",
       x = "Total length (mm)") +
  geom_text(aes(x = 45, y = 0.25,
                label = paste("Mass == (3.94e-6)*Length ^ 2.59")), 
            parse = TRUE, size = 3, 
            colour = "blue")

# infinity produced when a, b > 1000, causing error
# singular gradient matrix produced when a, b < -1000, causing error
# can't plot model line for a = -100, b = 100
# a = -10, b = 10 produces a plot with an exponential asymptote around 85,
# which doesn't fit the data


### exercise c) repeat model fitting for Zygoptera dataset


# subset the data by Zygoptera and remove NAs
Data2FitZ <- subset(MyData, Suborder == "Zygoptera")
Data2FitZ <- Data2FitZ[!is.na(Data2FitZ$TotalLength),] # remove NA's

# plot data
plot(Data2FitZ$TotalLength, Data2FitZ$BodyWeight)

# or use ggplot to plot the data
ggplot(Data2FitZ, aes(x = TotalLength,
                     y= BodyWeight)) +
  geom_point(size = (3),
             colour = "red") +
  theme_bw() +
  labs(y = "Body mass (mg)",
       x = "Total length (mm)")

# fit the model to the data using NLLS
PowFitZ <- nlsLM(BodyWeight ~ powMod(TotalLength, a, b), 
                data = Data2FitZ, 
                start = list(a = .01, b = .01))

# use summary to see the values of the model
summary(PowFitZ)
# not that further statistical inference cannot be done using ANOVA,
# like for a lm

## visualise the fit
# generate a vector of body length (x-axis variable) for plotting
LengthsZ <- seq(min(Data2FitZ$TotalLength), max(Data2FitZ$TotalLength), len=200)
# calculate the predicted line by extracting the coefficent from the
# model fit
coef(PowFitZ)["a"]
coef(PowFitZ)["b"]
# use power law function on lengths and model parameters
Predic2PlotPowZ <- powMod(LengthsZ, coef(PowFitZ)["a"], coef(PowFitZ)["b"])
# plot data and the fitted model line
plot(Data2FitZ$TotalLength, Data2FitZ$BodyWeight)
lines(LengthsZ, Predic2PlotPowZ, col = 'blue', lwd = 2.5)

# calculate confidence intervals (CI) on the estimated parameters
# like we would in OLS fitting used for linear models
confint(PowFitZ)
# remember a coefficent's CI should not include 0 for it
# to be statistically signficant (different from 0)

# c) exercise a) plot the above graph in ggplot and add equation
ggplot(Data2FitZ, aes(x = TotalLength,
                     y= BodyWeight)) +
  geom_point(size = (3),
             colour = "red") +
  stat_function(fun = function(LengthsZ) powMod(LengthsZ, a = coef(PowFitZ)["a"], b = coef(PowFitZ)["b"]),
                col = 'blue', lwd = 1.5) +
  theme_bw() +
  labs(y = "Body mass (mg)",
       x = "Total length (mm)") +
  geom_text(aes(x = 35, y = 0.03,
                label = paste("Mass == (6.94e-8)*Length ^ 2.57")), 
            parse = TRUE, size = 3, 
            colour = "blue")

# c) exercise b) play with starting values to see if model fitting can be 
# "broken" (until NLLS does not converge on a solution)

PowFitZT <- nlsLM(BodyWeight ~ powMod(TotalLength, a, b), 
                data = Data2FitZ, 
                start = list(a = -10, b = 10))

summary(PowFitZT)
coef(PowFitZT)["a"]
coef(PowFitZT)["b"]
LengthsZT <- seq(min(Data2FitZ$TotalLength), max(Data2FitZ$TotalLength), len=200)
Predic2PlotPowZT <- powMod(LengthsZT, coef(PowFitZT)["a"], coef(PowFitZT)["b"])

# plot data and the fitted model line
ggplot(Data2FitZ, aes(x = TotalLength,
                     y= BodyWeight)) +
  geom_point(size = (3),
             colour = "red") +
  stat_function(fun = function(LengthsZT) powMod(LengthsZT, a = coef(PowFitZT)["a"], b = coef(PowFitZT)["b"]),
                col = 'blue', lwd = 1.5) +
  theme_bw() +
  labs(y = "Body mass (mg)",
       x = "Total length (mm)") +
  geom_text(aes(x = 45, y = 0.25,
                label = paste("Mass == (3.94e-6)*Length ^ 2.59")), 
            parse = TRUE, size = 3, 
            colour = "blue")

# a = -10 and b = 10 gives a negative exponential with asymptote at 50,
# which does not fit data, as does a, b = 100 (although slope is much steeper)
# a = 1, b = 1 does not fit well, intercept is too high and slope is too shallow


### exercise d) use OLS method on bi-logarithamically transformed data
### and compare parameters with NLLS method


# log both side of allometric equation
# log(y) = log(a) + b.log(x)
# this equivalent to c = d + bz,
# where c = log(y), d = log(a), z = log(x) and b is the slope parameter

# perform an ordinary least squares linear regression
OLS_Fit <- lm(BodyWeight ~ TotalLength, 
              data = Data2Fit) # use Anisoptera data only

# use summary to see the values of the both models
summary(OLS_Fit)
summary(PowFit)

# plot both NLLS and OLS regression lines side by side
par(mfrow=c(1,2))
plot(Data2Fit$TotalLength, Data2Fit$BodyWeight)
abline(lm(BodyWeight ~ TotalLength, data = Data2Fit), col = 'blue')
plot(Data2Fit$TotalLength, Data2Fit$BodyWeight)
lines(Lengths, Predic2PlotPow, col = 'blue', lwd = 2.5)

# we can see just be eye that this fit is not as good as the NLLS model
# use tests to compare the parameter estimates of the two methods

# we check whether the confidence intervals overlap
CI_Pow <- c(log(confint(PowFit)[1]), log(confint(PowFit)[2]), confint(PowFit)[3], confint(PowFit)[4])
CI_OLS <- c(confint(OLS_Fit)[1], confint(OLS_Fit)[2], confint(OLS_Fit)[3], confint(OLS_Fit)[4])

log(coef(PowFit)["a"]) # intercept
coef(PowFit)["b"] # slope parameter equivalent
summary(OLS_Fit)$coeff[1] # intercept
summary(OLS_Fit)$coeff[2] # slope

cat("\nAre the intercepts of one method in the confidence intervals of the other method?",
    "\nNLLS intercept, CI OLS", 
    (log(coef(PowFit)["a"]) > confint(OLS_Fit)[1]) & (log(coef(PowFit)["a"]) < confint(OLS_Fit)[2]),
    "\nOLS intercept, CI NLLS", 
    (summary(OLS_Fit)$coeff[1] > log(confint(PowFit)[1])) & (summary(OLS_Fit)$coeff[1] < log(confint(PowFit)[2])), 
    "\nNLLS slope equivalent, CI OLS", 
    (coef(PowFit)["b"] > confint(OLS_Fit)[3]) & (coef(PowFit)["b"] < confint(OLS_Fit)[4]),
    "\nOLS slope, CI NLLS",
    (summary(OLS_Fit)$coeff[2] > confint(PowFit)[3]) & (summary(OLS_Fit)$coeff[2] < confint(PowFit)[4]),
    "\n")

# We can see that both OLS coefficients are found in the NLLS confidence intervals, showing how NLLS is a more
# generalised form of OLS


### exercise e) investigate allometry between body mass and other linear morphological measurements


# first for Anisoptera
Morph_Data <- Data2Fit[-c(1:6,16)]
# remove NA in Headlength
Morph_Data <- Morph_Data[!is.na(Morph_Data$HeadLength),] 

# overview of all potential pairs of scaling relationships
pairs(Morph_Data)
# we can see that all pairs have a positive scaling relationship

# run a for loop to do an NLLS model on all the other measurements
PowFitMM <- list()
for (i in (2:ncol(Morph_Data))) { # include total length so we can compare to others
  PowFitM <- nlsLM(BodyWeight ~ powMod(Morph_Data[,i], a, b), 
                  data = Morph_Data, 
                  start = list(a = .1, b = .1))
  RSS <-  1 - ((sum(residuals(PowFitM)^2)) / (sum(Morph_Data[,i]) - mean(Morph_Data[,i]) ^ 2))
  PowFitMM[[i]] <- list(coef(PowFitM)[1], coef(PowFitM)[2], RSS)
}

# set up a dataframe with the parameters for each measurement
Parameters <- data.frame(matrix(unlist(PowFitMM), ncol = 3, byrow = TRUE))
colnames(Parameters) = c("a", "b", "RSS")

# plot the values of a, b and RSS
par(mfrow = c(1, 3))
barplot(Parameters[,1], 
        names.arg = colnames(Morph_Data)[2:9],
        main = 'Values of a')
barplot(Parameters[,2], 
        names.arg = colnames(Morph_Data)[2:9],
        main = 'Values of b')
barplot(Parameters[,3], 
        names.arg = colnames(Morph_Data)[2:9],
        main = 'RSS values')

# From the plots above, we can see all measurements are allometric with body mass 
# (RSS are all close to 1) and the greatest proportionate variation is in the
# values of a, with thorax length having the greatest value of a, meaning a 
# small change in thorax length gives a large change in body mass.
# However the greatest RSS values (only 2e7 between them) are for forewing area and 
# hindwing area, which suggests these better predict body weight than all of the 
# other morphological variables included here.

# now do the same for Zygoptera
Morph_DataZ <- Data2FitZ[-c(1:6,16)]
# remove NA in ForewingLength
Morph_DataZ <- Morph_DataZ[!is.na(Morph_DataZ$ForewingLength),] 

# overview of all potential pairs of scaling relationships
pairs(Morph_DataZ)
# we can see that all pairs have a positive scaling relationship

# run a for loop to do an NLLS model on all the other measurements
PowFitMMZ <- list()
for (i in (2:ncol(Morph_DataZ))) { # include total length so we can compare to others
  PowFitMZ <- nlsLM(BodyWeight ~ powMod(Morph_DataZ[,i], a, b), 
                   data = Morph_DataZ, 
                   start = list(a = .1, b = .1))
  RSS <-  1 - ((sum(residuals(PowFitMZ)^2)) / (sum(Morph_DataZ[,i]) - mean(Morph_DataZ[,i]) ^ 2))
  PowFitMMZ[[i]] <- list(coef(PowFitMZ)[1], coef(PowFitMZ)[2], RSS)
}

# set up a dataframe with the parameters for each measurement
ParametersZ <- data.frame(matrix(unlist(PowFitMMZ), ncol = 3, byrow = TRUE))
colnames(ParametersZ) = c("a", "b", "RSS")

# plot the values of a, b and RSS
par(mfrow = c(1, 3))
barplot(ParametersZ[,1], 
        names.arg = colnames(Morph_DataZ)[2:9],
        main = 'Values of a')
barplot(ParametersZ[,2], 
        names.arg = colnames(Morph_DataZ)[2:9],
        main = 'Values of b')
barplot(ParametersZ[,3], 
        names.arg = colnames(Morph_DataZ)[2:9],
        main = 'RSS values')

# The we see similar results to those for Anisoptera. We can see all measurements are 
# allometric with body mass (RSS are all close to 1) and again the greatest 
# proporionate variation is in the values of a, with thorax length having the greatest
# value of a, meaning a small change in thorax length gives a large change in body mass.
# However the greatest RSS values (only 1e7 between them) are again for forewing 
# area and hindwing area, which suggests these better predict body weight than all of the 
# other morphological variables included here.


####################### Comparing Models #################################


# investigate whether relationship between body weight and total length is 
# actually allometric

# first use Anisoptera subset
# try fitting a quadratic curve — parameters are linear so we can use lm()
QuaFit <- lm(BodyWeight ~ poly(TotalLength, 2), data = Data2Fit)
# use predict.lm fucntion to predict new values
Predic2PlotQua <- predict.lm(QuaFit, data.frame(TotalLength = Lengths))

# plot the two fitted models together
plot(Data2Fit$TotalLength, Data2Fit$BodyWeight)
lines(Lengths, Predic2PlotPow, col = 'blue', lwd = 2.5)
lines(Lengths, Predic2PlotQua, col = 'red', lwd = 2.5)
# the fits are very similar except at the lower end of the data range

# do a formal model comparison to check which model fits the data better
# first calculate R^2 values for both models

RSS_Pow <- sum(residuals(PowFit)^2) # residual sum of squares
TSS_Pow <- sum((Data2Fit$BodyWeight - mean(Data2Fit$BodyWeight))^2) # total sum of squares
RSq_Pow <- 1 - (RSS_Pow/TSS_Pow) # R^2 value

RSS_Qua <- sum(residuals(QuaFit)^2)  # residual sum of squares
TSS_Qua <- sum((Data2Fit$BodyWeight - mean(Data2Fit$BodyWeight))^2)  # total sum of squares
RSq_Qua <- 1 - (RSS_Qua/TSS_Qua)  # R^2 value

RSq_Pow
RSq_Qua
# this is not actually very useful because there is only a tiny difference
# R^2 is a therefore a good measure of model fit but can't be used for model selection

# use the Akaike Information Criterion (AIC)
n <- nrow(Data2Fit) # set the sample size
pPow <- length(coef(PowFit)) # get number of parameters in power law model
pQua <- length(coef(QuaFit)) # get number of parameters in quadratic model

AIC_Pow <- n + 2 + n * log((2 * pi) / n) + n * log(RSS_Pow) + 2 * pPow
AIC_Qua <- n + 2 + n * log((2 * pi) / n) + n * log(RSS_Qua) + 2 * pQua
AIC_Pow - AIC_Qua

# there is an in-built function to do this in R!
AIC(PowFit) - AIC(QuaFit)

# A rule of thumb for deciding which model is a better fit is having an AIC value
# difference > |2|. This is an acceptable cut off for deciding which model is better.
# So in this example, the power law (allometric model) is a better fit.


### exercise a) calculate the BIC and use delta(BIC) to select the better fitting model


# the Bayesian Information Criterion also has an in-built function in R
BIC(PowFit) - BIC(QuaFit)
# this difference is much greater than |2| so the better fitting model 
# is still the power law model


### exercise b) fit a straight line to the data and compare with
### the other two models


# use our linear model from the previous exercises, 
# which was a straight line
BIC(PowFit) - BIC(OLS_Fit)
BIC(QuaFit) - BIC(OLS_Fit)
# we can see that both the power law model and the quadratic model 
# are significantly better than the straight line model (delta(BIC) > |22| for both!)


### exercise c) repeat the model comparison for Zygoptera subset


# fit a quadratic curve to Zygoptera subset
QuaFitZ <- lm(BodyWeight ~ poly(TotalLength, 2), data = Data2FitZ)
# use predict.lm fucntion to predict new values
Predic2PlotQuaZ <- predict.lm(QuaFitZ, data.frame(TotalLength = LengthsZ))

# plot the two fitted models together
plot(Data2FitZ$TotalLength, Data2FitZ$BodyWeight)
lines(LengthsZ, Predic2PlotPowZ, col = 'blue', lwd = 2.5)
lines(LengthsZ, Predic2PlotQuaZ, col = 'red', lwd = 2.5)

# calculate delta(BIC)
AIC(PowFitZ) - AIC(QuaFitZ)
# delta(AIC) is greater than |2| but smaller than delta(AIC) for Anisoptera,
# suggesting that the power law fit and the quadraric fit are more similar
# for the Zygoptera
BIC(PowFitZ) - BIC(QuaFitZ)
# the same is true for delta(BIC)
# however, the power law fit is still the best fit


### exercise d)


# first for Anisoptera
# run a for loop to calculate the power law model and quadratic model for the other measurements
Compare <- as.data.frame(matrix(ncol = 2))
for (i in (2:ncol(Morph_Data))) { # include total length so we can compare to others
  PowFitM <- nlsLM(BodyWeight ~ powMod(Morph_Data[,i], a, b), 
                   data = Morph_Data, 
                   start = list(a = .1, b = .1))
  QuaFitM <- lm(BodyWeight ~ poly(TotalLength, 2), data = Morph_Data)
  Temp <- cbind(names(Morph_Data)[i], AIC(PowFitM) - AIC(QuaFitM))
  Compare <- rbind(Compare, Temp) 
}

print(Compare)
# Here we can see that for total length, the power law model is better but
# for all the other models, the quadratic model is a better fit! Head length
# has the highest delta(AIC) value, implying this could be the best predictor of
# body weight but all delta(AIC)s are highly significant

# now do the same for Zygoptera
# run a for loop to calculate the power law model and quadratic model for the other measurements
CompareZ <- as.data.frame(matrix(ncol = 2))
for (i in (2:ncol(Morph_DataZ))) { # include total length so we can compare to others
  PowFitM <- nlsLM(BodyWeight ~ powMod(Morph_DataZ[,i], a, b), 
                   data = Morph_DataZ, 
                   start = list(a = .1, b = .1))
  QuaFitM <- lm(BodyWeight ~ poly(TotalLength, 2), data = Morph_DataZ)
  Temp <- cbind(names(Morph_DataZ)[i], AIC(PowFitM) - AIC(QuaFitM))
  CompareZ <- rbind(CompareZ, Temp) 
}

print(CompareZ)
# Here can see that for total length, thorax length, forewing length and
# hindwing length the power law model is a better fit but for abdomen length,
# forewing area and hindwing area the quaratic is a better fit. Headlength 
# |delta(AIC)| < 2 so there is not much difference between the two models.
# The model with the highest dealta(AIC) is thorax length, implying this is the
# best predictor of body mass.



