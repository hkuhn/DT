#
# Title:
#    generate_means.py
#
# Desc:
#    This script will read in datapoints and run clustering to
#    Generate the number of means specified in the input
#
# Example:
#    python generate_means.py <num_means>


import sys
import os
import numpy
import random


SAMPLES = 500



# input error handling
if len(sys.argv) != 2:
    print "ERROR! DID NOT SPECIFY NUMBER OF MEANS"


# retrieve number of means
num_means = int(sys.argv[1])
print "Number of means specified: " + str(num_means)


# read in datapoints
print "Reading datapoints..."
datapoints = numpy.load("datapoints.npy")

# run clustering on datapoints 
#    1. Randomly initialize means with a datapoint
#    2. Put datapoints in groups based on means
#    3. Recalculate means
#    4. Repeat

# INITIALIZATION
print "Initializing means..."
means = []
for x in range(num_means):
    means.append(datapoints[random.randint(0,len(datapoints)-1)])

means = numpy.asarray(means)


# LOOP
print "Discovering cluster means..."
for x in range(0,SAMPLES):
    
    # print iteration
    if x % 100 == 0:
        print "Iteration: " + str(x)
        print means

    #empty groups
    groups = []
    for x in range(num_means):
        groups.append([])


    # sort datapoints
    for y in range(0, len(datapoints)):
        dist_array = []
        for g in range(num_means):
            dist = numpy.linalg.norm(means[g] - datapoints[y])
            dist_array.append(dist)
        dist_array = numpy.asarray( dist_array )
        min_index = numpy.argmin(dist_array)
        
        groups[min_index].append(datapoints[y])

    # recalculate means
    for i in range(num_means):
        means[i] = numpy.mean(numpy.asarray(groups[i]), axis=0)


# save means
print "Means found. Saving means to file..."
numpy.save('means', means)








