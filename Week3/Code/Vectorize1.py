# Two methods of calculating the sum of a matrix.
# The first uses a for loop and the second the inbuilt 'sum'
# function. The prints show which method is faster.

import scipy as sc
import scipy.stats as scs
import time

# create 1000 by 1000 matrix with random uniform numbers
M = sc.random.normal(size = (1000, 1000))

# calculate sum of matrix using for loop
def SumAllElements(M):
    Tot = 0
    for i in range(0, len(M[0])):
        for j in range(0, len(M[1])):
            Tot = Tot + M[i, j]
    return Tot

start = time.time()
SumAllElements(M)
end = time.time()
print("Using loops, the time taken is:")
print(end - start)

start = time.time()
sc.sum(M)
end = time.time()
print("Using in-built scipy sum function, the time taken is:")
print(end - start)