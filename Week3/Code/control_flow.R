####### Practice using different control flow tools ########

# illustrates different control flow tools.

# Author: Lucy Goodyear (lucy.goodyear19@imperial.ac.uk)
# Version: 0.0.1

# clear workspace
rm(list=ls())

# if statement
a <- TRUE
if (a == TRUE){
    print ("a is TRUE")
    } else {
    print ("a is FALSE")
}

# if statement on a single line
z <- runif(1) # uniformly distributed random number
if (z <= 0.5) {print ("Less than a half")}

# for loop using a sequence
for (i in 1:10){
    j <- i * i
    print(paste(i, " squared is", j ))
}

# for loop over vector of strings
for(species in c('Heliodoxa rubinoides',
                 'Boissonneausa jardini',
                 'Sula nebouxii')){
    print(paste('The species is', species))
}

# for loop using a vector
v1 <- c("a","bc","def")
for (i in v1){
    print(i)
}

# while loop
i <- 0
while (i < 10){
    i <- i + 1
    print(i^2)
}
