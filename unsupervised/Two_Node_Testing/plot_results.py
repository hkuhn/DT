#
# Title:
#    plot_results.py
# 
# Desc:
#    Plots groupings and input parameter (open, close, etc)
#
# Example:
#    python plot_results.py <filename> <index>


import numpy
import matplotlib.pyplot as plt
import sys



# test length of input arguments
try:
    if len(sys.argv) != 3:
        print "Not enough input arguments!!"
        exit()
except:
    print "Trouble reading in input arguments!!"
    exit()



# GLOBALS
index  = int(sys.argv[2])
DATAPATH = "../data/testing_data/" + str(sys.argv[1])
MEANS = "../Clustering/means.npy"
color = [ "blue", "red", "green", "cyan", "magenta", "yellow", "black", "white", "AliceBlue", "AntiqueWhite", "Aqua", "BlueViolet", "BurlyWood", "CadetBlue", "Chartreuse", "Chocolate", "Coral", "Crimson", "DarkCyan", "DarkBlue", "DarkMagenta", "DarkSalmon" ]


# get data
groupings = numpy.load("groupings.npy")
dataset = numpy.load(DATAPATH)
line = []
X = len(groupings) - 1

points = []
for i in range(4):
    points.append([0] * X)

#for i in range(0,X):
#    points[groupings[i]][i] = dataset[i+1][(index+1)*60 - 15]
#    line.append(dataset[i+1][(index+1)*60 - 15])
#    print str(dataset[i][(index+1)*60 - 15]) + ", " + str(dataset[i][(index+2)*60 - 15]) + ", " + str(dataset[i][(index+3)*60 - 15])


for i in range(0,X):
    line.append(dataset[i+1][(index+1)*60 - 15])#/ float(max_price )))

max_price = max(line)
avg = [el / max_price for el in line ]
print line



slopes = []
#slopes.append(0)
slopes.append(groupings[1] / pow(10,27)  - groupings[0] / pow(10,27))
for x in range(2, len(groupings)):
    slopes.append(groupings[x] / pow(10,27) - groupings[x-1] / pow(10,27))

seconder = []
seconder.append(0)
seconder.append(slopes[1] - slopes[0])
for x in range(2, len(slopes)):
    seconder.append(slopes[x] - slopes[x-1])


for i in range(0,X):
    #if groupings[i] / pow(10,27)  > -1:
    #if groupings[i] / pow(10,27) < 1:
    if seconder[i] > 0.1:
        points[0][i] = dataset[i+1][(index+1)*60 - 15]
    elif seconder[i] < -0.1:
        points[2][i] = dataset[i+1][(index+1)*60 - 15]
    else:
        #points[1][i] = dataset[i+1][(index+1)*60 - 15]
        points[1][i] = 0


#for i in range(0,X):
#    
#        points[3][i] = dataset[i+1][(index+1)*60 - 15]


for i in range(len(points)):
    plt.scatter(range(0,X), points[i], color=color[i])


print X
#for i in range(len(points)):
#    plt.scatter(range(0,X), points[i], color=color[i])
plt.scatter(range(0,X), groupings[:X] / pow(10,27), color="cyan")


print X
print len(slopes)
#plt.plot(range(0,X), slopes, color="magenta")
print len(seconder)
plt.plot(range(0,X), seconder, color="magenta")


plt.plot(range(0,X), line, color="black")
plt.plot(range(0,X), avg, color="red")
plt.show()














