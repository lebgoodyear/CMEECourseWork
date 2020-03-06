##################################################################
################### PLotting Data and Fits #######################
##################################################################


# Author: Lucy Goodyear (lucy.goodyear19@imperial.ac.uk)
# Version: 0.0.1

# clear workspace
rm(list=ls())


########### initial set up, package and data loading #############


# load packages
library(ggplot2)
library(tidyverse)
library(DescTools) # to perform statistical tests
library(janitor) # to create more flexible tables

# load data
metadata_full <-read.csv("../Data/CRat.csv", stringsAsFactors = F)
crd <- read.csv("../Data/CRatMod.csv",  stringsAsFactors = F)
fits <- read.csv("../Data/CRfits.csv", stringsAsFactors = F)

# only keep relevant columns from metadata
metadata_sub <- metadata_full[,c("ID", 
                                 "Res_Thermy","Con_Thermy", 
                                 "Res_MovementDimensionality",
                                 "Con_MovementDimensionality", 
                                 "Habitat", "LabField", 
                                 "Res_ForagingMovement", "Con_ForagingMovement")]
# given metadata is the same for each ID, subset by first line of each ID
metadata <- metadata_sub[!duplicated(metadata_full[,1]),]
# fix multiple name issues for relevant columns in metadata
metadata$LabField[which(metadata$LabField == "lab" | metadata$LabField == "Lab")] <- "Laboratory"
metadata$LabField[which(metadata$LabField == "enclosure")] <- "Enclosure"
metadata$Res_ForagingMovement[which(metadata$Res_ForagingMovement == "Sessile")] <- "sessile"
metadata$Con_ForagingMovement[which(metadata$Con_ForagingMovement == "Sessile")] <- "sessile"

# merge fitting data and metadata into one data frame
meta_fits <- merge(metadata, fits, by = "ID")
meta_fits <- meta_fits[,-10] # remove numbering column produced in merge

# create a list of unique IDs
IDs <- c(unique(meta_fits$ID))

# view how many IDs have been fitted
length(IDs)


###################### initial plotting of all curves ######################


# define Holling function for plotting
GFR_model <- function (a, q, h, x) {
  return (a * (x ^ (q + 1)) / (1 + h * a * (x) ^ (q + 1)))
}

# plot all datastes with both GFR and polynomial curves
# some datasets will cause warnings but we still want to view these
# pdf(paste("../Results/ID_Modelled_Plots.pdf"),
#     8, 4.5, onefile = TRUE) # save all plots to one pdf
# for (i in IDs) {
#   # subset params and data separately for clarity
#   params <- subset(fits, fits$ID == i)
#   subdata <- subset(crd, crd$ID == i)
#   # define sequence of x-values
#   x <- seq(min(subdata$ResDensity), max(subdata$ResDensity), (max(subdata$ResDensity) - min(subdata$ResDensity))/1000)
#   # define polynomial on x-values using fit parameters
#   yPoly <- params$Poly1 + params$Poly2*x +
#     params$Poly3*x^2 + (params$Poly4)*x^3
#   # define GFR on x-values using fit parameters
#   yGFR <- GFR_model(params$Fit_a, params$Fit_q, params$Fit_h, x)
#   data_to_plot <- data.frame(x, yPoly, yGFR) # save to dataframe
#   # plot ID with both models
#   print(ggplot(aes(x = ResDensity,
#                    y = N_TraitValue),
#                data = subdata) +
#           ggtitle(paste("ID", i)) +
#           xlab("Resource Density") +
#           ylab("Trait Value") +
#           geom_point() +
#           geom_line(data = data_to_plot,
#                     mapping = aes(x, y = yPoly, colour = "Polynomial")) +
#           geom_line(data = data_to_plot,
#                     mapping = aes(x, y = yGFR, colour = "Generalised Functional Response")) +
#           scale_colour_manual("",
#                     breaks = c("Polynomial", "Generalised Functional Response"),
#                     values = c("red", "blue")) +
#           theme(legend.position="bottom"))
# }
# dev.off()
# this is not needed for report so has been commented out

# subset those IDs where only model was fitted and view IDs
meta_fits_onlypoly <- subset(meta_fits, is.na(meta_fits$Poly1))
meta_fits_onlyGFR <- subset(meta_fits, is.na(meta_fits$Fit_a))
meta_fits_onlypoly$ID
meta_fits_onlyGFR$ID

