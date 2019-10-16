## run a simulation that involves sampling from a population

# a function to take a sample of size n from a population "popn" and return its mean
myexperiment <- function(popn, n){
    pop_sample <- sample(popn, n, replace = FALSE)
    return(mean(pop_sample))
}

# run 100 iterations using vectorisation:
result <- lapply(1:100, function(i) doit(x))

# or using a for loop:
result <- vector("list", 100) # preallocate/initalise
for(i in 1:100){
    result[[i]] <- doit(x)
    }