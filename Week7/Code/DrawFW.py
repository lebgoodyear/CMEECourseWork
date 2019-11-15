#!/usr/bin/env python3

""" 
Represents a sample food web network as an adjacency list and plots 
the network using networkx, where the size of the node represents the 
body mass of the species.

Contains one function that generates a random adjacency list, containing 
the Ids of species that interact (based on comparison to the connectance
probability). Body sizes are generated for each species, saved in an array
and then visualised using matplotlib. Networkx is then used to plot the food 
web network.

"""

__author__ = 'Lucy Goodyear (lucy.goodyear19@imperial.ac.uk)'
__version__ = '0.0.1'

# imports
import networkx as nx
import scipy as sc
import matplotlib.pyplot as p

# generate the adjacency list of who eats whom (consumer name/id and 
# resource name/id) in the network

def GenRdmAdjList(N = 2, C = 0.5):
    """ Generates a a random adjacency list, containing the Ids of species that interact 
    (based on comparison to the connectance probability, C, which is the probability of 
    having a link between any pair of species in the web)

    Parameters:
        N(int) : number of species in the network
        C(float): connectance probability

    Returns:
        ALst(list) : list containing tuples of linked species' Ids
    """
    Ids = range(N)
    ALst = []
    for i in Ids:
        if sc.random.uniform(0, 1, 1) < C: # [0] & [1] is the range, [2] is the number of samples to be taken
            Lnk = sc.random.choice(Ids, 2).tolist() # picks 2 Ids at random and coerces them into a list
            if Lnk[0] != Lnk[1]: # avoid self, e.g. cannibalistic, loops (should be there in real life but difficult to plot)
                ALst.append(Lnk)
    return ALst

# assign values
MaxN = 30
C = 0.75

# generate an adjancency list representing a random food web
AdjL = sc.array(GenRdmAdjList(MaxN, C))
AdjL

# generate species(node) data
Sps = sc.unique(AdjL) # get species Ids
# generate body sizes for the species
# use log10 scale to enable proportionate sampling because species body sizes
# tend to be log-normally distributed
SizRan = ([-10, 10])
Sizs = sc.random.uniform(SizRan[0], SizRan[1], MaxN)
Sizs

# visualise the size distribution we have generated
p.hist(Sizs) # log10 scale
p.hist(10 ** Sizs) # raw scale
# close all open plot objects
p.close('all')

# use a circular configuration to plot the network
# calculate the coordinates using networkx
pos = nx.circular_layout(Sps)
# generate a networkx graph object
G = nx.Graph()
# add the nodes and links(edges)
G.add_nodes_from(Sps)
G.add_edges_from(tuple(AdjL))
# generate node sizes that are proportional to (log) body sizes
NodSizs = 1000 * (Sizs - min(Sizs)) / (max(Sizs) - min(Sizs))
# plot the graph
nx.draw_networkx(G, pos, node_size = NodSizs, node_color = "r")
# save the graph as a pdf
p.savefig('../Results/DrawFW.pdf') 