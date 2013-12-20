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


SAMPLES = 300



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
    group_zero = [] # mean at index 0
    group_one = [] # mean at index 1
    group_two = [] # mean at index 2

    # sort datapoints
    for y in range(0, len(datapoints)):
        zero_dist = numpy.linalg.norm(means[0] - datapoints[y])
        one_dist = numpy.linalg.norm(means[1] - datapoints[y])
        two_dist = numpy.linalg.norm(means[2] - datapoints[y])
        dist_array = numpy.asarray( [ zero_dist, one_dist, two_dist ] )
        min_index = numpy.argmin(dist_array)
        if min_index == 0:
            group_zero.append(datapoints[y])
        elif min_index == 1:
            group_one.append(datapoints[y])
        else:
            group_two.append(datapoints[y])


    # recalculate means
    means[0] = numpy.mean(group_zero)
    means[1] = numpy.mean(group_one)
    means[2] = numpy.mean(group_two)


# save means
print "Means found. Saving means to file..."
numpy.save('means', means)








