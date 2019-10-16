# Using next to skip to the next iteration of a loop.
# The loop checks which numbers between 1 and 10 are odd by 
# using the modulo operation and then all odd numbers are printed. 


for (i in 1:10) {
    if ((i %% 2) == 0)
        next # pass to next iteration of loop
    print(i)
}