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

hist(log(MyDF$Predator.mass), breaks="sturges", xlab = "Predator Mass (kg)", ylab = "Count", col = "lightblue", border = "pink") # change bar and border colours
hist(log(MyDF$Prey.mass), breaks="sturges", xlab = "Prey Mass (kg)", ylab = "Count", col = "lightblue", border = "pink")