# review plots and remove IDs that look like
# an error has occured during fitting or those 
# that were obviously not fitted correctly
meta_fits <- subset(meta_fits, ID != 351)
meta_fits <- subset(meta_fits, ID != 39902)
meta_fits <- subset(meta_fits, ID != 39903)
meta_fits <- subset(meta_fits, ID != 39910)
meta_fits <- subset(meta_fits, ID != 39911)
meta_fits <- subset(meta_fits, ID != 39924)
meta_fits <- subset(meta_fits, ID != 39939)
meta_fits <- subset(meta_fits, ID != 39940)
meta_fits <- subset(meta_fits, ID != 39975)
meta_fits <- subset(meta_fits, ID != 39976)
meta_fits <- subset(meta_fits, ID != 40098)
meta_fits <- subset(meta_fits, ID != 40102)
meta_fits <- subset(meta_fits, ID != 40108)
meta_fits <- subset(meta_fits, ID != 40109)
meta_fits <- subset(meta_fits, ID != 40110)

# create new list of unique IDs
IDs <- c(unique(meta_fits$ID))

# view how many IDs are left
length(IDs)


#################### compare AIC, BIC and RSS ###########################


# initialise empty columns
meta_fits$Best_fit_AIC <- NA
meta_fits$Best_fit_BIC <- NA
meta_fits$Best_fit_RSS <- NA
meta_fits$Best_fit <- NA

# set polynomial fit to 1 and GFR fit to 2 to enable faster comparison
# also set Types 1 and 2 to and 4 respectively for later comparison
Poly <- 1
GFR <- 2
HollingType1 <- 3
HollingType2 <- 4

# set best fits for those IDs where only one model was fitted
meta_fits$Best_fit[meta_fits$ID %in% meta_fits_onlypoly$ID] <- Poly
meta_fits$Best_fit[meta_fits$ID %in% meta_fits_onlyGFR$ID] <- GFR

# compare AIC and BIC over for each ID to choose best model
for (i in IDs) {
  # if statement to ignore the IDs where only one model was fitted
  if ((!(i %in% meta_fits_onlyGFR$ID)) & (!(i %in% meta_fits_onlypoly$ID))) {
    subs <- subset(meta_fits, meta_fits$ID == i) # subset data
    # define differences between AIC, BIC and RSS
    deltaAIC <- abs(subs$Poly_AIC - subs$GFR_AIC)
    deltaBIC <- abs(subs$Poly_BIC - subs$GFR_BIC)
    deltaRSS <- subs$Poly_RSS - subs$GFR_RSS
    
    # if statements to set best fit model for ID i depending on test
    # AIC
    if (deltaAIC < 2) {
      meta_fits$Best_fit_AIC[meta_fits$ID == i] <- Poly 
    } else {
      meta_fits$Best_fit_AIC[meta_fits$ID == i] <- GFR
    }
    # BIC
    if (deltaBIC < 2) {
      meta_fits$Best_fit_BIC[meta_fits$ID == i] <- Poly
    }
    else {
      meta_fits$Best_fit_BIC[meta_fits$ID == i] <- GFR 
    }
    # RSS
    if (deltaRSS < 0) {
      meta_fits$Best_fit_RSS[meta_fits$ID == i] <- Poly
    }
    else {
      meta_fits$Best_fit_RSS[meta_fits$ID == i] <- GFR
    }
    
    # set which fit is best overall
    if (meta_fits$Best_fit_AIC[meta_fits$ID == i] + meta_fits$Best_fit_BIC[meta_fits$ID == i] + meta_fits$Best_fit_RSS[IDs == i] <= 4) {
      meta_fits$Best_fit[meta_fits$ID == i] <- Poly
    }
    else {
      meta_fits$Best_fit[meta_fits$ID == i] <- GFR
    }
  }
}

# view spread of best fits over the 2 models
table(meta_fits$Best_fit)


######################## filter data into Holling types #######################


# subset by those best fitted by GFR
meta_fits_GFR <- meta_fits[meta_fits$Best_fit == GFR,]
# define Holling Type II as q ~ 0
holling2 <- meta_fits_GFR[(meta_fits_GFR$Fit_q >= -0.5) & (meta_fits_GFR$Fit_q <= 0.5),]
# change best fit of IDs that match Holling Type II definition
meta_fits$Best_fit[meta_fits$ID %in% holling2$ID] <- HollingType2
holling2 <- holling2 %>% drop_na(ID)
IDs_holling2 <- holling2$ID # create list of Holling Type II IDs

