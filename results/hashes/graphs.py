#!/usr/bin/env python
# coding: utf-8

import os
import pandas as pd
import numpy as np
import matplotlib.pyplot as plt


resultsTrunc = []

paths = os.listdir('./Truncate/')
paths.sort(key=lambda p: tuple(map(int, p[:-4].split('_'))) if p.endswith('.txt') else (float('inf'),))
# paths.sort()
for name in paths:
    if os.path.isfile("./Truncate/" + name):
        if name[-4:] == ".txt":
            res = pd.read_csv("./Truncate/" + name, delimiter = "\\")
            result = ""
            for line in res.iloc[:, 0]:
                if line.startswith("Conditional Branch Prediction Accuracy"):
                    result = line.split(" ")[4][1:]
            if result != "":
                resultsTrunc.append((name[:-4], result))
resultsTrunc


resultsFold = []

paths = os.listdir('./Fold/')
paths.sort(key=lambda p: tuple(map(int, p[:-4].split('_'))) if p.endswith('.txt') else (float('inf'),))
# paths.sort()
for name in paths:
    if os.path.isfile("./Fold/" + name):
        if name[-4:] == ".txt":
            res = pd.read_csv("./Fold/" + name, delimiter = "\\")
            result = ""
            for line in res.iloc[:, 0]:
                if line.startswith("Conditional Branch Prediction Accuracy"):
                    result = line.split(" ")[4][1:]
            if result != "":
                resultsFold.append((name[:-4], result))
resultsFold


resultsMod = []

paths = os.listdir('./Mod/')
paths.sort(key=lambda p: tuple(map(int, p[:-4].split('_'))) if p.endswith('.txt') else (float('inf'),))
# paths.sort()
for name in paths:
    if os.path.isfile("./Mod/" + name):
        if name[-4:] == ".txt":
            res = pd.read_csv("./Mod/" + name, delimiter = "\\")
            result = ""
            for line in res.iloc[:, 0]:
                if line.startswith("Conditional Branch Prediction Accuracy"):
                    result = line.split(" ")[4][1:]
            if result != "":
                resultsMod.append((name[:-4], result))
resultsMod


resultsFDrop = []

paths = os.listdir('./FoldDrop/')
paths.sort(key=lambda p: tuple(map(int, p[:-4].split('_'))) if p.endswith('.txt') else (float('inf'),))
# paths.sort()
for name in paths:
    if os.path.isfile("./FoldDrop/" + name):
        if name[-4:] == ".txt":
            res = pd.read_csv("./FoldDrop/" + name, delimiter = "\\")
            result = ""
            for line in res.iloc[:, 0]:
                if line.startswith("Conditional Branch Prediction Accuracy"):
                    result = line.split(" ")[4][1:]
            if result != "":
                resultsFDrop.append((name[:-4], result))
resultsFDrop


resultsFMod = []

paths = os.listdir('./FoldMod/')
paths.sort(key=lambda p: tuple(map(int, p[:-4].split('_'))) if p.endswith('.txt') else (float('inf'),))
# paths.sort()
for name in paths:
    if os.path.isfile("./FoldMod/" + name):
        if name[-4:] == ".txt":
            res = pd.read_csv("./FoldMod/" + name, delimiter = "\\")
            result = ""
            for line in res.iloc[:, 0]:
                if line.startswith("Conditional Branch Prediction Accuracy"):
                    result = line.split(" ")[4][1:]
            if result != "":
                resultsFMod.append((name[:-4], result))
resultsFMod


resultsHMod = []

paths = os.listdir('./HybridMod/')
paths.sort(key=lambda p: tuple(map(int, p[:-4].split('_'))) if p.endswith('.txt') else (float('inf'),))
# paths.sort()
for name in paths:
    if os.path.isfile("./HybridMod/" + name):
        if name[-4:] == ".txt":
            res = pd.read_csv("./HybridMod/" + name, delimiter = "\\")
            result = ""
            for line in res.iloc[:, 0]:
                if line.startswith("Conditional Branch Prediction Accuracy"):
                    result = line.split(" ")[4][1:]
            if result != "":
                resultsHMod.append((name[:-4], result))
resultsHMod


resultsHMod1 = []

paths = os.listdir('./HybridMod1/')
paths.sort(key=lambda p: tuple(map(int, p[:-4].split('_'))) if p.endswith('.txt') else (float('inf'),))
# paths.sort()
for name in paths:
    if os.path.isfile("./HybridMod1/" + name):
        if name[-4:] == ".txt":
            res = pd.read_csv("./HybridMod1/" + name, delimiter = "\\")
            result = ""
            for line in res.iloc[:, 0]:
                if line.startswith("Conditional Branch Prediction Accuracy"):
                    result = line.split(" ")[4][1:]
            if result != "":
                resultsHMod1.append((name[:-4], result))
