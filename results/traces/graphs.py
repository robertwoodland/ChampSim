#!/usr/bin/env python
# coding: utf-8

import os
import pandas as pd
import numpy as np
import matplotlib.pyplot as plt


resultsP400 = []

paths = os.listdir('./perceptron/400/')
paths.sort(key=lambda p: tuple(map(int, p[:-4].split('_'))) if p.endswith('.txt') else (float('inf'),))
# paths.sort()
for name in paths:
    if os.path.isfile("./perceptron/400/" + name):
        if name[-4:] == ".txt":
            res = pd.read_csv("./perceptron/400/" + name, delimiter = "\\")
            result = ""
            for line in res.iloc[:, 0]:
                if line.startswith("Conditional Branch Prediction Accuracy"):
                    result = line.split(" ")[4][1:]
            if result != "":
                resultsP400.append((name[:-4], result))
resultsP400


resultsT400 = []

paths = os.listdir('./tour/400/')
paths.sort(key=lambda p: tuple(map(int, p[:-4].split('_'))) if p.endswith('.txt') else (float('inf'),))
# paths.sort()
for name in paths:
    if os.path.isfile("./tour/400/" + name):
        if name[-4:] == ".txt":
            res = pd.read_csv("./tour/400/" + name, delimiter = "\\")
            result = ""
            for line in res.iloc[:, 0]:
                if line.startswith("Conditional Branch Prediction Accuracy"):
                    result = line.split(" ")[4][1:]
            if result != "":
                resultsT400.append((name[:-4], result))
resultsT400


resultsB400 = []

paths = os.listdir('./bht/400/')
paths.sort(key=lambda p: tuple(map(int, p[:-4].split('_'))) if p.endswith('.txt') else (float('inf'),))
# paths.sort()
for name in paths:
    if os.path.isfile("./bht/400/" + name):
        if name[-4:] == ".txt":
            res = pd.read_csv("./bht/400/" + name, delimiter = "\\")
            result = ""
            for line in res.iloc[:, 0]:
                if line.startswith("Conditional Branch Prediction Accuracy"):
                    result = line.split(" ")[4][1:]
            if result != "":
                resultsB400.append((name[:-4], result))
resultsB400


# Plot graph!
plt.figure(figsize=(10, 6))
plt.title("Perceptron Branch Prediction Accuracy with $10^7$ Instructions on Perlbench")
plt.xlabel("Hardware Budget (Bytes)")
plt.ylabel("Mispredictions (%)")

# Tournament 400
x = []
y = []
for result in resultsT400:
    x.append(result[0].split("_")[0])
    y.append(float(result[1]))
plt.plot(range(len(x)), y, marker='o', markersize=4, linestyle='-', linewidth=1, color='g', label='Tournament')

# Perceptron 400
x = []
y = []
for result in resultsP400:
    x.append(result[0].split("_")[0])
    y.append(float(result[1]))
plt.plot(range(len(x)), y, marker='o', markersize=4, linestyle='-', linewidth=1, color='b', label='Perceptron')

# BHT 400
x = []
y = []
for result in resultsB400:
    x.append(result[0].split("_")[0])
    y.append(float(result[1]))
plt.plot(range(len(x)), y, marker='o', markersize=4, linestyle='-', linewidth=1, color='r', label='BHT')

plt.xticks(range(len(x)), x)

plt.ylim(ymin=0)

# Add a legend
plt.legend(loc='upper right')

# plt.xticks(x, rotation=45)
plt.grid()
plt.tight_layout()
plt.savefig("branch_prediction_accuracy.png", dpi=500)
plt.show()


resultsP401= []

paths = os.listdir('./perceptron/401-config/')
paths.sort(key=lambda p: tuple(map(int, p[:-4].split('_'))) if p.endswith('.txt') else (float('inf'),))
# paths.sort()
for name in paths:
    if os.path.isfile("./perceptron/401-config/" + name):
        if name[-4:] == ".txt":
            res = pd.read_csv("./perceptron/401-config/" + name, delimiter = "\\")
            result = ""
            for line in res.iloc[:, 0]:
                if line.startswith("Conditional Branch Prediction Accuracy"):
                    result = line.split(" ")[4][1:]
            if result != "":
                resultsP401.append((name[:-4], result))
resultsP401


