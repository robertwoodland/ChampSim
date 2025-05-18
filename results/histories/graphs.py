#!/usr/bin/env python
# coding: utf-8

import os
import pandas as pd
import numpy as np
import matplotlib.pyplot as plt


results = []

paths = os.listdir('./perceptron/')
paths.sort(key=lambda p: tuple(map(int, p[:-4].split('_'))) if p.endswith('.txt') else (float('inf'),))
# paths.sort()
for name in paths:
    if os.path.isfile("./perceptron/" + name):
        if name[-4:] == ".txt":
            res = pd.read_csv("./perceptron/" + name, delimiter = "\\")
            result = ""
            for line in res.iloc[:, 0]:
                if line.startswith("Conditional Branch Prediction Accuracy"):
                    result = line.split(" ")[4][1:]
            if result != "":
                results.append((name[:-4], result))
results


resultsUpdate = []

paths = os.listdir('./perceptron1/')
paths.sort(key=lambda p: tuple(map(int, p[:-4].split('_'))) if p.endswith('.txt') else (float('inf'),))
# paths.sort()
for name in paths:
    if os.path.isfile("./perceptron1/" + name):
        if name[-4:] == ".txt":
            res = pd.read_csv("./perceptron1/" + name, delimiter = "\\")
            result = ""
            for line in res.iloc[:, 0]:
                if line.startswith("CPU 0 Branch Prediction Accuracy:"):
                    result = line.split(" ")[5][:-1]
            if result != "":
                resultsUpdate.append((name[:-4], result))
resultsUpdate


resultsNoMask = []

paths = os.listdir('./perceptron2/')
paths.sort(key=lambda p: tuple(map(int, p[:-4].split('_'))) if p.endswith('.txt') else (float('inf'),))
# paths.sort()
for name in paths:
    if os.path.isfile("./perceptron2/" + name):
        if name[-4:] == ".txt":
            res = pd.read_csv("./perceptron2/" + name, delimiter = "\\")
            result = ""
            for line in res.iloc[:, 0]:
                if line.startswith("CPU 0 Branch Prediction Accuracy:"):
                    result = line.split(" ")[5][:-1]
            if result != "":
                resultsNoMask.append((name[:-4], result))
resultsNoMask


# Added back random line in testpred
resultsAhead= []

paths = os.listdir('./perceptron5/')
paths.sort(key=lambda p: tuple(map(int, p[:-4].split('_'))) if p.endswith('.txt') else (float('inf'),))
# paths.sort()
for name in paths:
    if os.path.isfile("./perceptron5/" + name):
        if name[-4:] == ".txt":
            res = pd.read_csv("./perceptron5/" + name, delimiter = "\\")
            result = ""
            for line in res.iloc[:, 0]:
                if line.startswith("CPU 0 Branch Prediction Accuracy:"):
                    result = line.split(" ")[5][:-1]
            if result != "":
                resultsAhead.append((name[:-4], result))
resultsAhead


# Added back random line in testpred
# resultsNew = []
resultsNew3 = []

paths = os.listdir('./perceptronNew/')
paths.sort(key=lambda p: tuple(map(int, p[:-4].split('_'))) if p.endswith('.txt') else (float('inf'),))
# paths.sort()
for name in paths:
    if os.path.isfile("./perceptronNew/" + name):
        if name[-4:] == ".txt":
            res = pd.read_csv("./perceptronNew/" + name, delimiter = "\\")
            result = ""
            for line in res.iloc[:, 0]:
                if line.startswith("CPU 0 Branch Prediction Accuracy:"):
                    result = line.split(" ")[5][:-1]
            if result != "":
                # resultsNew.append((name[:-4], result))
                resultsNew3.append((name[:-4], result))
# resultsNew
resultsNew3


resultsNew2 = []

paths = os.listdir('./perceptronNew2/')
paths.sort(key=lambda p: tuple(map(int, p[:-4].split('_'))) if p.endswith('.txt') else (float('inf'),))
# paths.sort()
for name in paths:
    if os.path.isfile("./perceptronNew2/" + name):
        if name[-4:] == ".txt":
            res = pd.read_csv("./perceptronNew2/" + name, delimiter = "\\")
            result = ""
            for line in res.iloc[:, 0]:
                if line.startswith("CPU 0 Branch Prediction Accuracy:"):
                    result = line.split(" ")[5][:-1]
            if result != "":
                # resultsNew.append((name[:-4], result))
                resultsNew2.append((name[:-4], result))