# define Holling Type I as q ~ 0 and h < 0.1
holling1 <- meta_fits_GFR[(meta_fits_GFR$Fit_q >= -0.3) & (meta_fits_GFR$Fit_q <= 0.3),]
holling1 <- holling1[holling1$Fit_h <= 0.1,]
# change best fit of IDs that match Holling Type I definition
meta_fits$Best_fit[meta_fits$ID %in% holling1$ID] <- HollingType1
holling1 <- holling1 %>% drop_na(ID)
IDs_holling1 <- holling1$ID # create list of Holling Type I IDs

# view spread of best fits over the 4 models
table(meta_fits$Best_fit)

# plot all datasets with both GFR and polynomial curves best fitted by Holling II
# pdf(paste("../Results/ID_Modelled_Plots_Holling2.pdf"),
#     8, 4.5, onefile = TRUE) # save all plots to one pdf
# for (i in IDs_holling2) {
#   # subset params and data separately for clarity
#   params <- subset(fits, fits$ID == i)
#   subdata <- subset(crd, crd$ID == i)
#   # define sequence of x-values
#   x <- seq(min(subdata$ResDensity), max(subdata$ResDensity), (max(subdata$ResDensity) - min(subdata$ResDensity))/1000)
#   # define polynomial on x-values using fit parameters
#   yPoly <- params$Poly1 + params$Poly2*x +
#     params$Poly3*x^2 + (params$Poly4)*x^3
#   # define GFR on x-values using fit parameters
#   yGFR <- GFR_model(params$Fit_a, params$Fit_q, params$Fit_h, x)
#   data_to_plot <- data.frame(x, yPoly, yGFR) # save to dataframe
#   # plot ID with both models
#   print(ggplot(aes(x = ResDensity,
#                    y = N_TraitValue),
#                data = subdata) +
#           ggtitle(paste("ID", i)) +
#           xlab("Resource Density") +
#           ylab("Trait Value") +
#           geom_point() +
#           geom_line(data = data_to_plot,
#                     mapping = aes(x, y = yPoly, colour = "Polynomial")) +
#           geom_line(data = data_to_plot,
#                     mapping = aes(x, y = yGFR, colour = "Generalised Functional Response")) +
#           scale_colour_manual("",
#                               breaks = c("Polynomial", "Generalised Functional Response"),
#                               values = c("red", "blue")) +
#           theme(legend.position="bottom"))
# 
# }
# dev.off()
# this is not needed for report so has been commented out

# plot all datasets with both GFR and polynomial curves best fitted by Holling I
# pdf(paste("../Results/ID_Modelled_Plots_Holling1.pdf"),
#     8, 4.5, onefile = TRUE) # save all plots to one pdf
# for (i in IDs_holling1) {
#   # subset params and data separately for clarity
#   params <- subset(fits, fits$ID == i)
#   subdata <- subset(crd, crd$ID == i)
#   # define sequence of x-values
#   x <- seq(min(subdata$ResDensity), max(subdata$ResDensity), (max(subdata$ResDensity) - min(subdata$ResDensity))/1000)
#   # define polynomial on x-values using fit parameters
#   yPoly <- params$Poly1 + params$Poly2*x +
#     params$Poly3*x^2 + (params$Poly4)*x^3
#   # define GFR on x-values using fit parameters
#   yGFR <- GFR_model(params$Fit_a, params$Fit_q, params$Fit_h, x)
#   data_to_plot <- data.frame(x, yPoly, yGFR)
#   print(ggplot(aes(x = ResDensity,
#                    y = N_TraitValue),
#                data = subdata) +
#           ggtitle(paste("ID", i)) +
#           xlab("Resource Density") +
#           ylab("Trait Value") +
#           geom_point() +
#           geom_line(data = data_to_plot,
#                     mapping = aes(x, y = yPoly, colour = "Polynomial")) +
#           geom_line(data = data_to_plot,
#                     mapping = aes(x, y = yGFR, colour = "Generalised Functional Response")) +
#           scale_colour_manual("",
#                               breaks = c("Polynomial", "Generalised Functional Response"),
#                               values = c("red", "blue")) +
#           theme(legend.position="bottom"))
# 
# }
# dev.off()
# this is not needed for report so has been commented out


##################### plot overall best fits as frequencies ######################


# bar chart comparing the different best fits overall
pdf(paste("../Results/Model_Comparison_Barchart.pdf"),
    8, 5)
ggplot(data = meta_fits, aes(factor(Best_fit)), col = "grey70") +
geom_bar() +
labs(x = "Fit type", y = "Count") +
scale_x_discrete(labels = c("1" = "Polynomial", "2" = "Generalised \nFunctional \nResponse", "3" = "Holling Type 1", "4" = "Holling Type 2")) +
theme_bw() +
theme(plot.margin = margin(10,10,10,10,"pt")) +
geom_text(stat = 'count', aes(label=paste0(label=stat(count),' (',round(stat(prop)*100, digits = 1),'%)'), group=1), 
          vjust = -0.6, cex = 3.2) +
