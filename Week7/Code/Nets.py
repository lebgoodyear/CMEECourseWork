#!/usr/bin/env python3

""" 
Visualizes the QMEE CDT collaboration network using networkx, coloring the the nodes by the type of node 
(organization type: "University","Hosting Partner", "Non-hosting Partner") and weighting the edges by
number of PhD students. This is a python version of the R-script of the same name.

"""

__author__ = 'Lucy Goodyear (lucy.goodyear19@imperial.ac.uk)'
__version__ = '0.0.1'

# imports
import networkx as nx
import pandas
import scipy as sc
import matplotlib.pyplot as plt
from matplotlib.lines import Line2D

# load csv data using pandas
links = pandas.read_csv("../Data/QMEE_Net_Mat_edges.csv")
nodes = pandas.read_csv("../Data/QMEE_Net_Mat_nodes.csv")

# set panda dataframe index to be the same as column headers
links.index = links.columns

# contruct list of connected institutions by appending the links not equal to zero
interactions = []
for i in range(len(links)):
    for j in range(len(links)):
        if links.iloc[i,j] > 0 :
            interactions.append((links.index[i], links.columns[j], links.iloc[i,j]))

# construct list of unique institutions
nodes_uniq = sc.unique(nodes['id'])
# create networkx graph object with directional edges
G = nx.DiGraph()

# add institutions as nodes
G.add_nodes_from(nodes_uniq)
# create list of colours for the type of node to be used in plot
nodes = nodes.set_index('id') 
nodes = nodes.reindex(G.nodes()) # make sure nodes are in the same order as in the G.nodes object
nodes['Type'] = pandas.Categorical(nodes['Type']) # set nodes as categorical (a bit similar to factor in R)
# run for loop over nodes to allocate colour by type
colrs = []
nodetypes = nodes['Type'].to_list()
for i in range(0,len(nodetypes)):
    if nodetypes[i] == "Hosting Partner":
        colrs.append("green")
    elif nodetypes[i] == "University":
        colrs.append("blue")
    else:
        colrs.append("red")

# add links as weighted edges, setting edge width based on PhD students
G.add_weighted_edges_from(tuple(interactions))
weights = [G[u][v]['weight'] for u,v in G.edges()]
weights[:] = [x / 30 for x in weights] # set weights at a reasonable scale for better visuals

# generate node sizes that are proportional to PIs
# the following is commented out in the R version so is commented out here
# Sizs = nodes['Pis'].to_list()
# NodSizs = [1500 * (i - min(Sizs)) / (max(Sizs) - min(Sizs)) for i in Sizs]

# use one node size for all nodes
NodSizs = 2000

# define layout
pos = nx.spring_layout(G)

# plot the network
nx.draw_networkx(G, pos, node_size = NodSizs, node_color = colrs, edge_color = "grey", width = weights)
# add legend
green_label = Line2D([0], [0], marker='o', color='w', label='Hosting Partner',
                        markerfacecolor='g', markersize=15)
red_label = Line2D([0], [0], marker='o', color='w', label='Non-Hosting Partner',
                        markerfacecolor='r', markersize=15)
blue_label = Line2D([0], [0], marker='o', color='w', label='University',
                        markerfacecolor='b', markersize=15)
plt.legend(handles=[green_label, red_label, blue_label])

# save figure as .svg
plt.savefig('../Results/QMEENetpy.svg') 
