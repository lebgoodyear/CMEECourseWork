################### Calculating a linear model for predator and prey masses #####################
############################ by feeding type and predator lifestage #############################

# Plots graphs from predator and prey size data, including linear regressions,
# differentiated by predator lifestage, facected by type of feeding interaction and saves to pdf.
# Calculates regression results corresponding to the lines fitted in the figure and saves as
# csv demlimited table.

# imports
library(ggplot2)
library(dplyr)

# load the data
MyDF <- read.csv("../Data/EcolArchives-E089-51-D1.csv")
dim(MyDF) # check the size of the data frame you loaded

pdf("../Results/PP_Regress.pdf", # open blank pdf page using a relative path
    8.3, 11.7)  # page dimensions in inches

# plot the predator and prey mass by feeding type and predator lifestage using the linear model method
qplot(Prey.mass, Predator.mass, data = MyDF, log="xy",
      xlab = "Prey mass in grams",
      ylab = "Predator mass in grams",
      colour = Predator.lifestage, shape = I(3)) +
      geom_smooth(method = "lm",fullrange = TRUE) + # plot linear regressions
      facet_grid(Type.of.feeding.interaction~.) + # all plots on the same grid
      theme_bw() %+replace% 
      theme(legend.position = "bottom",
            panel.border = element_rect(colour = "grey", fill = NA)) +
      guides(colour = guide_legend(nrow = 1)) + # put legend on one line
      theme(legend.title = element_text(size = 9, face="bold"))

graphics.off() # close all open devices/windows

# calculate the regression results corresponding to the lines fitted in the figure
LM <- MyDF %>% 
         # first remove subset that contains only 2 examples, both with same species of prey and predator, 
         # because f-statistic can't be calculated on this (and no linear regression line can be drawn)
         filter(Record.number != "30914" & Record.number != "30929") %>%
         # subset only the data needed and group by feeeding type and predator lifestage
         select(Record.number, Predator.mass, Prey.mass, Predator.lifestage, Type.of.feeding.interaction) %>%
         group_by(Type.of.feeding.interaction, Predator.lifestage) %>%
         # do linear model calculations and store specific values as columns to dataframe
         do(mod=lm(Predator.mass ~ Prey.mass, data = .)) %>%
         mutate(Regression.slope = summary(mod)$coeff[2],
                Regression.intercept = summary(mod)$coeff[1],
                R.squared = summary(mod)$adj.r.squared,
                Fstatistic = summary(mod)$fstatistic[1],
                P.value = summary(mod)$coeff[8]) %>%
         select(-mod) # remove column created by mod=lm command

# save the regression results to a csv delimited table
write.csv(LM, "../Results/PP_Regress_Results.csv")