expand_limits(y = 150)
dev.off()


#################### compare phenomenological and mechanistic models ################


# Create new column and define each ID as Phenomenological or Mechanistic
for (i in IDs){
  if (meta_fits$Best_fit[meta_fits$ID == i] == Poly){
    meta_fits$Pheno_Mech[meta_fits$ID == i] <- "Phenomenological"
  }
  else {
    meta_fits$Pheno_Mech[meta_fits$ID == i] <- "Mechanistic"
  }
}

# perform statistical tests to see significance of proportion of fits 
# G-test
observed <- as.vector(table(meta_fits$Pheno_Mech))
expected <- c(0.5,0.5)
library(DescTools)
GTest(x=observed,
      p=expected,
      correct="none") 
# Chi-sqaure test
chisq.test(x = observed,
           p = expected)


######################## Compare subsets by field #########################


# remove irrlevant fitting parameter columns
compare <- meta_fits[,-c(10:25,27)]
compare$Best_fit <- as.factor(compare$Best_fit) # set best fit as factor

# Habitat
#habitat <- ggplot(data = compare, aes(Habitat, fill = Best_fit)) +
#  geom_bar()

# LabField
#labfield <- ggplot(data = compare, aes(LabField, fill = Best_fit)) +
#geom_bar()

# Res_Thermy
#ggplot(data = compare, aes(Res_Thermy, fill = Best_fit)) +
#geom_bar()

# Con_Thermy
#ggplot(data = compare, aes(Con_Thermy, fill = Best_fit)) +
#geom_bar()

# Res_MovementDimensionality
#ggplot(data = compare, aes(Res_MovementDimensionality, fill = Best_fit)) +
#geom_bar()

# Con_MovementDimensionality
#ggplot(data = compare, aes(Con_MovementDimensionality, fill = Best_fit)) +
#geom_bar()

# Con_ForagingMovement
#con_foraging <- ggplot(data = compare, aes(Con_ForagingMovement, fill = Best_fit)) +
#geom_bar()

# Res_ForagingMovement
#res_foraging <- ggplot(data = compare, aes(Res_ForagingMovement, fill = Best_fit)) +
#geom_bar()

# plots commented out as show no trends
# put information as table instead for report

# use janitor and tidyverse to create a handy table showing the above information 
# for four example fields, as well percentages and compare to data overall

# consumer forgaing movement by best fit
con_movement_tab <- meta_fits %>%
                    tabyl(Con_ForagingMovement, Best_fit) %>% # create table
                    adorn_totals("row") %>% # add total counts
                    adorn_percentages("row") %>% # add percentages
                    adorn_pct_formatting(rounding = "half up", digits = 0) %>% # round to 2dp
                    adorn_ns() %>% # add counts
                    # rename columns
                    rename("Consumer Foraging Movement" = "Con_ForagingMovement", 
                           "Poly" = "1", 
                           "GFR" = "2",
                           "Holling 1" = "3", 
                           "Holling 2" = "4")

# resource foraging movement by best fit
res_movement_tab <- meta_fits %>%
                    tabyl(Res_ForagingMovement, Best_fit) %>%
                    adorn_totals("row") %>%
                    adorn_percentages("row") %>% 
                    adorn_pct_formatting(rounding = "half up", digits = 0) %>%
                    adorn_ns() %>%
                    rename("Resource Foraging Movement" = "Res_ForagingMovement", 
                           "Poly" = "1", 
                           "GFR" = "2",
                           "Holling 1" = "3", 
                           "Holling 2" = "4")

# habitat by best fit
habitat_tab <- meta_fits %>%
               tabyl(Habitat, Best_fit) %>%
               adorn_totals("row") %>%
               adorn_percentages("row") %>% 
               adorn_pct_formatting(rounding = "half up", digits = 0) %>%
               adorn_ns() %>%
               rename("Habitat" = "Habitat", 
                     "Poly" = "1", 
                     "GFR" = "2",
                     "Holling 1" = "3", 
                     "Holling 2" = "4")

# experimental conditions (lab/field/enclosure) by best fit
labfield_tab <- meta_fits %>%
                tabyl(LabField, Best_fit) %>%
                adorn_totals("row") %>%
                adorn_percentages("row") %>% 
                adorn_pct_formatting(rounding = "half up", digits = 0) %>%
                adorn_ns() %>%
                rename("Experimental Conditions" = "LabField", 
                       "Poly" = "1", 
                       "GFR" = "2",
                       "Holling 1" = "3", 
                       "Holling 2" = "4")

