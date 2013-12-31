#
# Title:
#    test_data.py
# Desc:
#    With input test input, discovers which group the input belongs
#
# Example:
#    python test_data.py <input-file>


import sys
import numpy

# test input arguments
try:
    if len(sys.argv) != 2:
        print "Not enough input arguments!!"
        exit()
except:
    print "Trouble reading in input arguments!!"
    exit()


# retrieve input
FILEPATH = sys.argv[1]
input_data = numpy.load(FILEPATH)


# retrieve external files
A_MATRICES_PATH = "../data/A_matrices/"
# Retrieve DBN Weight Matrices
print "Loading A1 Matrix..."
A1 = numpy.load(A_MATRICES_PATH + "A1_matrix.npy")
print A1.shape
print "Loading A2 Matrix..."
A2 = numpy.load(A_MATRICES_PATH + "A2_matrix.npy")
print A2.shape
print "Loading A3 Matrix..."
A3 = numpy.load(A_MATRICES_PATH + "A3_matrix.npy")
print A3.shape

# retrieve means
means = numpy.load("../Clustering/means.npy")






# retrieve grouping for input
print "Length of input data: " + str(len(input_data))
print "Retrieving grouping..."
output = []
count = 0
for cur_example in input_data:
    l1_output = numpy.dot(cur_example, A1)
    l2_output = numpy.dot(l1_output, A2)
    l3_output = numpy.dot(l2_output, A3)
    output.append(l3_output)


groupings = []
for i in range(0, len(output)):
    example = output[i]
    zero_dist = numpy.linalg.norm(means[0] - example)
    one_dist = numpy.linalg.norm(means[1] - example)
    two_dist = numpy.linalg.norm(means[2] - example)
    dist_array = numpy.asarray( [ zero_dist, one_dist, two_dist ] )
    #dist_array = numpy.asarray( [ zero_dist, one_dist ] )
    min_index = numpy.argmin(dist_array)
    groupings.append(min_index)    
    print "at instance: " + str(i)
    print min_index



print "Saving groupings to file..."
groupings = numpy.asarray(groupings)
numpy.save("groupings", groupings)