resultsT401= []

paths = os.listdir('./tour/401/')
paths.sort(key=lambda p: tuple(map(int, p[:-4].split('_'))) if p.endswith('.txt') else (float('inf'),))
# paths.sort()
for name in paths:
    if os.path.isfile("./tour/401/" + name):
        if name[-4:] == ".txt":
            res = pd.read_csv("./tour/401/" + name, delimiter = "\\")
            result = ""
            for line in res.iloc[:, 0]:
                if line.startswith("Conditional Branch Prediction Accuracy"):
                    result = line.split(" ")[4][1:]
            if result != "":
                resultsT401.append((name[:-4], result))
resultsT401


resultsB401 = []

paths = os.listdir('./bht/401/')
paths.sort(key=lambda p: tuple(map(int, p[:-4].split('_'))) if p.endswith('.txt') else (float('inf'),))
# paths.sort()
for name in paths:
    if os.path.isfile("./bht/401/" + name):
        if name[-4:] == ".txt":
            res = pd.read_csv("./bht/401/" + name, delimiter = "\\")
            result = ""
            for line in res.iloc[:, 0]:
                if line.startswith("Conditional Branch Prediction Accuracy"):
                    result = line.split(" ")[4][1:]
            if result != "":
                resultsB401.append((name[:-4], result))
resultsB401


# Plot graph!
plt.figure(figsize=(10, 6))
plt.title("Perceptron Branch Prediction Accuracy with $10^7$ Instructions on bzip2")
plt.xlabel("Hardware Budget (Bytes)")
plt.ylabel("Mispredictions (%)")

# Perceptron 401
x = []
y = []
for result in resultsP401:
    x.append(result[0].split("_")[0])
    y.append(float(result[1]))
plt.plot(range(len(x)), y, marker='o', markersize=4, linestyle='-', linewidth=1, color='b', label='Perceptron')

# Tournament 401
x = []
y = []
for result in resultsT401:
    x.append(result[0].split("_")[0])
    y.append(float(result[1]))
plt.plot(range(len(x)), y, marker='o', markersize=4, linestyle='-', linewidth=1, color='g', label='Tournament')

# BHT 401
x = []
y = []
for result in resultsB401:
    x.append(result[0].split("_")[0])
    y.append(float(result[1]))
plt.plot(range(len(x)), y, marker='o', markersize=4, linestyle='-', linewidth=1, color='r', label='BHT')

plt.xticks(range(len(x)), x)

plt.ylim(ymin=0)

# Add a legend
plt.legend(loc='upper right')

# plt.xticks(x, rotation=45)
plt.grid()
plt.tight_layout()
plt.savefig("branch_prediction_accuracy.png", dpi=500)
plt.show()


resultsP403 = []

paths = os.listdir('./perceptron/403/')
paths.sort(key=lambda p: tuple(map(int, p[:-4].split('_'))) if p.endswith('.txt') else (float('inf'),))
# paths.sort()
for name in paths:
    if os.path.isfile("./perceptron/403/" + name):
        if name[-4:] == ".txt":
            res = pd.read_csv("./perceptron/403/" + name, delimiter = "\\")
            result = ""
            for line in res.iloc[:, 0]:
                if line.startswith("Conditional Branch Prediction Accuracy"):
                    result = line.split(" ")[4][1:]
            if result != "":
                resultsP403.append((name[:-4], result))
resultsP403


resultsT403= []

paths = os.listdir('./tour/403/')
paths.sort(key=lambda p: tuple(map(int, p[:-4].split('_'))) if p.endswith('.txt') else (float('inf'),))
# paths.sort()
for name in paths:
    if os.path.isfile("./tour/403/" + name):
        if name[-4:] == ".txt":
            res = pd.read_csv("./tour/403/" + name, delimiter = "\\")
            result = ""
            for line in res.iloc[:, 0]:
                if line.startswith("Conditional Branch Prediction Accuracy"):
                    result = line.split(" ")[4][1:]
            if result != "":
                resultsT403.append((name[:-4], result))
resultsT403


resultsB403= []

