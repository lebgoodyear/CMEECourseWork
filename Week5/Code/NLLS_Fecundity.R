########## Model fitting example using Non-Linear Least Squares ############
####################### Aedes aegypti fecundity ############################

# clear workspace
rm(list = ls())
graphics.off()

# load neccesary packages
library(repr)
library(minpack.lm) # for Levenberg-Marquardt nlls fitting
library(ggplot2)

# use data measuring the response on Aedes aegypti fecundity to temperature
# load data
aedes <- read.csv("../Data/aedes_fecund.csv")
# visualise data
plot(aedes$T, aedes$EFD, 
     xlab = "Temperature (C)",
     ylab = "Eggs/day")

# define TPC models
# we define our own quadratic function instead of using the in-built one because
# it makes it easier to choose starting values and also so that we can force the 
# function to be equal to zero above and below the min and max temp thresholds

# quadratic model
quad1 <- function(T, T0, Tm, c) {
  c * (T - T0) * (T - Tm) * as.numeric(T < Tm) * as.numeric(T > T0)
}

# Briere function is commonly used to model temperature dependence of insect traits

# Briere model
briere <- function(T, T0, Tm, c) {
  c * T * (T - T0) * (abs(Tm - T) ^ (1 / 2)) * as.numeric(T < Tm) * as.numeric(T > T0)
}

# we will also model data with a straight line using lm()

# fit all 3 models using least squares

# first scale the data
scale <- 20

# fit the models
aed.lin <- lm(EFD/scale ~ T, data = aedes)
aed.quad <- nlsLM(EFD/scale ~ quad1(T, T0, Tm, c),
                  start = list(T0 = 10, Tm = 40, c = 0.01),
                  data = aedes)
aed.br <- nlsLM(EFD/scale ~ briere(T, T0, Tm, c), 
                start = list(T0 = 10, Tm = 40, c = 0.01),
                data = aedes)

# calculate predictions for each model across a range of temperatures
temps <- seq(0, 40, length = 30)
pred.lin <- predict(aed.lin, newdata = list(T = temps)) * scale
pred.quad <- predict(aed.quad, newdata = list(T = temps)) * scale
pred.br <- predict(aed.br, newdata = list(T = temps)) * scale

# plot the data with the fits
ggplot(aedes, aes(x = T,
                y= EFD,
                col = "black"),
       xlim = c(0, 40)) +
  geom_point(size = (1),
             colour = "black",
             shape = (1)) +
  geom_line(aes(temps, pred.lin, color = "black")) +
  geom_line(aes(temps, pred.quad, color = "blue")) +
  geom_line(aes(temps, pred.br, color = "green")) +
  theme_bw() +
  labs(y = "Eggs/day",
       x = "Temperature (C)") +
  scale_color_discrete(
    labels = c("Linear", "Quadratic", "Briere")) +
  theme(legend.position = c(15, 20)) +
  theme(legend.title = element_blank())

# compare all 3 models
# first examine residuals
par(mfrow = c(3, 1), bty = "n")
plot(aedes$T, resid(aed.lin), main = "LM residuals", xlim = c(0, 40))
plot(aedes$T, resid(aed.quad), main="Quadratic residuals", xlim=c(0,40))
plot(aedes$T, resid(aed.br), main="Briere residuals", xlim=c(0,40))
# the residuals for all 3 models are very similar and exhibit a lot of patterns
# combining this with the plot above, none of the models are particularly appropriate
# to describe this data

# compare the 3 models by calculating adjusted Sums of Squared Errors (SSEs)
n <- length(aedes$T)
list(lin = signif(sum(resid(aed.lin) ^ 2)/(n - 2 * 2), 3),
     quad= signif(sum(resid(aed.quad) ^ 2)/(n - 2 * 3), 3),
     br= signif(sum(resid(aed.br) ^ 2)/(n - 2 * 3), 3))
# all three SSEs are closer to 0.1 than 0, implying none are particularly good models
# the qudratic model has the lowest SSE so is the best fit of the three models

# compare using AIC
AIC(aed.lin)
AIC(aed.quad)
AIC(aed.lin)
# calculate delta(AIC)
AIC(aed.lin) - AIC(aed.br)
AIC(aed.quad) - AIC(aed.lin)
# we can see the linear and the Briere models have a delta(AIC) << 2 so are 
# indistinguishable in terms of best fit for the data
# delta(AIC) for the quadratic and linear (or Briere given the closeness 
# of the models) models is > |2|, again providing evidence that the 
# quadratic model is the best fit



