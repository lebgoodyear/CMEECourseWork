library(lattice)
library(ggthemes)

MyDF <- read.csv("../Data/EcolArchives-E089-51-D1.csv")
dim(MyDF) # check the size of the data frame you loaded

plot(MyDF$Predator.mass,MyDF$Prey.mass)
plot(log(MyDF$Predator.mass),log(MyDF$Prey.mass))
plot(log(MyDF$Predator.mass),log(MyDF$Prey.mass),pch=20) # change marker
plot(log(MyDF$Predator.mass),log(MyDF$Prey.mass),pch=20,xlab="Predator Mass (kg)", ylab = "Prey Mass (kg)") # add labels

hist(MyDF$Predator.mass)
hist(log(MyDF$Predator.mass), xlab = "Predator Mass (kg)", ylab = "Count") # include labels
hist(log(MyDF$Predator.mass), xlab = "Predator Mass (kg)", ylab = "Count", col = "lightblue", border = "pink") # change bar and border colours

# same plot but for prey
hist(log(MyDF$Prey.mass), xlab = "Prey Mass (kg)", ylab = "Count", col = "lightblue", border = "pink")

hist(log(MyDF$Predator.mass), breaks="sturges", font.lab = 2, cex.lab = 1.2, xlab = "Predator Mass (kg)", ylab = "Count", col = "lightblue", border = "pink") # change bar and border colours
hist(log(MyDF$Prey.mass), breaks="sturges", font.lab = 2, cex.lab = 1.2, xlab = "Prey Mass (kg)", ylab = "Count", col = "lightblue", border = "pink")

# put histograms different subplots
par(mfcol = c(2,1)) # initialise multi-paneled plot
par(mfg = c(1,1)) # specify which subplot to use first
hist(log(MyDF$Predator.mass),
     xlab = "Predator Mass (kg)",
     ylab = "Count",
     col = "lightblue",
     border = "pink",
     main = 'Predator') # adds title
par(mfg = c(2,1)) # second subplot
hist(log(MyDF$Prey.mass),
     xlab = "Prey Mass (kg)",
     ylab = "Count",
     col = "lightgreen",
     border = "pink",
     main = 'prey')

# put histograms on same plot
hist(log(MyDF$Predator.mass), # predator histogram
     xlab = "Body Mass (kg)",
     ylab = "Count",
     breaks = "scott",
     col = rgb(1,0,0,0.5), # note 'rgb', 4th value is transparent
     main = "Predator-prey size overlap")
hist(log(MyDF$Prey.mass),
     breaks = "scott",
     col = rgb(0,0,1,0.5),
     add = T) # plot prey
legend('topleft', c('Predators', 'Prey'), # add legend
       fill = c(rgb(1,0,0,0.5), rgb(0,0,1,0.5))) # define legend colours

# plotting a boxplot
boxplot(log(MyDF$Predator.mass),
  xlab = "Location", 
  ylab = "Predator Mass", 
  main = "Predator Mass")

# plotting a boxplot by location
boxplot(log(MyDF$Predator.mass) ~ MyDF$Location, # categorise the analysis by the "Location" factor
        xlab = "Location",
        ylab = "Predator Mass",
        main = "Predator mass by location")

# boxplot by type of feeding interation
boxplot(log(MyDF$Predator.mass) ~ MyDF$Type.of.feeding.interaction,
        xlab = "Feeding interation type",
        ylab = "Predator mass",
        main = "Predator mass by feeding interation type")

# combining plot types
par(fig = c(0,0.8,0,0.8)) # specify figure size as proportion
  plot(log(MyDF$Predator.mass), log(MyDF$Prey.mass),
       xlab = "Predator mass (kg)",
       ylab = "Prey mass (kg)")
par(fig = c(0,0.8,0.4,1), new = TRUE)
  boxplot(log(MyDF$Predator.mass), 
          horizontal = TRUE,
          axes = FALSE)
par(fig = c(0.55,1,0,0.8), new = TRUE)
  boxplot(log(MyDF$Prey.mass), axes = FALSE)
mtext("Fancy Predator-prey scatter plot", side = 3, outer = TRUE, line = -3)

# making a lattice plot
densityplot(~log(Predator.mass) | Type.of.feeding.interaction, data = MyDF)

# saving graphics
pdf("../Results/Pred_Prey_overlay.pdf", # open blank pdf page using a relative path
     11.7, 8.3) # these numbers are page dimensions in inches
hist(log(MyDF$Predator.mass), # plot predator histogram (note 'rgb')
     xlab = "Body Mass (kg)",
     ylab = "Count",
     col = rgb(1,0,0,0.5),
     main = "Predator-prey size overlap")
hist(log(MyDF$Prey.mass), # plot prey weights
     col = rgb(0,0,1,0.5),
     add = T) # add to same plot = TRUE
legend('topleft', c('Predators', 'Prey'), # add legend
       fill = c(rgb(1,0,0,0.5),rgb(0,0,1,0.5)))
graphics.off()

# using ggthemes
p <- ggplot(MyDF, aes(x = log(Predator.mass),
                      y = log(Prey.mass),
                      colour = Type.of.feeding.interaction)) +
            geom_point(size = I(2),
                      shape = I(10)) +
            theme_bw()

p + geom_rangeframe() + # now fine tune the geom to Tufte's range frame
    theme_tufte() # and theme to Tufte's minimal ink theme
     



