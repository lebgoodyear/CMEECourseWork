######## Mathematical notation on an axis and in plot area ##############

# performs a linear regression on some sample data, plots the data with 
# the regression line and then annotates the plot with a mathematical equation.

# clear workspace
rm(list=ls())

# imports
library(ggplot2)

# create some linear regression data
x <- seq(0, 100, by = 0.1)
y <- -4. + 0.25*x + 
    rnorm(length(x), mean = 0., sd = 2.5)

# put data in a dataframe
my_data <- data.frame(x = x, y = y)

# perform a linear regression
my_lm <- summary(lm(y ~ x, data = my_data))

# plot the data
p <- ggplot(my_data, aes(x = x, 
                         y = y,
                         colour = abs(my_lm$residual))) +
            geom_point() +
            scale_colour_gradient(low = "black", high = "red") +
            theme(legend.position = "none") +
            scale_x_continuous(expression(alpha^2 * pi / beta * sqrt(Theta)))

# add regresssion line
p <- p + geom_abline(intercept = my_lm$coefficients[1][1],
                     slope = my_lm$coefficients[2][1],
                     colour = "red")

# put the mathematical equation on the plot
p <- p + geom_text(aes(x = 60,
                       y = 0,
                       label = "sqrt(alpha) * 2 * pi"),
                       parse = TRUE,
                       size = 6,
                       colour = "blue")

# save result into a pdf
pdf("../Results/MyLinReg.pdf")
p + ggtitle("Plot with mathematical display")
dev.off()

