################################################################
################## Wrangling the Pound Hill Dataset ############
################################################################

require(dplyr)
require(tidyr)

############# Load the dataset ###############
# header = false because the raw data don't have real headers
MyData <- as.matrix(read.csv("../Data/PoundHillData.csv",header = F)) 

# header = true because we do have metadata headers
MyMetaData <- read.csv("../Data/PoundHillMetaData.csv",
                       header = T, 
                       sep=";", 
                       stringsAsFactors = F)

############# Inspect the dataset ###############
head(MyData)
dim(MyData)
glimpse(MyData) # in dplyr package, like str() but tidier
#fix(MyData) #you can also do this
#fix(MyMetaData)

############# Transpose ###############
# To get those species into columns and treatments into rows 
MyData <- t(MyData) 
head(MyData)
dim(MyData)

############# Replace species absences with zeros ###############
MyData[MyData == ""] = 0

############# Convert raw matrix to data frame ###############

TempData <- as.data.frame(MyData[-1,],stringsAsFactors = F) #stringsAsFactors = F is important!
colnames(TempData) <- MyData[1,] # assign column names from original data

############# Convert from wide to long format  ###############

# using dplyr
MyWrangledData <- TempData %>% 
                  gather(Species, Count, -Cultivation, -Block, -Plot, -Quadrat)


MyWrangledData[, "Cultivation"] <- as.factor(MyWrangledData[, "Cultivation"])
MyWrangledData[, "Block"] <- as.factor(MyWrangledData[, "Block"])
MyWrangledData[, "Plot"] <- as.factor(MyWrangledData[, "Plot"])
MyWrangledData[, "Quadrat"] <- as.factor(MyWrangledData[, "Quadrat"])
MyWrangledData[, "Count"] <- as.integer(MyWrangledData[, "Count"])

glimpse(MyWrangledData) # like str() but tidier
head(MyWrangledData)
dim(MyWrangledData)

############# Exploring the data (extend the script below)  ###############

