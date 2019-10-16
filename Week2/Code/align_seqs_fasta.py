#!/usr/bin/env python3

"""
Calculates the best alignment of any two DNA sequences, with
defaults if no user input is given.

It contains one function (calculate_scores), which computes 
a score by returning the number of matches starting from an 
arbitrary startpoint (chosen by user), as well as along with 
a short script to identify whether or not user inputs have 
been given. The first alignment found with the best score overall 
is saved to a csv file.

"""

__author__ = 'Lucy Goodyear (lucy.goodyear19@imperial.ac.uk)'
__version__ = '0.0.1'

# imports
import csv
import sys

# open the file containing the sample data
# if user arguments are given, use those, otherwise use the default files

if len(sys.argv) == 3:
    seq1 = open(sys.argv[1], 'r')
    f = seq1.readlines()
    seq2 = open(sys.argv[2], 'r')
    g = seq2.readlines()
else:
    print("No arguments provided, defaults used")
    seq1 = open('../../Week1/Data/407228412.fasta', 'r')
    f = seq1.readlines()
    seq2 = open('../../Week1/Data/407228326.fasta', 'r')
    g = seq2.readlines()

# Assign the longer sequence s1, and the shorter to s2
# l1 is length of the longest, l2 that of the shortest

f = f[1:]
f = [i.strip() for i in f]
s1 = "".join(f)

l1 = len(s1)

g = g[1:]
g = [i.strip() for i in g]
s2 = "".join(g)
    
l2 = len(s2)

seq1.close()
seq2.close()

# define a function to score matches
def calculate_score(s1, s2, l1, l2, startpoint):
    """
    Computes a score by returning the number of matches starting
    from an arbitrary startpoint (chosen by user)

    Parameters:
        s1 (str): a string containing the longer of two genetic sequences
        s2 (str): a string containing the shorter of two genetic sequences
        l1 (int): the length of s1
        l2 (int): the length of s2
        startpoint: arbitrary starting point chosen by user

    Returns:
        score (int): number of matches in the sequence
        matched (str): string showing a match as * and no match as -

    """

    matched = "" # to hold string displaying alignements
    score = 0
    for i in range(l2):
        if (i + startpoint) < l1:
            if s1[i + startpoint] == s2[i]: # if the bases match
                matched = matched + "*"
                score = score + 1
            else:
                matched = matched + "-"

    # some formatted output to line up the sequences for easy viewing
    print("." * startpoint + matched)           
    print("." * startpoint + str(s2))
    print(s1)
    print(score) 
    print(" ")

    return score
    return matched

# Test the function with some example starting points:
# calculate_score(s1, s2, l1, l2, 0)
# calculate_score(s1, s2, l1, l2, 1)
# calculate_score(s1, s2, l1, l2, 5)

# now try to find the best match (highest score) for the two sequences
my_best_align = None
my_best_score = -1

for i in range(l1): # Note that you just take the last alignment with the highest score
    z = calculate_score(s1, s2, l1, l2, i)
    if z > my_best_score:
        my_best_align = "." * i + str(s2)
        my_best_score = z # z is not replaced by equal score so only first is saved
print(my_best_align)
print(s1)
print("Best score:", my_best_score)

# Save output to a text file
sys.stdout = open("../Results/Best_Alignment.csv", 'w')
print("Best Alignment is:", "\n", str(my_best_align), "\n", str(s1), "\n", "Best score:", str(my_best_score))
sys.stdout.close()