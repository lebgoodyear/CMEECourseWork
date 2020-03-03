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
library(tidyr)
library(dplyr)

# load data
metadata_full <-read.csv("../Data/CRat.csv", stringsAsFactors = F)
crd <- read.csv("../Data/CRatMod.csv", stringsAsFactors = F)
fits <- read.csv("../Data/CRfits.csv", stringsAsFactors = F)

# remove any irrelevant columns from metadata
metadata_sub <- metadata_full[,c("ID", "Con_ForagingMovement")]

# given metadata is the same for each ID, subset by first line of each ID
metadata_sub <- metadata_sub[!duplicated(metadata_full[,1]),]
# fix multiple names for same factors in metadata
metadata_sub$Con_ForagingMovement[which(metadata_sub$Con_ForagingMovement == "sessile")] <- "Sessile"
metadata_sub$Con_ForagingMovement[which(metadata_sub$Con_ForagingMovement == "active")] <- "Active"

# merge fitting data and metadata into one data frame
meta_fits <- merge(metadata_sub, fits, by = "ID")

# only keep IDs which had both models fitted because these data sets 
# all have a range of y-values per x-value so cannot be fitted properly
meta_fits <- subset(meta_fits, !is.na(meta_fits$Poly1))
meta_fits <- subset(meta_fits, !is.na(meta_fits$Fit_a))

# create a list of unique IDs
IDs <- c(unique(meta_fits$ID))


###################### initial plotting of all curves ######################


# define Holling function for plotting
GFR_model <- function (a, q, h, x) {
  return (a * (x ^ (q + 1)) / (1 + h * a * (x) ^ (q + 1)))
}

# plot all datastes with both GFR and polynomial curves
# pdf(paste("../Results/ID_Modelled_Plots.pdf"),
#     8, 4.5, onefile = TRUE) # save all plots to one pdf
# for (i in IDs) {
#   params <- subset(fits, fits$ID == i) # subset and plot the data by ID
#   subdata <- subset(crd, crd$ID == i)
#   x <- seq(min(subdata$ResDensity), max(subdata$ResDensity), (max(subdata$ResDensity) - min(subdata$ResDensity))/1000) 
#   yPoly <- params$Poly1 + params$Poly2*x + 
#     params$Poly3*x^2 + (params$Poly4)*x^3
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
#                     breaks = c("Polynomial", "Generalised Functional Response"),
#                     values = c("red", "blue")) +
#           theme(legend.position="bottom"))
#           
# }
# dev.off()
# this is not needed for report so has been commented out


#################### Compare AIC, BIC and RSS ###########################


# initialise empty columns
meta_fits$Best_fit_AIC <- NA
meta_fits$Best_fit_BIC <- NA
meta_fits$Best_fit_RSS <- NA
meta_fits$Best_fit <- NA

# set polynomial fit to 1 and GFR fit to 2 to enable faster comparison
# also set Types 1 and 2 for later comparison
Poly <- 1
GFR <- 2
HollingType1 <- 3
HollingType2 <- 4

