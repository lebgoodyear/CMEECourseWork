#################
# FILE INPUT
#################
#Open a file for reading
f = open('../Sandbox/testweek2.txt', 'r') #r for read-only
#use "implicit" for loop:
#if the object is a file, python will cycle lines
for line in f:
    print(line)

#close the file
f.close()

#Same example, skip blank lines
f = open('../Sandbox/testweek2.txt', 'r')
for line in f:
    if len(line.strip()) > 0:
        print(line)

f.close()