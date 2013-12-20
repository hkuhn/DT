#
# Title:
#    generate_data_points.py
#
# Desc:
#    Generates data points from data and deep belief network
#    Data points are saved to a numpy file in this directory
#
# Example:
#    python generate_data_points.py



import numpy
import pickle


A_MATRICES_PATH = "../data/A_matrices/"
BATCH_FILES_PATH = "../data/batch_files/"





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

# Retrieve dataset
print "Loading dataset..."
dataset = pickle.load(open(BATCH_FILES_PATH + "full_batch", 'rb'))
dataset = numpy.asarray(dataset)
print dataset.shape


# iterate through dataset and generate datapoints
print "Generating datapoints..."
datapoints = []

for i in range(0,len(dataset)):
    cur_example = dataset[0]
    l1_output = numpy.dot(cur_example, A1)
    l2_output = numpy.dot(l1_output, A2)
    l3_output = numpy.dot(l2_output, A3)
    datapoints.append(l3_output)

datapoints = numpy.asarray(datapoints)
print datapoints.shape

print "Datapoints generated. Saving to file..."
numpy.save('datapoints', datapoints)





