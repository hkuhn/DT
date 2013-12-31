# Title:
#    combine_batch_data.py
#
# Desc:
#    This script combines all batch files in batch_files directory
#    In order to have one file as input to the DBN
#
# Example:
#    python combine_batch_data.py
#
#



import pickle
import numpy
import os
import sys
import random
import scipy.io

batch_file_path = "../data/batch_files/"



file_list = [ f for f in os.listdir(batch_file_path) ]
my_list = []

for i in range(0, len(file_list)):
    filename = file_list[i]
    if filename == 'full_batch.mat':
        continue
    path = batch_file_path + filename
    array = pickle.load(open(path, 'rb'))
    print filename
    my_list.append(array)


my_list = [ item for sublist in my_list for item in sublist ]
output_name = batch_file_path + 'full_batch' + '.mat'


output_mat = numpy.asarray(my_list)
print output_mat
out = {}
out['full_batch'] = output_mat
scipy.io.savemat(output_name, out)

