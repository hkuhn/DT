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


batch_file_path = "../data/batch_files/"



file_list = [ f for f in os.listdir(batch_file_path) ]
my_list = []

for i in range(0, len(file_list)):
    filename = file_list[i]
    path = batch_file_path + filename
    array = pickle.load(open(path, 'rb'))
    my_list.append(array)


pickle.dump(my_list, open('../data/batch_files/full_batch', 'wb')) 


