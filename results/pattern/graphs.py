#!/usr/bin/env python
# coding: utf-8

import os
import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
import math


n=""
paths = os.listdir('./perceptron/')
paths.sort(key=lambda p: tuple(map(int, p[:-4].split('_'))) if p.endswith('.txt') else (float('inf'),))
for name in paths:
    if os.path.isfile("./perceptron/" + name):
        if name[-4:] == ".txt":
            res = pd.read_csv("./perceptron/" + name, delimiter = "\\", on_bad_lines='skip')
            result = ""
            count = 0
            for line in res.iloc[:, 0]:
                # Get n
                if line.startswith("[ RUN      ]"):
                    if n != line.split(" ")[8][-1:]:
                        count += 1
                    n = line.split(" ")[8][31:]

maxCount = count


results = []
for i in range(0, maxCount):
    results.append([])

paths = os.listdir('./perceptron/')
paths.sort(key=lambda p: tuple(map(int, p[:-4].split('_'))) if p.endswith('.txt') else (float('inf'),))
# paths.sort()
for name in paths:
    if os.path.isfile("./perceptron/" + name):
        if name[-4:] == ".txt":
            res = pd.read_csv("./perceptron/" + name, delimiter = "\\", on_bad_lines='skip')
            result = ""
            count = 0
            for line in res.iloc[:, 0]:
                # Get n
                if line.startswith("[ RUN      ]"):
                    if n != line.split(" ")[8][-1:]:
                        n = line.split(" ")[8][31:]
                if line.startswith("Total mispredictions:"):
                    result = line.split(" ")[2]
                if line.startswith("[  FAILED  ]"):
                    results[count-1].pop()
                    results[count-1].append((n + "_" + name[:-4], "100"))
                if result != "":
                    # results[count].append((name[:-4], result))
                    results[count].append((n + "_" + name[:-4], result))
                    count += 1
                    result = ""


# Plot graph!
plt.figure(figsize=(10, 6))
plt.title("Perceptron Mispredictions Taken To Learn Pattern")
plt.xlabel("Predictor Size (Bytes)")
plt.ylabel("Misprediction Count")

for i in range(0, len(results)):
    x = []
    y = []
    n = results[i]
    for result in n:
        # x.append(result[0].split("_")[0])
        x.append(2**round(math.log2(int(result[0].split("_")[1]))))
        if (int(result[1]) == 100):
            y.append(np.nan)
        else:
            y.append(int(result[1]))
    label = "Perceptron n=" + n[0][0].split("_")[0]
    plt.plot(range(len(x)), y, marker='o', linestyle='-', label=label)
        


plt.xticks(range(len(x)), x)

# Add a legend
plt.legend(loc='upper left')

# plt.xticks(x, rotation=45)
plt.grid()
plt.tight_layout()
plt.savefig("branch_prediction_accuracy.png")
plt.show()


results = []
for i in range(0, maxCount):
    results.append([])

paths = os.listdir('./tour/')
paths.sort(key=lambda p: tuple(map(int, p[:-4].split('_'))) if p.endswith('.txt') else (float('inf'),))
# paths.sort()
for name in paths:
    if os.path.isfile("./tour/" + name):
        if name[-4:] == ".txt":
            res = pd.read_csv("./tour/" + name, delimiter = "\\", on_bad_lines='skip')
            result = ""
            count = 0
            for line in res.iloc[:, 0]:
                # Get n
                if line.startswith("[ RUN      ]"):
                    if n != line.split(" ")[8][-1:]:
                        n = line.split(" ")[8][31:]
                if line.startswith("Total mispredictions:"):
                    result = line.split(" ")[2]
                if line.startswith("[  FAILED  ]"):
                    results[count-1].pop()
                    results[count-1].append((n + "_" + name[:-4], "100"))
                if result != "":
                    # results[count].append((name[:-4], result))
                    results[count].append((n + "_" + name[:-4], result))
                    count += 1
                    result = ""


# Plot graph!
plt.figure(figsize=(10, 6))
plt.title("Tournament Mispredictions Taken To Learn Pattern")
plt.xlabel("Predictor Size (Bytes)")
plt.ylabel("Misprediction Count")


for i in range(0, len(results)):
    x = []
    y = []
    n = results[i]
    for result in n:
        # x.append(result[0].split("_")[0])
        x.append(2**round(math.log2(int(result[0].split("_")[1]))))
        if (int(result[1]) == 100):
            y.append(np.nan)
        else:
            y.append(int(result[1]))
    label = "Tournament n=" + n[0][0].split("_")[0]
    plt.plot(range(len(x)), y, marker='o', linestyle='-', label=label)
        


plt.xticks(range(len(x)), x)

# Add a legend
plt.legend(loc='upper left')

# plt.xticks(x, rotation=45)
plt.grid()
plt.tight_layout()
plt.savefig("branch_prediction_accuracy.png")
plt.show()


results = []
for i in range(0, maxCount):
    results.append([])

paths = os.listdir('./bht/')
paths.sort(key=lambda p: tuple(map(int, p[:-4].split('_'))) if p.endswith('.txt') else (float('inf'),))
# paths.sort()
for name in paths:
    if os.path.isfile("./bht/" + name):
        if name[-4:] == ".txt":
            res = pd.read_csv("./bht/" + name, delimiter = "\\", on_bad_lines='skip')
            result = ""
            count = 0
            for line in res.iloc[:, 0]:
                # Get n
                if line.startswith("[ RUN      ]"):
                    if n != line.split(" ")[8][-1:]:
                        n = line.split(" ")[8][31:]
                if line.startswith("Total mispredictions:"):
                    result = line.split(" ")[2]
                if line.startswith("[  FAILED  ]"):
                    results[count-1].pop()
                    results[count-1].append((n + "_" + name[:-4], "100"))
                if result != "":
                    # results[count].append((name[:-4], result))
                    results[count].append((n + "_" + name[:-4], result))
                    count += 1
                    result = ""


# Plot graph!
plt.figure(figsize=(10, 6))
plt.title("Perceptron Branch Prediction Accuracy on $10^7$ Instructions")
plt.xlabel("Predictor Size (Bytes)")
plt.ylabel("No. Mispredictions to learn")

for i in range(0, len(results)):
    x = []
    y = []
    n = results[i]
    for result in n:
        # x.append(result[0].split("_")[0])
        x.append(2**round(math.log2(int(result[0].split("_")[1]))))
        if (int(result[1]) == 100):
            y.append("FAIL")
        else:
            y.append(int(result[1]))
    label = "BHT n=" + n[0][0].split("_")[0]
    plt.plot(range(len(x)), y, marker='o', linestyle='-', label=label)
        


plt.xticks(range(len(x)), x)

# Add a legend
plt.legend(loc='upper left')

# plt.xticks(x, rotation=45)
plt.grid()
plt.tight_layout()
plt.savefig("branch_prediction_accuracy.png")
plt.show()




