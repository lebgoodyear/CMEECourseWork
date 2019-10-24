# Two methods of creating a matrix, one without using
# preallocation (function, f) and one using preallocaiton
# (function, g).  
# The times taken for each function to run are printed to allow comparison.

a <- NA

f <- function(a) {
    for (i in 1:10000) {
        a <- c(a, i)
        
        # in-function print commands have been commented out 
        # to increase speed
        
        #print(a)
        #print(object.size(a))
    }
}

a <- rep(NA, 10)

g <- function(a) {
    for (i in 1:10000) {
        a[i] <- i
        
        # in-function print commands have been commented out 
        # to increase speed
        
        #print(a)
        #print(object.size(a))
    }
}

# compare difference in computing times:

# time taken for first function
print("Time taken without preallocation:")
print(system.time(f(a)))

# time taken for second function
print("Time taken with preallocation:")
print(system.time(g(a)))