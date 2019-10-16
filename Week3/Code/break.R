# A .R script that uses break to get out of a simple loop.

i <- 0 # initialise i
    while (i < Inf) {
        if (i == 10) {
            break
        } # break out of while loop
        else {
            cat("i equals ", i, "\n")
            i <- i + 1 # update i
        }
}