# resultsNew
resultsNew2


resultsNew3 = []

paths = os.listdir('./perceptronNew3/')
paths.sort(key=lambda p: tuple(map(int, p[:-4].split('_'))) if p.endswith('.txt') else (float('inf'),))
# paths.sort()
for name in paths:
    if os.path.isfile("./perceptronNew3/" + name):
        if name[-4:] == ".txt":
            res = pd.read_csv("./perceptronNew3/" + name, delimiter = "\\")
            result = ""
            for line in res.iloc[:, 0]:
                if line.startswith("CPU 0 Branch Prediction Accuracy:"):
                    result = line.split(" ")[5][:-1]
            if result != "":
                # resultsNew.append((name[:-4], result))
                resultsNew3.append((name[:-4], result))
# resultsNew
resultsNew3


resultsInit = []

paths = os.listdir('./perceptronInit/')
paths.sort(key=lambda p: tuple(map(int, p[:-4].split('_'))) if p.endswith('.txt') else (float('inf'),))
# paths.sort()
for name in paths:
    if os.path.isfile("./perceptronInit/" + name):
        if name[-4:] == ".txt":
            res = pd.read_csv("./perceptronInit/" + name, delimiter = "\\")
            result = ""
            for line in res.iloc[:, 0]:
                if line.startswith("CPU 0 Branch Prediction Accuracy:"):
                    result = line.split(" ")[5][:-1]
            if result != "":
                resultsInit.append((name[:-4], result))
resultsInit


resultsNoInit = []

paths = os.listdir('./perceptronNoInit/')
paths.sort(key=lambda p: tuple(map(int, p[:-4].split('_'))) if p.endswith('.txt') else (float('inf'),))
# paths.sort()
for name in paths:
    if os.path.isfile("./perceptronNoInit/" + name):
        if name[-4:] == ".txt":
            res = pd.read_csv("./perceptronNoInit/" + name, delimiter = "\\")
            result = ""
            for line in res.iloc[:, 0]:
                if line.startswith("CPU 0 Branch Prediction Accuracy:"):
                    result = line.split(" ")[5][:-1]
            if result != "":
                resultsNoInit.append((name[:-4], result))
resultsNoInit


# Added back random line in testpred
resultsBhtNew = []

paths = os.listdir('./bhtNew/')
paths.sort(key=lambda p: tuple(map(int, p[:-4].split('_'))) if p.endswith('.txt') else (float('inf'),))
# paths.sort()
for name in paths:
    if os.path.isfile("./bhtNew/" + name):
        if name[-4:] == ".txt":
            res = pd.read_csv("./bhtNew/" + name, delimiter = "\\")
            result = ""
            for line in res.iloc[:, 0]:
                if line.startswith("CPU 0 Branch Prediction Accuracy:"):
                    result = line.split(" ")[5][:-1]
            if result != "":
                resultsBhtNew.append((name[:-4], result))
resultsBhtNew


# Added back random line in testpred
resultsTourNew = []

paths = os.listdir('./tourNew/')
paths.sort(key=lambda p: tuple(map(int, p[:-4].split('_'))) if p.endswith('.txt') else (float('inf'),))
# paths.sort()
for name in paths:
    if os.path.isfile("./tourNew/" + name):
        if name[-4:] == ".txt":
            res = pd.read_csv("./tourNew/" + name, delimiter = "\\")
            result = ""
            for line in res.iloc[:, 0]:
                if line.startswith("CPU 0 Branch Prediction Accuracy:"):
                    result = line.split(" ")[5][:-1]
            if result != "":
                resultsTourNew.append((name[:-4], result))
resultsTourNew


resultsOld = []

paths = os.listdir('./old/')
paths.sort(key=lambda p: tuple(map(int, p[:-4].split('_'))) if p.endswith('.txt') else (float('inf'),))
# paths.sort()
for name in paths:
    if os.path.isfile("old/" + name):
        if name[-4:] == ".txt":
            res = pd.read_csv("old/" + name, delimiter = "\\")
            result = ""
            for line in res.iloc[:, 0]:
                if line.startswith("CPU 0 Branch Prediction Accuracy:"):
                    result = line.split(" ")[5][:-1]
            if result != "":
                resultsOld.append((name[:-4], result))
