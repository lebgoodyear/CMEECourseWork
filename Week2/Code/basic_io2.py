######################
#File Output
######################
#Save the elements of a list to a file
list_to_save = range(100)

f = open('../Sandbox/testout.txt','w')
for i in list_to_save:
    f.write(str(i) + '\n') ##Add a new line at the end
    print(i)

f.close()