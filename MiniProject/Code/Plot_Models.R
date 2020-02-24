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

# load data
metadata_full <-read.csv("../Data/CRat.csv", stringsAsFactors = F)
crd <- read.csv("../Data/CRatMod.csv", stringsAsFactors = F)
# fitting data for GFR and Poly 
#fits <- read.csv("../Data/CRfits1", stringsAsFactors = F)
# fitting data for GFR, Typei and Poly
#fitsh <- read.csv("../Data/CRfits_h0.csv", stringsAsFactors = F)
# fitting data with h >0 for GFR, TypeI and Poly
#fitsh0 <- read.csv("../Data/CRfits_h0.csv", stringsAsFactors = F)
# fitting data with no limit to q
#fitsq <- read.csv("../Data/CRfits_qfree.csv", stringsAsFactors = F)
# fitting data for GRF and Poly (h > 0, q unlimited)
fits <- read.csv("../Data/CRfits.csv", stringsAsFactors = F)

# remove any irrelevant columns from metadata
metadata_sub <- metadata_full[,c("ID", "ResTaxon","ConTaxon", 
            "ResStage", "ConStage", "Res_Thermy",
            "Con_Thermy", "Res_MovementDimensionality",
            "Con_MovementDimensionality", "Habitat", "LabField", 
            "Res_ForagingMovement", "Con_ForagingMovement")]

# given metadata is the same for each ID, subset by first line of each ID
metadata <- metadata_sub[!duplicated(metadata_full[,1]),]
# fix multiple names for same factors in metadata
metadata$LabField[which(metadata$LabField == "lab" | metadata$LabField == "Lab")] <- "Laboratory"
metadata$LabField[which(metadata$LabField == "enclosure")] <- "Enclosure"
metadata$Res_ForagingMovement[which(metadata$Res_ForagingMovement == "Sessile")] <- "sessile"
metadata$Con_ForagingMovement[which(metadata$Con_ForagingMovement == "Sessile")] <- "sessile"

# merge fitting data and metadata into one data frame
meta_fits <- merge(metadata, fits, by = "ID")
#meta_fitsh <- merge(metadata, fitsh, by = "ID")
#meta_fitsh0 <- merge(metadata, fitsh0, by = "ID")
#meta_fitsq <- merge(metadata, fitsq, by = "ID")

# create a list of unique IDs
IDs <- c(unique(meta_fits$ID))

# only keep IDs which had both models fitted (for now)
#na.rm = T

meta_fits <- subset(meta_fits, !is.na(meta_fits$Poly1))
meta_fits <- subset(meta_fits, !is.na(meta_fits$Fit_a))

# create a list of unique IDs
IDs <- c(unique(meta_fits$ID))

#meta_fitsh <- subset(meta_fitsh, !is.na(meta_fitsh$Fit_a))
#meta_fitsh <- subset(meta_fitsh, !is.na(meta_fitsh$Poly1))
#meta_fitsh <- subset(meta_fitsh, !is.na(meta_fitsh$TypeI_a))

#meta_fitsh0 <- subset(meta_fitsh0, !is.na(meta_fitsh0$Poly1))
#meta_fitsh0 <- subset(meta_fitsh0, !is.na(meta_fitsh0$Fit_a))
#meta_fitsh0 <- subset(meta_fitsh0, !is.na(meta_fitsh0$TypeI_a))

# check to see if any datasets had no model fitted and view data points
#nofits <- subset(fits, is.na(fits$Poly1) & !is.na(fits$Fit_a))
#dropd_IDs <- c(unique(nofits$ID))
#for (i in dropd_IDs) {
#  p <- subset(nofits, nofits$ID == i) # subset and plot the data by ID
#  print(qplot(x = p$log_ResDensity, y = p$log_N_TraitValue,
#              xlab = "log of Resource Density", ylab = "Log of Trait Value",
#              main = paste("ID", i)) +
#        geom_point())
#}
# commented out because, in this data, no points had no model fitted


###################### initial plotting of all curves ######################


# define Holling function for plotting
GFR <- function (a, q, h, x) {
  return (a * (x ^ (q + 1)) / (1 + h * a * (x) ^ (q + 1)))
}

# plot all datastes with both GFR and polynomial curves
pdf(paste("../Results/ID_Modelled_Plots.pdf"),
    8, 4.5, onefile = TRUE) # save all plots to one pdf