paths = os.listdir('./bht/403/')
paths.sort(key=lambda p: tuple(map(int, p[:-4].split('_'))) if p.endswith('.txt') else (float('inf'),))
# paths.sort()
for name in paths:
    if os.path.isfile("./bht/403/" + name):
        if name[-4:] == ".txt":
            res = pd.read_csv("./bht/403/" + name, delimiter = "\\")
            result = ""
            for line in res.iloc[:, 0]:
                if line.startswith("Conditional Branch Prediction Accuracy"):
                    result = line.split(" ")[4][1:]
            if result != "":
                resultsB403.append((name[:-4], result))
resultsB403


# Plot graph!
plt.figure(figsize=(10, 6))
plt.title("Perceptron Branch Prediction Accuracy with $10^7$ Instructions on gcc")
plt.xlabel("Hardware Budget (Bytes)")
plt.ylabel("Mispredictions (%)")

# Perceptron 403
x = []
y = []
for result in resultsP403:
    x.append(result[0].split("_")[0])
    y.append(float(result[1]))
plt.plot(range(len(x)), y, marker='o', markersize=4, linestyle='-', linewidth=1, color='b', label='Perceptron')

# Tournament 403
x = []
y = []
for result in resultsT403:
    x.append(result[0].split("_")[0])
    y.append(float(result[1]))
plt.plot(range(len(x)), y, marker='o', markersize=4, linestyle='-', linewidth=1, color='g', label='Tournament')

# BHT 403
x = []
y = []
for result in resultsB403:
    x.append(result[0].split("_")[0])
    y.append(float(result[1]))
plt.plot(range(len(x)), y, marker='o', markersize=4, linestyle='-', linewidth=1, color='r', label='BHT')

plt.xticks(range(len(x)), x)

plt.ylim(ymin=0)

# Add a legend
plt.legend(loc='upper right')

# plt.xticks(x, rotation=45)
plt.grid()
plt.tight_layout()
plt.savefig("branch_prediction_accuracy.png", dpi=500)
plt.show()


resultsP429= []

paths = os.listdir('./perceptron/429/')
paths.sort(key=lambda p: tuple(map(int, p[:-4].split('_'))) if p.endswith('.txt') else (float('inf'),))
# paths.sort()
for name in paths:
    if os.path.isfile("./perceptron/429/" + name):
        if name[-4:] == ".txt":
            res = pd.read_csv("./perceptron/429/" + name, delimiter = "\\")
            result = ""
            for line in res.iloc[:, 0]:
                if line.startswith("Conditional Branch Prediction Accuracy"):
                    result = line.split(" ")[4][1:]
            if result != "":
                resultsP429.append((name[:-4], result))
resultsP429


resultsT429= []

paths = os.listdir('./tour/429/')
paths.sort(key=lambda p: tuple(map(int, p[:-4].split('_'))) if p.endswith('.txt') else (float('inf'),))
# paths.sort()
for name in paths:
    if os.path.isfile("./tour/429/" + name):
        if name[-4:] == ".txt":
            res = pd.read_csv("./tour/429/" + name, delimiter = "\\")
            result = ""
            for line in res.iloc[:, 0]:
                if line.startswith("Conditional Branch Prediction Accuracy"):
                    result = line.split(" ")[4][1:]
            if result != "":
                resultsT429.append((name[:-4], result))
resultsT429


resultsB429= []

paths = os.listdir('./bht/429/')
paths.sort(key=lambda p: tuple(map(int, p[:-4].split('_'))) if p.endswith('.txt') else (float('inf'),))
# paths.sort()
for name in paths:
    if os.path.isfile("./bht/429/" + name):
        if name[-4:] == ".txt":
            res = pd.read_csv("./bht/429/" + name, delimiter = "\\")
            result = ""
            for line in res.iloc[:, 0]:
                if line.startswith("Conditional Branch Prediction Accuracy"):
                    result = line.split(" ")[4][1:]
            if result != "":
                resultsB429.append((name[:-4], result))
resultsB429


# Plot graph!
plt.figure(figsize=(10, 6))
plt.title("Perceptron Branch Prediction Accuracy with $10^7$ Instructions on mcf")
plt.xlabel("Hardware Budget (Bytes)")
plt.ylabel("Mispredictions (%)")

# Perceptron 429
x = []
y = []
for result in resultsP429:
    x.append(result[0].split("_")[0])
    y.append(float(result[1]))
plt.plot(range(len(x)), y, marker='o', markersize=4, linestyle='-', linewidth=1, color='b', label='Perceptron')

