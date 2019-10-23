# Two methods of creating a matrix, one without using
# preallocation (function, f) and one using preallocaiton
# (function, g)

a <- NA

f <- function(a) {
    for (i in 1:10000) {
        a <- c(a, i)
        print(a)
        print(object.size(a))
    }
}

a <- rep(NA, 10)

g <- function(a) {
    for (i in 1:10000) {
        a[i] <- i
        print(a)
        print(object.size(a))
    }
}

# to compare difference in computing times:
# increase iterations to 10000, comment out in function prints
# and uncomment the following print commands

# time taken for first function
# print("Time taken without preallocation:")
# print(system.time(f(a)))

# time taken for second function
# print("Time taken with preallocation:")
# print(system.time(g(a)))