for (i in IDs) {
  params <- subset(fits, fits$ID == i) # subset and plot the data by ID
  subdata <- subset(crd, crd$ID == i)
  x <- seq(min(subdata$ResDensity), max(subdata$ResDensity), (max(subdata$ResDensity) - min(subdata$ResDensity))/1000) 
  yPoly <- params$Poly1 + params$Poly2*x + 
    params$Poly3*x^2 + (params$Poly4)*x^3
  yGFR <- GFR(params$Fit_a, params$Fit_q, params$Fit_h, x)
  data_to_plot <- data.frame(x, yPoly, yGFR)
  print(ggplot(aes(x = ResDensity,
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
          theme(legend.position="bottom"))
          
}
dev.off()


#################### analysis: GFR vs Poly ###########################


meta_fits$Best_fit_AIC <- NA
meta_fits$Best_fit_BIC <- NA
meta_fits$Best_fit_RSS <- NA
meta_fits$Best_fit <- NA


# set polynomial fit to 1 and GFR fit to 2 to enable faster comparison
# also set Type 1 for later comparison
Poly <- 1
GFR <- 2
Type1 <- 3

# compare AIC and BIC over for each ID to choose best model
for (i in IDs) {
  subs <- subset(meta_fits, meta_fits$ID == i)
  # define differences between best fit parameters
  #if (is.na(subs$Poly1)){
  #  meta_fits$Best_fit[meta_fits$ID == i] = meta_fits$Best_fit_AIC[meta_fits$ID == i] = meta_fits$Best_fit_BIC[meta_fits$ID == i] = meta_fits$Best_fit_RSS[meta_fits$ID == i]<- GFR
  #}
  #  else if (is.na(subs$Fit_a)){
  #  meta_fits$Best_fit[meta_fits$ID == i] = meta_fits$Best_fit_AIC[meta_fits$ID == i] = meta_fits$Best_fit_BIC[meta_fits$ID == i] = meta_fits$Best_fit_RSS[meta_fits$ID == i] <- Poly
  #  }
  #  else {
      deltaAIC <- abs(subs$Poly_AIC - subs$GFR_AIC)
      deltaBIC <- abs(subs$Poly_BIC - subs$GFR_BIC)
      deltaRSS <- abs(subs$Poly_RSS - subs$GFR_RSS)
      
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
    
    # run to see which IDs had all 3 fit tests in agreement
    # overall
    #if ((meta_fits$Best_fit_RSS[IDs == i] == meta_fits$Best_fit_BIC[IDs == i]) & (meta_fits$Best_fit_RSS[IDs == i] == meta_fits$Best_fit_AIC[IDs == i])) {
      #meta_fits$Best_fit[IDs == i] <- meta_fits$Best_fit_RSS[IDs == i]
    #}
    #else {
      #meta_fits$Best_fit[IDs == i] <- "unconfirmed"
    #}
    
    # set which fit is best overall
      if (meta_fits$Best_fit_AIC[meta_fits$ID == i] + meta_fits$Best_fit_BIC[meta_fits$ID == i] + meta_fits$Best_fit_RSS[IDs == i] <= 4) {
        meta_fits$Best_fit[meta_fits$ID == i] <- Poly
      }
      else {
        meta_fits$Best_fit[meta_fits$ID == i] <- GFR
      }
    #}
}

table(meta_fits$Best_fit)

# view those records that the polynomial was the best fit

polyfits <- meta_fits[which(meta_fits$Best_fit == 1),]

abs(polyfits$GFR_AIC - polyfits$Poly_AIC)
abs(polyfits$GFR_BIC - polyfits$Poly_BIC)


######################## comparison plotting #########################


compare <- meta_fits[,-c(14:34)]
compare$Best_fit <- as.factor(compare$Best_fit)

# Habitat
ggplot(data = compare, aes(Habitat, fill = Best_fit)) +
        geom_bar()

# LabField
#ggplot(data = compare, aes(LabField, fill = Best_fit)) +
  #geom_bar()

# ResTaxon
#ggplot(data = compare, aes(ResTaxon, fill = Best_fit)) +
  #geom_bar()

# ConTaxon
#ggplot(data = compare, aes(ConTaxon, fill = Best_fit)) +
  #geom_bar()

# ResStage
#ggplot(data = compare, aes(ResStage, fill = Best_fit)) +
  #geom_bar()

# ConStage
#ggplot(data = compare, aes(ConStage, fill = Best_fit)) +
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
#ggplot(data = compare, aes(Con_ForagingMovement, fill = Best_fit)) +
  #geom_bar()

# Res_ForagingMovement
#ggplot(data = compare, aes(Res_ForagingMovement, fill = Best_fit)) +
  #geom_bar()

####################### attempts at comparing multiple factors at once

#compare[which(#compare$LabField == "Laboratory"),] &
#              #compare$Habitat == "Freshwater"),] # &
 #             compare$Res_MovementDimensionality == "sessile"),]
##              #compare$ResStage == "adult"),]

#dir_compare <- compare[!duplicated(compare[c(2,8:9,12:13)]),c(2,8:9,12:13)]
#dir_compare[!duplicated(dir_compare[c(2:5)]),]

#compare_unique <- as.data.frame(dir_compare %>% group_by(LabField, Habitat) %>%
#                              filter(n() == 1))


#as.data.frame(compare %>% select(Best_fit, Habitat, LabField,Res_MovementDimensionality) %>%
#                          group_by(Best_fit) %>%
#                          group_by(Habitat, LabField, Res_MovementDimensionality) %>%
#                          filter(n() == 1))

#as.data.frame(compare %>% select(Best_fit, Res_MovementDimensionality) %>%
#                group_by(Best_fit) %>%
 #               filter(n() == 1))
##                group_by(Res_MovementDimensionality) %>%


################### comparison of Holling types ##################


# Holling type 1
holling1 <- meta_fits[(meta_fits$Fit_q >= -0.3) & (meta_fits$Fit_q <= 0.3),]
holling1 <- holling1[holling1$Fit_h <= 0.1,]
Holling1 <- 3
meta_fits$Best_fit[meta_fits$ID %in% holling1$ID] <- Holling1

holling1 <- holling1 %>% drop_na(ID)
IDs_holling1 <- holling1$ID

ggplot(data = meta_fits, aes(Best_fit)) +
  geom_bar()

unique(holling1$Con_ForagingMovement)  

table(holling1$Con_ForagingMovement)

table(meta_fits$Con_ForagingMovement, meta_fits$Best_fit)

nrow(polyfits)

# define Holling function for plotting
GFR <- function (a, q, h, x) {
  return (a * (x ^ (q + 1)) / (1 + h * a * (x) ^ (q + 1)))
}

# plot all datastes with both GFR and polynomial curves
pdf(paste("../Results/ID_Modelled_Plots_Holling1.pdf"),
    8, 4.5, onefile = TRUE) # save all plots to one pdf
for (i in IDs_holling1) {
  params <- subset(fits, fits$ID == i) # subset and plot the data by ID
  subdata <- subset(crd, crd$ID == i)
  x <- seq(min(subdata$ResDensity), max(subdata$ResDensity), (max(subdata$ResDensity) - min(subdata$ResDensity))/1000) 
  yPoly <- params$Poly1 + params$Poly2*x + 
    params$Poly3*x^2 + (params$Poly4)*x^3
  yGFR <- GFR(params$Fit_a, params$Fit_q, params$Fit_h, x)
  data_to_plot <- data.frame(x, yPoly, yGFR)
  print(ggplot(aes(x = ResDensity,
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
          theme(legend.position="bottom"))
  
}
dev.off()


# Holling type 2

# define Holling Type II as interval where q ~ 0
holling2 <- meta_fits[(meta_fits$Fit_q >= -0.3) & (meta_fits$Fit_q <= 0.3),]
Holling2 <- 4
meta_fits$Best_fit[meta_fits$ID %in% holling2$ID] <- Holling2
holling2 <- holling2 %>% drop_na(ID)
IDs_holling2 <- holling2$ID


slices <- table(meta_fits$Best_fit)
labls <- c("Poly", "GFR", "Holling1", "Holling2")
pie(slices, labels = labls, 
    #main = "Sessile Consumer Foraging Movement",
    radius = 0.8,
    col = c("red", "blue", "green", "pink"))

par(mfrow = c(2,1), mar = c(0.5,0.5,1,0.5))
sessile <- subset(meta_fits, meta_fits$Con_ForagingMovement == "sessile")
slices <- table(sessile$Best_fit)
labls <- c("GFR", "Holling1", "Holling2")
pie(slices, labels = labls, 
    main = "Sessile Consumer Foraging Movement",
    radius = 0.8,
    col = c("blue", "green", "pink"))
active <- subset(meta_fits, meta_fits$Con_ForagingMovement == "active")
slices <- table(active$Best_fit)
labls <- c("Poly", "GFR", "Holling1", "Holling2")
pie(slices, labels = labls, 
    main = "Active Consumer Foraging Movement",
    radius = 0.8,
    col = c("red", "blue", "green", "pink"))

# compare Holling II factors
unique(holling2$Habitat)
unique(holling2$ResTaxa)
unique(holling2$ConTaxa)
unique(holling2$ResTaxa)
unique(holling2$LabField)
unique(holling2$ResStage)
unique(holling2$ConStage)





  