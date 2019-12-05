########## Model fitting example using Non-Linear Least Squares ############
######################### Population growth rate ###########################

# fits three models to generated "data" on the number of bacterial cells as a 
# function of time. It contains three functions, each representing the Baranyi, 
# Buchanan and the modified Gompertz growth model respectively, which are then 
# fitted to the data and plotted. It also generates some starting values for the
# NLLS fittings, derived from the data.

# Author: Lucy Goodyear (lucy.goodyear19@imperial.ac.uk)
# Version: 0.0.1

# clear workspace
rm(list = ls())
graphics.off()

# load neccesary packages
library(repr)
library(minpack.lm) # for Levenberg-Marquardt nlls fitting
library(ggplot2)

# generate some "data" on the number of bacterial cells as a function of time
time <- c(0, 2, 4, 6, 8, 10, 12, 16, 20, 24) # timepoints in hours
log_cells <- c(3.62, 3.62, 3.63, 4.14, 5.23, 6.27, 7.57, 8.38, 8.70, 8.69) # logged cell counts
# set seed to ensure you always get the same random sequence if fluctuations occur
set.seed(1234)
# put data into a dataframe and add some random error to emulate random sampling errors
# these errors are assumed to be normal so we can perform NLLS fits
data <- data.frame(time, log_cells + rnorm(length(time), sd = .1))
# name dataframe columns
names(data) <- c("t", "LogN")
# view data
head(data)

# note that NLLS often converges better if you linearise the data, which
# is why the call counts are logged

# plot the data
ggplot(data, aes(x = t, y = LogN)) +
  geom_point()

# fit three growth models, all of which are known to fit such population
# growth data, especially in microbes
# each of these growth models can be described in terms of:
# N0: initial cell culture (population) density (number of cells per unit volume)
# Nmax: maximum culture density (aka "carrying capacity")
# rmax: maximum growth rate
# tlag: duration of the lag phase before the population starts 
#       growing exponentially

# first specify the models

# Baranyi model (Baranyi 1993)
baranyi_model <- function(t, r_max, N_max, N_0, t_lag){ 
  return(N_max + log10((-1+exp(r_max*t_lag) + exp(r_max*t))/(exp(r_max*t) - 1 + exp(r_max*t_lag) * 10^(N_max-N_0))))
}

# Buchanan model - three phase logistic (Buchanan 1997)
buchanan_model <- function(t, r_max, N_max, N_0, t_lag){
  return(N_0 + (t >= t_lag) * (t <= (t_lag + (N_max - N_0) * log(10)/r_max)) * r_max * (t - t_lag)/log(10) +
           (t >= t_lag) * (t > (t_lag + (N_max - N_0) * log(10)/r_max)) * (N_max - N_0))
}

# Modified gompertz growth model (Zwietering 1990)
gompertz_model <- function(t, r_max, N_max, N_0, t_lag){ 
  return(N_0 + (N_max - N_0) * exp(-exp(r_max * exp(1) * (t_lag - t)/((N_max - N_0) * log(10)) + 1)))
}

# note that the functions have been written in log (to the base 10 but can
# also be base 2 or natural log) scale because we want to do the fitting in
# log scale. 
# the interpretation of the fitted parameters does not change if we take a
# log of the model's equation.

# generate some starting values for NLLS fitting, derived from the data
N_0_start <- min(data$LogN)
N_max_start <- max(data$LogN)
t_lag_start <- data$t[which.max(diff(diff(data$LogN)))]
r_max_start <- max(diff(data$LogN))/mean(diff(data$t))

# now fit the models
fit_baranyi <- nlsLM(LogN ~ baranyi_model(t = t, r_max, N_max, N_0, t_lag), data,
                     list(t_lag=t_lag_start, r_max=r_max_start, N_0 = N_0_start, N_max = N_max_start))

fit_buchanan <- nlsLM(LogN ~ buchanan_model(t = t, r_max, N_max, N_0, t_lag), data,
                      list(t_lag=t_lag_start, r_max=r_max_start, N_0 = N_0_start, N_max = N_max_start))

fit_gompertz <- nlsLM(LogN ~ gompertz_model(t = t, r_max, N_max, N_0, t_lag), data,
                      list(t_lag=t_lag_start, r_max=r_max_start, N_0 = N_0_start, N_max = N_max_start))

# note you may get a warning that one or more of the models generated
# some NaNs during the fitting procedure for the given data but this is can
# be ignored in this case (but not always! Sometimes NaNs mean the equation
# has been written incorrectly or NaNs are generated across the whole range of
# data, which would mean the model is inappropriate for these data).

# get model summaries
summary(fit_baranyi)
summary(fit_buchanan)
summary(fit_gompertz)

# plot data and fits
timepoints <- seq(0, 24, 0.1)

baranyi_points <- baranyi_model(t = timepoints, r_max = coef(fit_baranyi)["r_max"], N_max = coef(fit_baranyi)["N_max"], N_0 = coef(fit_baranyi)["N_0"], t_lag = coef(fit_baranyi)["t_lag"])

buchanan_points <- buchanan_model(t = timepoints, r_max = coef(fit_buchanan)["r_max"], N_max = coef(fit_buchanan)["N_max"], N_0 = coef(fit_buchanan)["N_0"], t_lag = coef(fit_buchanan)["t_lag"])

gompertz_points <- gompertz_model(t = timepoints, r_max = coef(fit_gompertz)["r_max"], N_max = coef(fit_gompertz)["N_max"], N_0 = coef(fit_gompertz)["N_0"], t_lag = coef(fit_gompertz)["t_lag"])

# collect time and predicted log(abundance points) for each model
# into a dataframe
df1 <- data.frame(timepoints, baranyi_points)
df1$model <- "Baranyi"
names(df1) <- c("t", "LogN", "model")

df2 <- data.frame(timepoints, buchanan_points)
df2$model <- "Buchanan"
names(df2) <- c("t", "LogN", "model")

df3 <- data.frame(timepoints, gompertz_points)
df3$model <- "Gompertz"
names(df3) <- c("t", "LogN", "model")

# combine dataframes into one for use in plotting
model_frame <- rbind(df1, df2, df3)

ggplot(data, aes(x = t, y = LogN)) +
  geom_point(size = 3) +
  geom_line(data = model_frame, aes(x = t, y = LogN, col = model), size = 1) +
  theme_bw() + # make the background white
  theme(aspect.ratio=1)+ # make the plot square 
  labs(x = "Time", y = "log(Abundance)")



