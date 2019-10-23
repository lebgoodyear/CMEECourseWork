# Practice script looking at using apply on some of R's
# inbuilt functions

# build a random matrix
M <- matrix(rnorm(100), 10, 10)

# take the mean of each row
RowMeans <- apply(M, 1, mean)
print(RowMeans)

# now take the variance
RowVars <- apply(M, 1 ,var)
print(RowVars)

# take means by column
ColMeans <- apply(M, 2, mean)
print(ColMeans)