resultsHMod1


resultsHMod2 = []

paths = os.listdir('./HybridMod2/')
paths.sort(key=lambda p: tuple(map(int, p[:-4].split('_'))) if p.endswith('.txt') else (float('inf'),))
# paths.sort()
for name in paths:
    if os.path.isfile("./HybridMod2/" + name):
        if name[-4:] == ".txt":
            res = pd.read_csv("./HybridMod2/" + name, delimiter = "\\")
            result = ""
            for line in res.iloc[:, 0]:
                if line.startswith("Conditional Branch Prediction Accuracy"):
                    result = line.split(" ")[4][1:]
            if result != "":
                resultsHMod2.append((name[:-4], result))
resultsHMod2


resultsHMod3 = []

paths = os.listdir('./HybridMod3/')
paths.sort(key=lambda p: tuple(map(int, p[:-4].split('_'))) if p.endswith('.txt') else (float('inf'),))
# paths.sort()
for name in paths:
    if os.path.isfile("./HybridMod3/" + name):
        if name[-4:] == ".txt":
            res = pd.read_csv("./HybridMod3/" + name, delimiter = "\\")
            result = ""
            for line in res.iloc[:, 0]:
                if line.startswith("Conditional Branch Prediction Accuracy"):
                    result = line.split(" ")[4][1:]
            if result != "":
                resultsHMod3.append((name[:-4], result))
resultsHMod3


# 10000000
# = 10^7
# Plot graph!
plt.figure(figsize=(10, 6))
plt.title("Perceptron Branch Prediction Accuracy on $10^7$ Instructions with different hash functions")
plt.xlabel("Predictor Size")
plt.ylabel("Misprediction (%)")

# # Truncate
# x = []
# y = []
# for result in resultsTrunc:
#     x.append(result[0])
#     y.append(float(result[1]))
# plt.plot(range(len(x)), y, marker='o', markersize=4, linestyle='-', linewidth=1, color='r', label='Truncate')

# # Fold
# x = []
# y = []
# for result in resultsFold:
#     x.append(result[0])
#     y.append(float(result[1]))
# plt.plot(range(len(x)), y, marker='o', markersize=4, linestyle='-', linewidth=1, color='g', label='Fold')

# Mod
x = []
y = []
for result in resultsMod:
    x.append(result[0])
    y.append(float(result[1]))
plt.plot(range(len(x)), y, marker='o', markersize=4, linestyle='-', linewidth=1, color='b', label='Mod')

# FoldDrop
x = []
y = []
for result in resultsFDrop:
    x.append(result[0])
    y.append(float(result[1]))
plt.plot(range(len(x)), y, marker='o', markersize=4, linestyle='-', linewidth=1, color='c', label='Fold Drop')

# FoldMod
x = []
y = []
for result in resultsFMod:
    x.append(result[0])
    y.append(float(result[1]))
plt.plot(range(len(x)), y, marker='o', markersize=4, linestyle='-', linewidth=1, color='m', label='Fold Mod')

# HybridMod
x = []
y = []
for result in resultsHMod:
    x.append(result[0])
    y.append(float(result[1]))
plt.plot(range(len(x)), y, marker='o', markersize=4, linestyle='-', linewidth=1, color='y', label='Hybrid Mod')

# HybridMod1
x = []
y = []
for result in resultsHMod1:
    x.append(result[0])
    y.append(float(result[1]))
plt.plot(range(len(x)), y, marker='o', markersize=4, linestyle='-', linewidth=1, color='k', label='Hybrid Mod 1')

# HybridMod2
x = []
y = []
for result in resultsHMod2:
    x.append(result[0])
    y.append(float(result[1]))
plt.plot(range(len(x)), y, marker='o', markersize=4, linestyle='-', linewidth=1, color='gold', label='Hybrid Mod 2')

# HybridMod3
x = []
y = []
for result in resultsHMod3:
    x.append(result[0].split('_')[0])
    y.append(float(result[1]))
plt.plot(range(len(x)), y, marker='o', markersize=4, linestyle='-', linewidth=1, color='indigo', label='Hybrid Mod 3')


plt.xticks(range(len(x)), x, rotation=45)

# Add a legend
plt.legend(loc='upper right')

# plt.xticks(x, rotation=45)
plt.grid()
plt.tight_layout()
plt.savefig("branch_prediction_accuracy.png", dpi=500)
plt.show()




