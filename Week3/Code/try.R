# Practise catching errors and debugging

# create a funtion with a custom made error
doit <- function(x){
    x_temp <- sample(x, replace = TRUE)
    if(length(unique(x_temp)) > 30) { # only take mean if sample was sufficient
        print(paste("mean of this sample was: ", as.character(mean(x_temp))))
    }
    else {
        stop("Couldn't calculate mean: too few unique values")
    }
}

popn <- rnorm(50) # generate your population

# this will stop the script with an error
#lapply(1:15, function(i) doit(popn))

result <- lapply(1:15, function(i) try(doit(popn), FALSE))

# this is the manual version of the above
#result <- vector("list", 15) # preallocate/initialise
#for(i in 1:15) {
#   result[[i]] <- try(doit(popn), FALSE)
#}
