################## Using qplot #########################

library(ggplot2)

MyDF <- read.csv("../Data/EcolArchives-E089-51-D1.csv")
dim(MyDF) # check the size of the data frame you loaded

# quick plot
qplot(Predator.mass, Prey.mass, data = MyDF)

# quick plot using logs
qplot(log(Predator.mass), log(Prey.mass), data = MyDF)

# colour points by type of feeding interaction
qplot(log(Predator.mass), log(Prey.mass), data = MyDF, colour = Type.of.feeding.interaction)

# change aspect ratio
qplot(log(Predator.mass), log(Prey.mass), data = MyDF, colour = Type.of.feeding.interaction, asp = 1)

# type of feeding interation by shape
qplot(log(Predator.mass), log(Prey.mass), data = MyDF, shape = Type.of.feeding.interaction, asp = 1)

# manually setting colour, size and shape using "I"
# "I" means as it is in base R rather than the ggplot preset
qplot(log(Predator.mass), log(Prey.mass), data = MyDF, colour = "red") # ggplot shade of red
qplot(log(Predator.mass), log(Prey.mass), data = MyDF, colour = I("red")) # manually set to real shade of red
qplot(log(Predator.mass), log(Prey.mass), data = MyDF, size = 3) # with ggplot size mapping
qplot(log(Predator.mass), log(Prey.mass), data = MyDF, size = I(3)) # without ggplot size mapping
qplot(log(Predator.mass), log(Prey.mass), data = MyDF, shape = I(3)) # shape with "I" would produce an error

# make points semi-transparent using "alpha" so overlaps can be seen
qplot(log(Predator.mass), log(Prey.mass), data = MyDF, colour = Type.of.feeding.interaction, alpha = I(.5))

# adding a smoother
qplot(log(Predator.mass), log(Prey.mass), data = MyDF, geom = c("point","smooth"))

# adding a linear regression line (lm stands for linear models)
qplot(log(Predator.mass), log(Prey.mass), data = MyDF, geom = c("point","smooth")) + geom_smooth(method = "lm")

# adding a smoother for each type of interaction
qplot(log(Predator.mass), log(Prey.mass), data = MyDF, geom = c("point","smooth"), colour = Type.of.feeding.interaction) + geom_smooth(method = "lm")

# extending smoothers to full range
qplot(log(Predator.mass), log(Prey.mass), data = MyDF, geom = c("point","smooth"), colour = Type.of.feeding.interaction) + geom_smooth(method = "lm", fullrange = TRUE)

# change of predator to prey ratio according to type of interaction
qplot(Type.of.feeding.interaction, log(Prey.mass/Predator.mass), data = MyDF)

# jitter points to get an idea of spread
qplot(Type.of.feeding.interaction, log(Prey.mass/Predator.mass), data = MyDF, geom = "jitter")

# plot a boxplot
qplot(Type.of.feeding.interaction, log(Prey.mass/Predator.mass), data = MyDF, geom = "boxplot")

# plot a histogram
qplot(log(Prey.mass/Predator.mass), data = MyDF, geom = "histogram")

# add colour to histogram by factor
qplot(log(Prey.mass/Predator.mass), data = MyDF, geom = "histogram", fill = Type.of.feeding.interaction)

# change bin width
qplot(log(Prey.mass/Predator.mass), data = MyDF, geom = "histogram", fill = Type.of.feeding.interaction, binwidth = 1)

# plot a smoothed desnity of the data instead
qplot(log(Prey.mass/Predator.mass), data = MyDF, geom = "density", fill = Type.of.feeding.interaction)

# make densities transparent so you can see overlaps
qplot(log(Prey.mass/Predator.mass), data = MyDF, geom = "density", fill = Type.of.feeding.interaction, alpha = I(0.5))

# colour lines only rather than fill plot with colour
qplot(log(Prey.mass/Predator.mass), data = MyDF, geom = "density", colour = Type.of.feeding.interaction, )

# multi-facted plots by row
qplot(log(Prey.mass/Predator.mass), facets = Type.of.feeding.interaction ~., data = MyDF, geom = "density")

# multi-facted plots by column
qplot(log(Prey.mass/Predator.mass), facets = .~ Type.of.feeding.interaction, data = MyDF, geom = "density")

# faceting by combination of categories
# Note, Jupyter code would not work so used different method of creating new column containing both data types
# change order of combination by changing order in column creation
# Notes say to use facet_grid or facet_wrap for more fine-tuned faceting
MyDF$FeedLoc <- paste(MyDF$Type.of.feeding.interaction, MyDF$Location)
qplot(log(Prey.mass/Predator.mass), facets = .~ FeedLoc, data = MyDF, geom = "density")

# a better way to plot data in the log scale is to set the axes to be logarithmic
# add labels and titles
qplot(Predator.mass, Prey.mass, data = MyDF, log = "xy",
      main = "Relation between prey and predator mass",
      xlab = "log(mass of prey) (g)",
      ylab = "log(mass of predator) (g)")

# make it suitable for black and white printing
qplot(Predator.mass, Prey.mass, data = MyDF, log = "xy",
      main = "Relation between prey and predator mass",
      xlab = "log(mass of prey) (g)",
      ylab = "log(mass of predator) (g)") 
      + theme_bw()

# save pdf file of the figure
pdf("../Results/MyFirst-ggplot2-Figure.pdf")
print(qplot(Prey.mass, Predator.mass, data = MyDF, log = "xy",
        main = "Relation between predator and prey mass",
        xlab = "log(Prey mass) (g)",
        ylab = "log(Predator mass) (g)"))
dev.off()

# using geom to make a bar plot for predator lifestage
qplot(Predator.lifestage, data = MyDF, geom = "bar")

# using geom to make a boxplot
qplot(Predator.lifestage, log(Prey.mass), data = MyDF, geom = "boxplot")

# using geom to make a violin plot
qplot(Predator.lifestage, log(Prey.mass), data = MyDF, geom = "violin")

# using geom to make a density plot
qplot(log(Predator.mass), data = MyDF, geom = "density")

# using geom to make a  histogram
qplot(log(Predator.mass), data = MyDF, geom = "histogram")

# using geom to make a  scatterplot
qplot(log(Predator.mass), log(Prey.mass), data = MyDF, geom = "point")

# using geom to make a smooth plot
qplot(log(Predator.mass), log(Prey.mass), data = MyDF, geom = "smooth")

# using geom to make a linear regression line
qplot(log(Predator.mass), log(Prey.mass), data = MyDF, geom = "smooth", method = "lm")


############################ Using ggplot #########################################

# specify data and aesthetics to creat empty plot
p <- ggplot(MyDF, aes(
  x = log(Predator.mass),
  y = log(Prey.mass),
  colour = Type.of.feeding.interaction))

# plot data as scatterplot
p + geom_point() 

# using + to concatenate commands
q <- p + 
  geom_point(size=I(2), shape=I(10)) +
  theme_bw() + # make the background white
  theme(aspect.ratio=1) # make the plot square

# we can remove the legend
q + theme(legend.position = "none") + theme(aspect.ratio = 1)
  
  
  
  
 