# Tournament 429
x = []
y = []
for result in resultsT429:
    x.append(result[0].split("_")[0])
    y.append(float(result[1]))
plt.plot(range(len(x)), y, marker='o', markersize=4, linestyle='-', linewidth=1, color='g', label='Tournament')

# BHT 429
x = []
y = []
for result in resultsB429:
    x.append(result[0].split("_")[0])
    y.append(float(result[1]))
plt.plot(range(len(x)), y, marker='o', markersize=4, linestyle='-', linewidth=1, color='r', label='BHT')

plt.xticks(range(len(x)), x)

plt.ylim(ymin=0)

# Add a legend
plt.legend(loc='upper right')

# plt.xticks(x, rotation=45)
plt.grid()
plt.tight_layout()
plt.savefig("branch_prediction_accuracy.png", dpi=500)
plt.show()


resultsP454= []

paths = os.listdir('./perceptron/454/')
paths.sort(key=lambda p: tuple(map(int, p[:-4].split('_'))) if p.endswith('.txt') else (float('inf'),))
# paths.sort()
for name in paths:
    if os.path.isfile("./perceptron/454/" + name):
        if name[-4:] == ".txt":
            res = pd.read_csv("./perceptron/454/" + name, delimiter = "\\")
            result = ""
            for line in res.iloc[:, 0]:
                if line.startswith("Conditional Branch Prediction Accuracy"):
                    result = line.split(" ")[4][1:]
            if result != "":
                resultsP454.append((name[:-4], result))
resultsP454


resultsT454= []

paths = os.listdir('./tour/454/')
paths.sort(key=lambda p: tuple(map(int, p[:-4].split('_'))) if p.endswith('.txt') else (float('inf'),))
# paths.sort()
for name in paths:
    if os.path.isfile("./tour/454/" + name):
        if name[-4:] == ".txt":
            res = pd.read_csv("./tour/454/" + name, delimiter = "\\")
            result = ""
            for line in res.iloc[:, 0]:
                if line.startswith("Conditional Branch Prediction Accuracy"):
                    result = line.split(" ")[4][1:]
            if result != "":
                resultsT454.append((name[:-4], result))
resultsT454


resultsB454= []

paths = os.listdir('./bht/454/')
paths.sort(key=lambda p: tuple(map(int, p[:-4].split('_'))) if p.endswith('.txt') else (float('inf'),))
# paths.sort()
for name in paths:
    if os.path.isfile("./bht/454/" + name):
        if name[-4:] == ".txt":
            res = pd.read_csv("./bht/454/" + name, delimiter = "\\")
            result = ""
            for line in res.iloc[:, 0]:
                if line.startswith("Conditional Branch Prediction Accuracy"):
                    result = line.split(" ")[4][1:]
            if result != "":
                resultsB454.append((name[:-4], result))
resultsB454


# Plot graph!
plt.figure(figsize=(10, 6))
plt.title("Perceptron Branch Prediction Accuracy with $10^7$ Instructions on calculix")
plt.xlabel("Hardware Budget (Bytes)")
plt.ylabel("Mispredictions (%)")

# Perceptron 454
x = []
y = []
for result in resultsP454:
    x.append(result[0].split("_")[0])
    y.append(float(result[1]))
plt.plot(range(len(x)), y, marker='o', markersize=4, linestyle='-', linewidth=1, color='b', label='Perceptron')

# Tournament 454
x = []
y = []
for result in resultsT454:
    x.append(result[0].split("_")[0])
    y.append(float(result[1]))
plt.plot(range(len(x)), y, marker='o', markersize=4, linestyle='-', linewidth=1, color='g', label='Tournament')

# BHT 454
x = []
y = []
for result in resultsB454:
    x.append(result[0].split("_")[0])
    y.append(float(result[1]))
plt.plot(range(len(x)), y, marker='o', markersize=4, linestyle='-', linewidth=1, color='r', label='BHT')

plt.xticks(range(len(x)), x)

plt.ylim(ymin=0)

# Add a legend
plt.legend(loc='upper right')

# plt.xticks(x, rotation=45)
plt.grid()
plt.tight_layout()
plt.savefig("branch_prediction_accuracy.png", dpi=500)
plt.show()




