#!/usr/bin/env python
# coding: utf-8

import os
import pandas as pd
import numpy as np
import matplotlib.pyplot as plt


resultsTheta = []
resultsConst = []

paths = os.listdir('./')
paths.sort(key=lambda p: tuple(map(float, p[:-4].split('_'))) if p.endswith('.txt') else (float('inf'),))
# paths.sort()
for name in paths:
    if os.path.isfile(name):
        if name[-4:] == ".txt":
            if name.split("_")[1][:-4] == "14":
                res = pd.read_csv(name, delimiter = "\\")
                result = ""
                for line in res.iloc[:, 0]:
                    if line.startswith("Conditional Branch Prediction Accuracy"):
                        result = line.split(" ")[4][1:]
                if result != "":
                    resultsTheta.append((name[:-4], result))
            if name.split("_")[0] == "1.93":
                res = pd.read_csv(name, delimiter = "\\")
                result = ""
                for line in res.iloc[:, 0]:
                    if line.startswith("Conditional Branch Prediction Accuracy"):
                        result = line.split(" ")[4][1:]
                if result != "":
                    resultsConst.append((name[:-4], result))
resultsTheta


# Plot graph!
plt.figure(figsize=(10, 6))
plt.title("Perceptron Branch Prediction Accuracy with $10^7$ Instructions on gcc")
plt.xlabel("Threshold (Linear Term)")
plt.ylabel("Mispredictions (%)")

# # Tournament 400
# x = []
# y = []
# for result in resultsT400:
#     x.append(result[0].split("_")[0])
#     y.append(float(result[1]))
# plt.plot(range(len(x)), y, marker='o', markersize=4, linestyle='-', linewidth=1, color='g', label='Tournament')


# Perceptron Theta
x = []
y = []
for result in resultsTheta:
    # if float(result[0].split("_")[0]) > 1 and float(result[0].split("_")[0]) < 4:
    x.append(float(result[0].split("_")[0]))
    y.append(float(result[1]))
    if float(result[0].split("_")[0]) < 1 or float(result[0].split("_")[0]) > 4:
        plt.annotate(x[-1], (float(x[-1]), float(y[-1] + 0.0001)))
plt.plot(x, y, marker='o', markersize=4, linestyle='-', linewidth=1, color='b', label='Varying Linear Term')


# Perceptron Const
x1 = []
y1 = []
for result in resultsConst:
    x1.append(float(result[0].split("_")[1]))
    y1.append(float(result[1]))
x2 = np.multiply(x1, max(x)/max(x1))
    
for i in range(0, len(x2)):
    plt.annotate(int(x1[i]), (float(x2[i]), float(y1[i]+ 0.0005)))
plt.plot(x2, y1, marker='o', markersize=4, linestyle='-', linewidth=1, color='r', label='Varying Constant')


# print(x[-1], y[-1])

# # BHT 400
# x = []
# y = []
# for result in resultsB400:
#     x.append(result[0].split("_")[0])
#     y.append(float(result[1]))
# plt.plot(range(len(x)), y, marker='o', markersize=4, linestyle='-', linewidth=1, color='r', label='BHT')

# plt.xticks(range(len(x)), x)

# plt.ylim(ymin=0)

# Add a legend
plt.legend(loc='upper right')

# plt.xticks(x, rotation=45)
plt.grid()
plt.tight_layout()
plt.savefig("branch_prediction_accuracy.png", dpi=500)
plt.show()




