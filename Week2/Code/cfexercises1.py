## Using conditionals

# Function to find the square root
def foo_1(x):
    return x ** 0.5

# Function to return largest of 2 numbers
def foo_2(x, y):
    if x > y:
        return x
    return y

# Function to return 3 numbers in a different order
def foo_3(x, y, z):
        if x > y:
            tmp = y
            y = x
            x = tmp
        if y > z:
            tmp = z
            z = y
            y = tmp
        return [x, y, z]

# One method of calculating the factorial of x, multiplying from 1 up to x
def foo_4(x):
    result = 1
    for i in range(1, x + 1):
        result = result * i
    return result

# A recursive method of calculating the factorial of x
def foo_5(x):
    if x == 1:
        return 1
    return x * foo_5(x - 1)

# Another method of calculating the factorial of x, multiplying from x down to 1
def foo_6(x):
    facto = 1
    while x >= 1:
        facto = facto * x
        x = x - 1
    return facto