resultsOld


resultsBHT = []

paths = os.listdir('./bhtLong/')
paths.sort(key=lambda p: tuple(map(int, p[:-4].split('_'))) if p.endswith('.txt') else (float('inf'),))
# paths.sort()
for name in paths:
    if os.path.isfile("bhtLong/" + name):
        if name[-4:] == ".txt":
            res = pd.read_csv("bhtLong/" + name, delimiter = "\\")
            result = ""
            for line in res.iloc[:, 0]:
                if line.startswith("Conditional Branch Prediction Accuracy"):
                    result = line.split(" ")[4][1:]
            if result != "":
                resultsBHT.append((name[:-4], result))
resultsBHT


resultsBHTNew = []

paths = os.listdir('./bhtNewHash/')
paths.sort(key=lambda p: tuple(map(int, p[:-4].split('_'))) if p.endswith('.txt') else (float('inf'),))
# paths.sort()
for name in paths:
    if os.path.isfile("bhtNewHash/" + name):
        if name[-4:] == ".txt":
            res = pd.read_csv("bhtNewHash/" + name, delimiter = "\\")
            result = ""
            for line in res.iloc[:, 0]:
                if line.startswith("Conditional Branch Prediction Accuracy"):
                    result = line.split(" ")[4][1:]
            if result != "":
                resultsBHTNew.append((name[:-4], result))
resultsBHTNew


resultsTOUR = []

paths = os.listdir('./tourLong/')
paths.sort(key=lambda p: tuple(map(int, p[:-4].split('_'))) if p.endswith('.txt') else (float('inf'),))
# paths.sort()
for name in paths:
    if os.path.isfile("tourLong/" + name):
        if name[-4:] == ".txt":
            res = pd.read_csv("tourLong/" + name, delimiter = "\\")
            result = ""
            for line in res.iloc[:, 0]:
                if line.startswith("Conditional Branch Prediction Accuracy"):
                    result = line.split(" ")[4][1:]
            if result != "":
                resultsTOUR.append((name[:-4], result))
resultsTOUR


resultsPLong= []

paths = os.listdir('./perceptronLong/')
paths.sort(key=lambda p: tuple(map(int, p[:-4].split('_'))) if p.endswith('.txt') else (float('inf'),))
# paths.sort()
for name in paths:
    if os.path.isfile("perceptronLong/" + name):
        if name[-4:] == ".txt":
            res = pd.read_csv("perceptronLong/" + name, delimiter = "\\")
            result = ""
            for line in res.iloc[:, 0]:
                if line.startswith("Conditional Branch Prediction Accuracy"):
                    result = line.split(" ")[4][1:]
            if result != "":
                resultsPLong.append((name[:-4], result))
resultsPLong


resultsBLong= []

paths = os.listdir('./bhtLong/')
paths.sort(key=lambda p: tuple(map(int, p[:-4].split('_'))) if p.endswith('.txt') else (float('inf'),))
# paths.sort()
for name in paths:
    if os.path.isfile("bhtLong/" + name):
        if name[-4:] == ".txt":
            res = pd.read_csv("bhtLong/" + name, delimiter = "\\")
            result = ""
            for line in res.iloc[:, 0]:
                if line.startswith("Conditional Branch Prediction Accuracy"):
                    result = line.split(" ")[4][1:]
            if result != "":
                resultsBLong.append((name[:-4], result))
resultsBLong


# Plot graph!
plt.figure(figsize=(10, 6))
plt.title("Perceptron Branch Prediction Accuracy on $10^7$ Instructions")
plt.xlabel("Predictor Size/Config")
plt.ylabel("Mispredictions (%)")


# # BHT
# x = []
# y = []
# for result in resultsBHT:
#     x.append(result[0])
#     y.append(float(result[1]))
# plt.plot(range(len(x)), y, marker='o', linestyle='-', color='r', label='BHT')

# # Tournament
# x = []
# y = []
# for result in resultsTOUR:
#     x.append(result[0])
#     y.append(float(result[1]))
# plt.plot(range(len(x)), y, marker='o', linestyle='-', color='r', label='Tournament')





