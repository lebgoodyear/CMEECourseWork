#!/usr/local/bin/ipython

""" 
Various examples using regex to search for matches in strings,
text files and also a webpage.

"""

__author__ = 'Lucy Goodyear (lucy.goodyear19@imperial.ac.uk)'
__version__ = '0.0.1'

# imports
import re
import urllib3

########################### Regex in Python I #############################

# sample string
my_string = "a given string"

# find a space in the string
match = re.search(r'\s', my_string)

# pint output
print(match)
# note only tells you that a match was found

# see the match
match.group()

# try another pattern
match = re.search(r'\d', my_string)
print(match) # no match found because no numeric characters in our string

# to know whether a pattern was matched, we can use if
MyStr = 'an example'
# look for zero or more alphanumeric characters that are followed by a space
match = re.search(r'\w*\s', MyStr) 
if match:
    print('found a match:', match.group())
else:
    print('did not match')

# more regexs
match = re.search(r'2', "it takes 2 to tango")
match.group()

match = re.search(r'\d', "it takes 2 to tango")
match.group()

match = re.search(r'\d.*', "it takes 2 to tango")
match.group()

match = re.search(r'\s\w{1,3}\s', 'once upon a time')
match.group()

match = re.search(r'\s\w*$', 'once upon a time')
match.group()

# directly return the matched group by appending .group() to the result

re.search(r'\w*\s\d.*\d', 'take 2 grams of H2O').group()

re.search(r'^\w*.*\s', 'once upon a time').group()

# use ? to terminate at the first found instance of a pattern
re.search(r'^\w*.*?\s', 'once upon a time').group()

# try matching an HTML tag
re.search(r'<.+>', 'This is a <EM>first</EM> test').group()

# get just <EM>
re.search(r'<.+?>', 'This is a <EM>first</EM> test').group()

# different example
re.search(r'\d*\.?\d*', '1432.75+60.22i').group()
# note \. enabled us to find literal . rather than use its regex function

re.search(r'[AGTC]+', 'the sequence ATTCGT').group()

re.search(r'\s+[A-Z]\w+\s*\w+', "The bird-shit frog's name is Theloderma asper.").group()

# look for email addresses in a string
MyStr = 'Samraat Pawar, s.pawar@imperial.ac.uk, Systems biology and ecological theory'
match = re.search(r"[\w\s]+,\s[\w\.@]+,\s[\w\s]+", MyStr)
match.group()
# search for a different pattern in the string
MyStr = 'Samraat Pawar, s-pawar@imperial.ac.uk, Systems biology and ecological theory'
match = re.search(r"[\w\s]+,\s[\w\.@]+,\s[\w\s&]+", MyStr)
match.group() # this didn't find a match
# make email part of regex more robust
match = re.search(r"[\w\s]+,\s[\w\.-]+@[\w\.-]+,\s[\w\s&]+", MyStr)
match.group()

#################### Practicals : some RegExecrises ######################

# 1)

name = "Lu?cy G)oodYear+, l.g@ic.ac.uk"
match = re.search(r"[\w\W]+?,", name)
match.group()

# 2)

# a) match 'abc' at the beginning of the string, followed by any
# combination of a and b (matched one or more times), followed by a space,
# a tab and then a number

# b) match one or two numbers at the beginning of the string, followed by
# a forward slash and then one or two more numbers, another foward slash
# and finally 4 more numbers at the end of the string
# -> this is the format for a date

# c) match any number of spaces followed by any number of spaces, upper case or
# lower case characters, followed by any number of spaces

# 3) 

MyDates = "20150915"
match = re.search(r"^(19[0-9]{2}|20[01][0-9])[01]+?[0-9]+?[0-3]+?[0-9]+?$", MyDates)
match.group()

#################### Regex in Python II #######################

# you can group regex patterns into meaningful blocks using parentheses
# revisit email address example
MyStr = 'Samraat Pawar, s.pawar@imperial.ac.uk, Systems biology and ecological theory'
match = re.search(r"[\w\s]+,\s[\w\.-]+@[\w\.-]+,\s[\w\s&]+", MyStr)
match.group()
# without grouping the regex
match.group(0)
# create groups using ()
match = re.search(r"([\w\s]+),\s([\w\.-]+@[\w\.-]+),\s([\w\s&]+)", MyStr)
if match:
    print(match.group(0))
    print(match.group(1))
    print(match.group(2))
    print(match.group(3))

# finding all matches
# re.findall() returns all matches as a list strings with each string 
# representing one match
MyStr = "Samraat Pawar, s.pawar@imperial.ac.uk, Systems biology and ecological theory; Another academic, a-academic@imperial.ac.uk, Some other stuff thats equally boring; Yet another academic, y.a_academic@imperial.ac.uk, Some other stuff thats even more boring"
emails = re.findall(r'[\w\.-]+@[\w\.-]+', MyStr)
for email in emails:
    print(email)

# finding in files
# re.findall() can return a list of all matches in a file in single step
# so no need for a for loop
f = open('../../Week2/Data/TestOaksData.csv', 'r')
found_oaks = re.findall(r"Q.*", f.read()) # f.read() closes the file after reading
found_oaks

# groups within multiple matches
# re.findall() returns a list of tuples if the pattern includes 2 or more groups
# where each tuple represents one match of the pattern and the groups are inside the tuple
MyStr = "Samraat Pawar, s.pawar@imperial.ac.uk, Systems biology and ecological theory; Another academic, a.academic@imperial.ac.uk, Some other stuff thats equally boring; Yet another academic, y.a.academic@imperial.ac.uk, Some other stuff thats even more boring"
found_matches = re.findall(r"([\w\s]+),\s([\w\.-]+@[\w\.-]+)", MyStr)
found_matches

# extracting text from webpages

conn = urllib3.PoolManager() # open a connection
r = conn.request('GET', 'https://www.imperial.ac.uk/silwood-park/academic-staff/')
webpage_html = r.data # read in the webpage's contents

# webpage contents is returned as bytes (not strings)
type(webpage_html)

# decode webpage contents using default utf-8
My_Data = webpage_html.decode()
# print(My_Data)

# extract the names of the academics
pattern = r"Dr\s+\w+\s+\w+"
regex = re.compile(pattern) # example use of re.compile(); you can also ignore case with re.IGNORECASE
for match in regex.finditer(My_Data): # example use of re.finditer()
    print(match.group())

# improve the matching to:
# - include Prof names as well
# - eliminate repeated matches
# - group to separate title from first and second names
# - extract names that have unexpected characters
x = set()
pattern = r"(Dr\s|Prof\s)+?[\w\-\.\']+?\s+?[\w\-\.\']+?" # '|' means 'or'
regex = re.compile(pattern) 
for match in regex.finditer(My_Data):
    x.add(match.group()) # save as a set to delete duplicates
print(x)

# replacing text
New_Data = re.sub(r'\t'," ", My_Data) # replace all tabs with a space
# print(New_Data)
