# Two methods of calculating the sum of a matrix.
# The first uses a for loop and the second the inbuilt 'sum'
# function. The prints show which method is faster.

# create 1000 by 1000 matrix with random uniform numbers
M = [random.uniform(k = 1000000), * 1000] * 1000

# calculate sum of matrix using for loop
def SumAllElements(M):
    Dimensions = dim(M)
    Tot = 0
    for i in range(1, Dimensions[1]):
        for j in range(1, Dimensions[2]):
            Tot <- Tot + M[i, j]
    return (Tot)

print("Using loops, the time taken is:")
print(system.time(SumAllElements(M)))

print("Using the in-built vectorized function, the time taken is:")
print(system.time(sum(M)))