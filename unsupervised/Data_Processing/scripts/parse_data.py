#!/usr/bin/python
# Title:
#    parse_data.py
#
# Desc:
#    Parses Google finance data into pickled python format.
#    This pickled file must be ready for the DBN
#
# Example:
#    python parse_data.py <filename> <minute-interval-timeframe>
#    python parse_data.py WMT.dat 15
#

import sys
import os
import pickle
import numpy
import csv
import math



# test length of input arguments
try:
    if len(sys.argv) != 3:
        print "Not enough input arguments!!"
        exit()
except:
    print "Trouble reading in input arguments!!"
    exit()


# retrieve variables
filename = sys.argv[1]
interval = int(sys.argv[2])
file_path = '../data/training_data/' + filename
SandP_path = '../data/training_data/INX.dat'


# create numpy feature vectors
#    examples: list of feature vectors

examples = []
open_list = []
high_list = []
low_list = []
close_list = []
volume_list = []

sp_open_list = []
sp_high_list = []
sp_low_list = []
sp_close_list = []



# read in ticker data to get num examples
csvfilestream = open(file_path, 'rb')
csv_input = csv.reader(csvfilestream)

num_examples = int(math.floor((sum(1 for row in csv_input) - 8) / 60))
print "Number of examples in this dataset: " + str(num_examples)


# read in ticker data to get data
csvfilestream = open(file_path, 'rb')
csv_input = csv.reader(csvfilestream)


# retrieve example data from ticker
counter = 0
for row in csv_input:
    # increment counter
    counter = counter + 1

    # test end of file
    if counter > ((num_examples * 60) + 8):
        break

    # test beginning of file    
    if counter < 8:
        continue
    
    
    # add data to vectors
    #     DATE = 0
    #     CLOSE = 1
    #     HIGH = 2
    #     LOW = 3
    #     OPEN = 4
    #     VOLUME = 5
    close_list.append(float(row[1]))
    high_list.append(float(row[2]))
    low_list.append(float(row[3]))
    open_list.append(float(row[4]))
    volume_list.append(float(row[5]))




# Slice list into sublists
close_list = [close_list[i:i+60] for i in range(0, len(close_list), interval)]
high_list = [high_list[i:i+60] for i in range(0, len(high_list), interval)]
low_list = [low_list[i:i+60] for i in range(0, len(low_list), interval)]
open_list = [open_list[i:i+60] for i in range(0, len(open_list), interval)]
volume_list = [volume_list[i:i+60] for i in range(0, len(volume_list), interval)]

#
#
#

# S&P500
# Repeat process for S&P500
# read in ticker data to get data
csvfilestream = open(SandP_path, 'rb')
csv_input = csv.reader(csvfilestream)


# retrieve example data from ticker
counter = 0
for row in csv_input:
    # increment counter
    counter = counter + 1

    # test end of file
    if counter > ((num_examples * 60) + 8):
        break

    # test beginning of file    
    if counter < 8:
        continue


    # add data to vectors
    #     DATE = 0
    #     CLOSE = 1
    #     HIGH = 2
    #     LOW = 3
    #     OPEN = 4
    #     VOLUME = 5
    sp_close_list.append(float(row[1]))
    sp_high_list.append(float(row[2]))
    sp_low_list.append(float(row[3]))
    sp_open_list.append(float(row[4]))




# Slice list into sublists
sp_close_list = [sp_close_list[i:i+60] for i in range(0, len(sp_close_list), interval)]
sp_high_list = [sp_high_list[i:i+60] for i in range(0, len(sp_high_list), interval)]
sp_low_list = [sp_low_list[i:i+60] for i in range(0, len(sp_low_list), interval)]
sp_open_list = [sp_open_list[i:i+60] for i in range(0, len(sp_open_list), interval)]



# ORDER OF NODES
# Open, High, Low, Close, Volume, S&P....]
for i in range(0,num_examples):
    if len(open_list[i]) != 60 or len(sp_open_list[i]) != 60:
        print "excluding: " + str(i)
        print "length of open list: " + str(len(open_list[i]))
        print "length of s&p list: " + str(len(sp_open_list[i]))
        continue

    example_list = [open_list[i], high_list[i], low_list[i], close_list[i], volume_list[i], sp_open_list[i], sp_high_list[i], sp_low_list[i], sp_close_list[i]]
    example_list = [ item for sublist in example_list for item in sublist ]
    examples.append(example_list)

output_name = '../data/batch_files/' + os.path.splitext(filename)[0] + '_batch'
print "Exporting pickle dump to" + output_name

# EXPORTED AS LIST OF LISTS
pickle.dump(examples, open(output_name, 'wb'))






