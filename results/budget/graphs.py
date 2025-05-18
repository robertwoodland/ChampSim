#!/usr/bin/env python
# coding: utf-8

import os
import pandas as pd
import numpy as np
import matplotlib.pyplot as plt


resultsLocal = []

paths = os.listdir('./local/')
paths.sort(key=lambda p: tuple(map(int, p[:-4].split('_'))) if p.endswith('.txt') else (float('inf'),))
# paths.sort()
for name in paths:
    if os.path.isfile("./local/" + name):
        if name[-4:] == ".txt":
            res = pd.read_csv("./local/" + name, delimiter = "\\")
            result = ""
            for line in res.iloc[:, 0]:
                if line.startswith("Conditional Branch Prediction Accuracy"):
                    result = line.split(" ")[4][1:]
            if result != "":
                resultsLocal.append((name[:-4], result))
resultsLocal


# 10000000
# = 10^7
# Plot graph!
plt.figure(figsize=(10, 6))
plt.title("Perceptron Branch Prediction Accuracy on $10^7$ Instructions")
plt.xlabel("Local History Length")
plt.ylabel("Mispredictions (%)")

# Truncate
x = []
y = []
for result in resultsLocal:
    x.append(result[0].split("_")[1])
    y.append(float(result[1]))
plt.plot(range(len(x)), y, marker='o', markersize=4, linestyle='-', linewidth=1, color='r', label='Local')

plt.xticks(range(len(x)), x)

# Add a legend
plt.legend(loc='lower right')

# plt.xticks(x, rotation=45)
plt.grid()
plt.tight_layout()
plt.savefig("branch_prediction_accuracy.png", dpi=500)
plt.show()


resultsGlobal = []

paths = os.listdir('./global/')
paths.sort(key=lambda p: tuple(map(int, p[:-4].split('_'))) if p.endswith('.txt') else (float('inf'),))
# paths.sort()
for name in paths:
    if os.path.isfile("./global/" + name):
        if name[-4:] == ".txt":
            res = pd.read_csv("./global/" + name, delimiter = "\\")
            result = ""
            for line in res.iloc[:, 0]:
                if line.startswith("Conditional Branch Prediction Accuracy"):
                    result = line.split(" ")[4][1:]
            if result != "":
                resultsGlobal.append((name[:-4], result))
resultsGlobal


# 10000000
# = 10^7
# Plot graph!
plt.figure(figsize=(10, 6))
plt.title("Perceptron Branch Prediction Accuracy on $10^7$ Instructions")
plt.xlabel("Global History Length")
plt.ylabel("Mispredictions (%)")

# Truncate
x = []
y = []
for result in resultsGlobal:
    x.append(result[0].split("_")[2])
    y.append(float(result[1]))
plt.plot(range(len(x)), y, marker='o', markersize=4, linestyle='-', linewidth=1, color='g', label='Global')

plt.xticks(range(len(x)), x)

# Add a legend
plt.legend(loc='lower right')

# plt.xticks(x, rotation=45)
plt.grid()
plt.tight_layout()
plt.savefig("branch_prediction_accuracy.png", dpi=500)
plt.show()


resultsCount = []

paths = os.listdir('./count/')
paths.sort(key=lambda p: tuple(map(int, p[:-4].split('_'))) if p.endswith('.txt') else (float('inf'),))
# paths.sort()
for name in paths:
    if os.path.isfile("./count/" + name):
        if name[-4:] == ".txt":
            res = pd.read_csv("./count/" + name, delimiter = "\\")
            result = ""
            for line in res.iloc[:, 0]:
                if line.startswith("Conditional Branch Prediction Accuracy"):
                    result = line.split(" ")[4][1:]
            if result != "":
                resultsCount.append((name[:-4], result))
resultsCount


# 10000000
# = 10^7
# Plot graph!
plt.figure(figsize=(10, 6))
plt.title("Perceptron Branch Prediction Accuracy on $10^7$ Instructions")
plt.xlabel("Perceptron Count")
plt.ylabel("Mispredictions (%)")

x = []
y = []
for result in resultsCount:
    x.append(result[0].split("_")[3])
    y.append(float(result[1]))
plt.plot(range(len(x)), y, marker='o', markersize=4, linestyle='-', linewidth=1, color='b', label='Count')

plt.xticks(range(len(x)), x)

# Add a legend
plt.legend(loc='lower right')

# plt.xticks(x, rotation=45)
plt.grid()
plt.tight_layout()
plt.savefig("branch_prediction_accuracy.png", dpi=500)
plt.show()


resultsWidth = []

paths = os.listdir('./width/')
paths.sort(key=lambda p: tuple(map(int, p[:-4].split('_'))) if p.endswith('.txt') else (float('inf'),))
# paths.sort()
for name in paths:
    if os.path.isfile("./width/" + name):
        if name[-4:] == ".txt":
            res = pd.read_csv("./width/" + name, delimiter = "\\")
            result = ""
            for line in res.iloc[:, 0]:
                if line.startswith("Conditional Branch Prediction Accuracy"):
                    result = line.split(" ")[4][1:]
            if result != "":
                resultsWidth.append((name[:-4], result))
resultsWidth


# 10000000
# = 10^7
# Plot graph!
plt.figure(figsize=(10, 6))
plt.title("Perceptron Branch Prediction Accuracy on $10^7$ Instructions")
plt.xlabel("Weight Bit-Width")
plt.ylabel("Mispredictions (%)")

x = []
y = []
for result in resultsWidth:
    x.append(result[0].split("_")[4])
    y.append(float(result[1]))
plt.plot(range(len(x)), y, marker='o', markersize=4, linestyle='-', linewidth=1, color='orange', label='Width')

plt.xticks(range(len(x)), x)

# Add a legend
plt.legend(loc='lower right')

# plt.xticks(x, rotation=45)
plt.grid()
plt.tight_layout()
plt.savefig("branch_prediction_accuracy.png", dpi=500)
plt.show()




