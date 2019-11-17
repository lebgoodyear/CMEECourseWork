########## Model fitting example using Non-Linear Least Squares ############
######################## Albatross chick growth ############################

# clear workspace
rm(list = ls())
graphics.off()

# load neccesary packages
library(repr)
library(minpack.lm) # for Levenberg-Marquardt nlls fitting
library(ggplot2)

# load data
alb <- read.csv(file = "../Data/albatross_grow.csv")
# subset data by weight and remove NAs
alb <- subset(x = alb, !is.na(alb$wt))

# plot data
ggplot(alb, aes(x = age,
                y = wt),
     xlim = c(0, 100)) +
  geom_point(size = (1),
             colour = "black",
             shape = (1)) +
  labs(x = "age (days)",
       y = "weight (g)")

# fit three models using NLLS

# Von Bertalanffy model
# common model for modelling the growth of an individual
# W(t) = rho(L_inf(1 - e^-Kt) + L_0(e^-Kt)^3

# define c = L_0/L_inf and W_inf = rho(L_inf)^3
# so equation becomes 
# W(t) = W_inf(1 - e^(-Kt) + ce^(-Kt))^3

# W_inf is interpreted as mean asymptotic weight and 
# c is the ratio between initial and final lengths

# we will fit this second equation and compare against classical Logistic growth
# equation and a straight line

# define R functions for two models
# classical logistic growth equation
logistic1 <- function(t, r, K, N0) {
  N0 * K * exp(r * t)/(K + N0 * (exp(r * t) -1))
}
# Von Bertalanffy model
vonbert.w <- function(t, Winf, c, K) {
  Winf * (1 - exp(-K * t) + c * exp(-K * t)) ^ 3
}
# for the straight line model, we use the lm() function since it is 
# a linear least squares problem

# first scale the data before fitting to improve stability of estimates
scale <- 4000
# fit all3 models to the data
alb.lin <- lm(wt/scale ~ age, data = alb)
alb.log <- nlsLM(wt/scale ~ logistic1(age, r, K, N0), 
                 start = list(K = 1, r = 0.1, N0 = 0.1),
                 data = alb)
alb.vb<- nlsLM(wt/scale ~ vonbert.w(age, Winf, c, K),
               start = list(Winf = 0.75, c = 0.01, K = 0.01),
               data = alb)

# calculate predictions for each model across a range of ages
ages <- seq(0, 100, length = 93)
pred.lin <- predict(alb.lin, newdata = list(age = ages)) * scale
pred.log <- predict(alb.log, newdata = list(age = ages)) * scale
pred.vb <- predict(alb.vb, newdata = list(age = ages)) * scale

# plot the data with the fits
# base plot was replaced by ggplot
#plot(alb$age, alb$wt,
#     ylab = "weight (g)",
#     xlab = "age (days)",
#     xlim = c(0, 100))
#lines(ages, pred.lin, col = 2, lwd = 2)
#lines(ages, pred.log, col = 3, lwd = 2)
#lines(ages, pred.vb, col = 4, lwd = 2)

#legend("topleft",
#       legend = c("Linear", "Logisitic", "Von Bert"),
#       lwd = 2,
#       lty = 1,
#       col = 2:4,
#       cex = 0.75)

ggplot(alb, aes(x = age,
                y= wt,
                col = "black"),
                xlim = c(0, 100)) +
  geom_point(size = (1),
             colour = "black",
             shape = (1)) +
  geom_line(aes(ages, pred.lin, color = "black")) +
  geom_line(aes(ages, pred.log, color = "blue")) +
  geom_line(aes(ages, pred.vb, color = "green")) +
  theme_bw() +
  labs(y = "Weight (g)",
       x = "Age (days)") +
  scale_color_discrete(
    labels = c("Linear", "Logisitic", "Von Bert")) +
  theme(legend.position = c(0.2, 0.8)) +
  theme(legend.title = element_blank())

# examine the residuals between the models
par(mfrow = c(3, 1), bty = "n") # this suppresses the box drawn around the plots
plot(alb$age, resid(alb.lin), main = "LM residuals", xlim = c(0, 100))
plot(alb$age, resid(alb.log), main="Logisitic residuals", xlim=c(0,100))
plot(alb$age, resid(alb.vb), main="VB residuals", xlim=c(0,100))
# the residuals for all 3 models still exhibit some patterns
# note the data seems to go down near the end of observation period but 
# none of these models can capture that behaviour

# compare the 3 models by calculating adjusted Sums of Squared Errors (SSEs)
n <- length(alb$wt)
list(lin = signif(sum(resid(alb.lin) ^ 2)/(n - 2 * 2), 3),
     log= signif(sum(resid(alb.log) ^ 2)/(n - 2 * 3), 3),
     vb= signif(sum(resid(alb.vb) ^ 2)/(n - 2 * 3), 3))
# The logistic model has the lowest adjusted SSE 
# so it is the best fit by this measure
# note it is also a better fit visually


### exercise a) use AIC/BIC to perform model selection for albatross data


# compare using BIC
BIC(alb.lin)
BIC(alb.log) 
BIC(alb.vb)
# BIC(alb.log) has the lowest value by much more than 2
# so therefore the logistic model is the best fit

#compare using AIC
AIC(alb.lin)
AIC(alb.log)
AIC(alb.vb)
# same conclusions as BIC