# # Perceptron Pred 2
# x = []
# y = []
# for result in resultsNoMask:
#     x.append(result[0])
#     y.append(float(result[1]))
# plt.plot(range(len(x)), y, marker='o', linestyle='-', color='b', label='Perceptron Bit Mix No Mask Predictor')

# # Perceptron Pred 3
# x = []
# y = []
# for result in resultsFold:
#     x.append(result[0])
#     y.append(float(result[1]))
# plt.plot(range(len(x)), y, marker='o', linestyle='-', color='r', label='Perceptron Bit Fold Mod')

# # Perceptron Pred 4
# x = []
# y = []
# for result in resultsNoMod:
#     x.append(result[0])
#     y.append(float(result[1]))
# plt.plot(range(len(x)), y, marker='o', linestyle='-', color='g', label='Perceptron Bit Fold Drop MSB')

# # Perceptron New
# x = []
# y = []
# for result in resultsUpdate:
#     x.append(result[0])
#     y.append(float(result[1]))
# plt.plot(range(len(x)), y, marker='o', linestyle='-', color='b', label='Perceptron New Threshold')

# # Perceptron Newer
# x = []
# y = []
# for result in resultsAhead:
#     x.append(result[0])
#     y.append(float(result[1]))
# plt.plot(range(len(x)), y, marker='o', linestyle='-', color='r', label='Perceptron Random Ahead Thing')


# # BHT Newest
# x = []
# y = []
# for result in resultsBhtNew:
#     x.append(result[0])
#     y.append(float(result[1]))
# plt.plot(range(len(x)), y, marker='o', linestyle='-', color='g', label='BHT')


# # Tour Newest
# x = []
# y = []
# for result in resultsTourNew:
#     x.append(result[0])
#     y.append(float(result[1]))
# plt.plot(range(len(x)), y, marker='o', linestyle='-', color='r', label='Tournament')


# # Perceptron NewestHash
# x = []
# y = []
# for result in resultsNew3:
#     x.append(result[0])
#     y.append(float(result[1]))
# plt.plot(range(len(x)), y, marker='o', linestyle='-', color='g', label='Perceptron New Hash 3')

# # Perceptron NewestHash2
# x = []
# y = []
# for result in resultsNew2:
#     x.append(result[0])
#     y.append(float(result[1]))
# plt.plot(range(len(x)), y, marker='o', linestyle='-', color='r', label='Perceptron New Hash 2')


# # Perceptron NewestHash3
# x = []
# y = []
# for result in resultsNew3:
#     x.append(result[0])
#     y.append(float(result[1]))
# plt.plot(range(len(x)), y, marker='o', linestyle='-', color='b', label='Perceptron New Hash 3 - HybridMod3')

# # Perceptron Init
# x = []
# y = []
# for result in resultsInit:
#     x.append(result[0])
#     y.append(float(result[1]))
# plt.plot(range(len(x)), y, marker='o', linestyle='-', color='g', label='Perceptron Hist Init')

# # Perceptron No Init
# x = []
# y = []
# for result in resultsNoInit:
#     x.append(result[0])
#     y.append(float(result[1]))
# plt.plot(range(len(x)), y, marker='o', linestyle='-', color='b', label='Perceptron Hist No Init')




# BHT Long
x = []
y = []
for result in resultsBHT:
    x.append(result[0])
    y.append(float(result[1]))
plt.plot(range(len(x)), y, marker='o', linestyle='-', color='r', label='BHT')


# # BHT New Hash
# x = []
# y = []
# for result in resultsBHTNew:
#     x.append(result[0])
#     y.append(float(result[1]))
# plt.plot(range(len(x)), y, marker='o', linestyle='-', color='orange', label='BHT Shift by 1')



# Tour Long
x = []
y = []
for result in resultsTOUR:
    x.append(result[0])
    y.append(float(result[1]))
plt.plot(range(len(x)), y, marker='o', linestyle='-', color='g', label='Tournament')


# Perceptron Long
# 10000000 = 10^7
x = []
y = []
for result in results:
    x.append(result[0])
    y.append(float(result[1]))
plt.plot(range(len(x)), y, marker='o', linestyle='-', color='b', label='Perceptron')


plt.xticks(range(len(x)), x, rotation=45)

# Add a legend
plt.legend(loc='lower right')

# plt.xticks(x, rotation=45)
plt.grid()
plt.tight_layout()
plt.savefig("branch_prediction_accuracy.png")
plt.show()