# write tables to csv files
write.csv(con_movement_tab, "../Results/con_movement_table.csv", quote = F)
write.csv(res_movement_tab, "../Results/res_movement_table.csv", quote = F)
write.csv(habitat_tab, "../Results/habitat_table.csv", quote = F)
write.csv(labfield_tab, "../Results/labfield_table.csv", quote = F)


############### compare consumer feeding modes for Holling Type I #################

# view IDs best fit by Holling Type I
holling1$ID
# set best fit to factor
holling1$Best_fit <- as.factor(holling1$Best_fit) 

# set yes/no to 1 and 2 for easier comparison
Filter_Feeder <- 1
Non_Filter_Feeder <- 2

# set feeding mode for IDs best fit by Holling I
holling1$Con_FeedingMode <- Non_Filter_Feeder
holling1$Con_FeedingMode[holling1$ID == 40010] <- Filter_Feeder
holling1$Con_FeedingMode[holling1$ID == 40019] <- Filter_Feeder
holling1$Con_FeedingMode[holling1$ID == 40026] <- Filter_Feeder
holling1$Con_FeedingMode[holling1$ID == 40121] <- Filter_Feeder


# view spread of best fits over filter and non-filter feeders for Holling Type I
table(holling1$Con_FeedingMode)

# perform statistical tests to see significance of proportion of fits for 
# filter feeder vs non-filter feeder consumers

# G-test
observed <- c(4,11)
expected <- c(1,0)
GTest(x=observed,
      p=expected,
      correct="none") 


############################### Plot example curves ###############################


# example of non-filter feeder ID with Holling Type I best fit
i <- 39920
params <- subset(fits, fits$ID == i) # subset and plot the data by ID
subdata <- subset(crd, crd$ID == i)
x <- seq(min(subdata$ResDensity), 
         max(subdata$ResDensity), 
         (max(subdata$ResDensity) - min(subdata$ResDensity))/1000) 
yPoly <- params$Poly1 + params$Poly2*x + 
         params$Poly3*x^2 + (params$Poly4)*x^3
yGFR <- GFR_model(params$Fit_a, params$Fit_q, params$Fit_h, x)
data_to_plot <- data.frame(x, yPoly, yGFR)
# plot
pdf(paste("../Results/Holling1_example.pdf"),
    8, 5)
ggplot(aes(x = ResDensity,
                 y = N_TraitValue),
             data = subdata) +
        xlab("Resource Density") + 
        ylab("Trait Value") +
        geom_point() +
        geom_line(data = data_to_plot, 
                  mapping = aes(x, y = yPoly, colour = "Polynomial")) +
        geom_line(data = data_to_plot,
                  mapping = aes(x, y = yGFR, colour = "Generalised Functional Response")) +
        scale_colour_manual("", 
                            breaks = c("Polynomial", "Generalised Functional Response"),
                            values = c("red", "blue")) +
        theme_bw() +
        theme(legend.position="bottom")
dev.off()

# example of ID with GFR as best fit but looks like Holling Type II shape
i <- 39864
params <- subset(fits, fits$ID == i) # subset and plot the data by ID
subdata <- subset(crd, crd$ID == i)
x <- seq(min(subdata$ResDensity), 
         max(subdata$ResDensity), 
         (max(subdata$ResDensity) - min(subdata$ResDensity))/1000) 
yPoly <- params$Poly1 + params$Poly2*x + 
         params$Poly3*x^2 + (params$Poly4)*x^3
yGFR <- GFR_model(params$Fit_a, params$Fit_q, params$Fit_h, x)
data_to_plot <- data.frame(x, yPoly, yGFR)
# plot
pdf(paste("../Results/GFR_Holling2_example.pdf"),
    8, 5)
ggplot(aes(x = ResDensity,
           y = N_TraitValue),
       data = subdata) +
  xlab("Resource Density") + 
  ylab("Consumption Rate") +
  geom_point() +
  geom_line(data = data_to_plot, 
            mapping = aes(x, y = yPoly, colour = "Polynomial")) +
  geom_line(data = data_to_plot,
            mapping = aes(x, y = yGFR, colour = "Generalised Functional Response")) +
  scale_colour_manual("", 
                      breaks = c("Polynomial", "Generalised Functional Response"),
                      values = c("red", "blue")) +
  theme_bw() +
  theme(legend.position="bottom")
dev.off()

# end of script