# compare AIC and BIC over for each ID to choose best model
for (i in IDs) {
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

table(meta_fits$Best_fit)

# view those records that the polynomial was the best fit

polyfits <- meta_fits[which(meta_fits$Best_fit == 1),]

abs(polyfits$GFR_AIC - polyfits$Poly_AIC)
abs(polyfits$GFR_BIC - polyfits$Poly_BIC)


######################## filter data into Holling types #######################

meta_fits_GFR <- meta_fits[meta_fits$Best_fit == GFR,]
# define Holling Type II as interval where q ~ 0
holling2 <- meta_fits_GFR[(meta_fits_GFR$Fit_q >= -0.3) & (meta_fits_GFR$Fit_q <= 0.3),]
meta_fits$Best_fit[meta_fits$ID %in% holling2$ID] <- HollingType2
holling2 <- holling2 %>% drop_na(ID)
IDs_holling2 <- holling2$ID

# define Holling type 1 as intervale where q ~ 0 and h < 0.1
holling1 <- meta_fits_GFR[(meta_fits_GFR$Fit_q >= -0.3) & (meta_fits_GFR$Fit_q <= 0.3),]
holling1 <- holling1[holling1$Fit_h <= 0.1,]
meta_fits$Best_fit[meta_fits$ID %in% holling1$ID] <- HollingType1
holling1 <- holling1 %>% drop_na(ID)
IDs_holling1 <- holling1$ID

table(meta_fits$Best_fit)
# plot Holling Type I

# plot all datastes with both GFR and polynomial curves
# pdf(paste("../Results/ID_Modelled_Plots_Holling1.pdf"),
#     8, 4.5, onefile = TRUE) # save all plots to one pdf
# for (i in IDs_holling1) {
#   params <- subset(fits, fits$ID == i) # subset and plot the data by ID
#   subdata <- subset(crd, crd$ID == i)
#   x <- seq(min(subdata$ResDensity), max(subdata$ResDensity), (max(subdata$ResDensity) - min(subdata$ResDensity))/1000) 
#   yPoly <- params$Poly1 + params$Poly2*x + 
#     params$Poly3*x^2 + (params$Poly4)*x^3
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


##################### Plot overall best fits as frequencies ######################


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
expand_limits(y = 190)
dev.off()

table(meta_fits$Best_fit)


#################### Compare phenomenological and mechanistic models ################


# Create new column and define each ID as Phenomenological or Mechanistic
for (i in IDs){
  if (meta_fits$Best_fit[meta_fits$ID == i] == Poly){
    meta_fits$Pheno_Mech[meta_fits$ID == i] <- "Phenomenological"
  }
  else {
    meta_fits$Pheno_Mech[meta_fits$ID == i] <- "Mechanistic"
  }
}

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

# Fisher Exact test
fisher_data <- as.vector(table(meta_fits$Pheno_Mech))
fisher_data2 <- cbind(observed, c((observed[1]+observed[2])/2,(observed[1]+observed[2])/2))
fisher.test(fisher_data2, alternative = "two.sided")


############### Compare consumer foraging movement for Holling Type I #################

meta_fits$Best_fit <- as.factor(meta_fits$Best_fit)

table(holling1$Con_ForagingMovement)
t <- as.data.frame.matrix(table(meta_fits$Con_ForagingMovement, meta_fits$Best_fit))
names(t) <- c("Polynomial", "Generalised Functional Response","Holling Type 1", "Holling Type 2")
t <- rbind(t, prop.table(t))
write.csv(t, "../Results/sessile_vs_active_table.csv", quote = F)

require(janitor)
sess_vs_act <- meta_fits %>%
                           tabyl(Con_ForagingMovement, Best_fit) %>%
                           adorn_totals("row") %>%
                           adorn_percentages("row") %>% 
                           adorn_pct_formatting(rounding = "half up", digits = 0) %>%
                           adorn_ns() %>%
                           rename("Consumer Foraging Movement" = "Con_ForagingMovement", 
                                  "Poly" = "1", 
                                  "GFR" = "2",
                                  "Holling 1" = "3", 
                                  "Holling 2" = "4")
write.csv(sess_vs_act, "../Results/sessilevsactivetable.csv", quote = F)


# Plot comparison of best fits for Consumer Foraging Movement

pdf(paste("../Results/ConForaging_Comparison_Barchart.pdf"),
    6, 4)
ggplot(data = meta_fits, aes(factor(Con_ForagingMovement), fill = factor(Best_fit))) +
labs(x = "Consumer Foraging Movement", y = "Count") +
scale_fill_manual(name = "Best Fit", 
                  labels = c("Polynomial", "Generalised Functional Response","Holling Type 1", "Holling Type 2"), 
                  values = c("black","grey70","grey50", "grey30")) +
geom_bar() +
coord_flip() +
theme_bw() +
theme(plot.margin = margin(10,10,10,10,"pt")) +
expand_limits(y = 190) +
theme(legend.position="bottom") +
guides(fill=guide_legend(nrow=2,byrow=TRUE)) # put legend on two lines
dev.off()

# par(mfrow = c(1,2))
# sessile = meta_fits[which(meta_fits$Con_ForagingMovement == "sessile"),]
# ggplot(data = sessile, aes(factor(Best_fit)), col = "grey70") +
#   geom_bar() +
#   labs(x = "Fit type", y = "Count") +
#   scale_x_discrete(labels = c("1" = "Polynomial", "2" = "Generalised \nFunctional \nResponse", "3" = "Holling Type 1", "4" = "Holling Type 2")) +
#   theme_bw() +
#   theme(plot.margin = margin(10,10,10,10,"pt")) +
#   geom_text(stat = 'count', aes(label=stat(count)), 
#             vjust = -0.6, cex = 3.2, nudge_x = -0.22) +
#   geom_text(stat = 'count', aes(label=paste0('(',round(stat(prop)*100, digits = 1),'%)'), group=1), 
#             vjust = -0.6, cex = 3.2, nudge_x = 0.22) +
#   expand_limits(y = 35)
# 
# active = meta_fits[which(meta_fits$Con_ForagingMovement == "active"),]
# ggplot(data = active, aes(factor(Best_fit)), col = "grey70") +
#   geom_bar() +
#   labs(x = "Fit type", y = "Count") +
#   scale_x_discrete(labels = c("1" = "Polynomial", "2" = "Generalised \nFunctional \nResponse", "3" = "Holling Type 1", "4" = "Holling Type 2")) +
#   theme_bw() +
#   theme(plot.margin = margin(10,10,10,10,"pt")) +
#   geom_text(stat = 'count', aes(label=stat(count)), 
#             vjust = -0.6, cex = 3.2, nudge_x = -0.22) +
#   geom_text(stat = 'count', aes(label=paste0('(',round(stat(prop)*100, digits = 1),'%)'), group=1), 
#             vjust = -0.6, cex = 3.2, nudge_x = 0.22) +
#   expand_limits(y = 150)

# perform statistical tests

# G-test
observed <- c(18,6)
expected <- c(0,1)
library(DescTools)
GTest(x=observed,
      p=expected,
      correct="none") 

# Chi-sqaure test
chisq.test(x = observed,
           p = expected)

# Fisher Exact Test to compare phenomenological and mechanistic models
table(holling1$Con_ForagingMovement)
fisher_data_mvmnt <- table(meta_fits$Con_ForagingMovement, meta_fits$Best_fit)
fisher_data_mvmnt <- as.data.frame(fisher_data_mvmnt)
fisher_data_mvmnt <- as.matrix(cbind(fisher_data_mvmnt$Var2, fisher_data_mvmnt$Freq))

a <- c(2,147,18,54)
b <- c(0,31,6,16)
c <- rbind(a, b)

#fisher_data <- matrix(unlist(data.frame(fisher_data_mvmnt)),2) 
fisher.test(c, alternative = "two.sided")

# see which IDs are non-filter feeders but Holling Type 1 is best fit
# see whether they are classed as filter feeders by Jescke
meta_fits$ID[which(meta_fits$Best_fit == HollingType1 & meta_fits$Con_ForagingMovement == "active")]

holling1_active <- holling1[(which(holling1$Con_ForagingMovement == "active")),]
holling1_active$ID

############################### Plot example curves ###############################

# example of Holling1 active
i <- 40010
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
        ggtitle(paste("ID", i)) +
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
        theme(legend.position="bottom")
dev.off()

# example of GFR where looks like Holling 2
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
  ggtitle(paste("ID", i)) +
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
  theme(legend.position="bottom")
dev.off()

