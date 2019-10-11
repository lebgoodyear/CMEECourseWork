import csv
# Read a file containing
# 'Species', 'Infraorder', 'Family', 'Distribution', 'Body mass male (kg)'
f = open('testcsv.csv', 'r')

csvread = csv.reader(f)
temp = []
for row in csvread:
    temp.append(tuple(row))
    print(row)
    print("The species is", row[0])

f.close()

# Write a file containing only species name and body mass
f = open('testcsv.csv', 'r')
g = open('bodymass.csv','w')

csvread = csv.reader(f)
csvwrite = csv.writer(g)
for row in csvread:
    print(row)
    csvwrite.writerow([row[0], row[4]])

f.close()
g.close()
