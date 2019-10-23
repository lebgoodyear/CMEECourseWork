# Practice script looking at using apply on my
# own function

# create a function
SomeOperation <- function(v) {
    if (sum(v) > 0){
        return(v * 100)
    }
    return(v)
}

# create a test argument and use apply to run your function on
# all elements at once
M <- matrix(rnorm(100), 10, 10)
print (apply(M, 1, SomeOperation))