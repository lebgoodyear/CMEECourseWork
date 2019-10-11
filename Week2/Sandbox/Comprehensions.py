## List Comprehensions

# List comprehension for printing list of 0-9
x = [i for i in range(10)]
print(x)

# Equivalent loop for printing list of 0-9
x = []
for i in range(10):
    x.append(i)
print(x)

# List comprehension for turning uppercase to lowercase
x = [i.lower() for i in ["LIST", "COMPREHENSIONS", "ARE", "COOL"]]
print(x)

# Equivalent loop for turning uppercase to lowercase
x = ["LIST", "COMPREHENSIONS", "ARE", "COOL"]
for i in range(len(x)): #explicit loop
    x[i] = x[i].lower()
print(x)

# Alternative loop for turning uppercase to lowercase
x = ["LIST", "COMPREHENSIONS", "ARE", "COOL"]
x_new = [ ]
for i in x: #implicit loop
    x_new.append(i.lower())
print(x_new)

# Loop to flatten a matrix
matrix = [[1, 2, 3], [4, 5, 6], [7, 8, 9]]
flattened_matrix = []
for row in matrix:
    for n in row:
        flattened_matrix.append(n)
print(flattened_matrix)

# List comprehension to flatten a matrix
matrix = [[1, 2, 3], [4, 5, 6], [7, 8, 9]]
flattened_matrix = [n for row in matrix for n in row]
print(flattened_matrix)

## Set and Dictionary Comprehensions

#Creating a set of all the first letters in a sequence of words
words = (["These", "are", "some", "words"])
first_letters = set()
for w in words:
    first_letters.add(w[0])
print(first_letters)

#A list comprehension for creating the same set as above
words = (["These", "are", "some", "words"])
first_letters = {w[0] for w in words}
print(first_letters)
