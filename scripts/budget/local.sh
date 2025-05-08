#!/bin/bash


# Read the Perceptron.bsv file and extract the required values
PRED="perceptron"
UPPER="Perceptron"
PRED_FILE="branch/bsv/$PRED/$UPPER.bsv"
FILE_NAME="../$UPPER.bsv"

# 10^7 = 300s per trace
BASE_COMMAND="./bin/champsim --warmup_instructions 10000000 --simulation_instructions 10000000"
TRACE="454.calculix-104B.champsimtrace.xz"


# Overall:
# LOCAL=(2 2 2 5 5 10 10 11 12 13 15 16)
# GLOBAL=(8 10 23 25 31 34 34 36 40 50 60 80)
# COUNT=(11 19 19 33 64 91 182 341 680 1360 2720 5440)
# # Change to 5, 31, 64 to showcase power of two

# Default yields:
# CPU 0 cumulative IPC: 3.979 instructions: 1000001 cycles: 251297
# CPU 0 Branch Prediction Accuracy: 99.49% MPKI: 0.462 Average ROB Occupancy at Mispredict: 351.8

# Conditional Branch Prediction Accuracy %0.463

# Count of 12 yields:
# CPU 0 cumulative IPC: 3.953 instructions: 1000001 cycles: 252954
# CPU 0 Branch Prediction Accuracy: 99.41% MPKI: 0.528 Average ROB Occupancy at Mispredict: 341.1

# Conditional Branch Prediction Accuracy %0.55
# Ie slightly worse

# Budget tests:
LOCAL=(1 3 6 11 50 134 280)
GLOBAL=(36 36 36 36 36 36 36)
COUNT=(341 341 341 341 341 341 341 341 341 341 341 341)
# Fix all but Local, starting at budget of 16KB = (11 36 341)
# Double / halve each time

# LOCAL=(11 11 11 11 11 11 11 11 11 11 11)
# GLOBAL=(5 9 18 36 72 144 288)
# COUNT=(341 341 341 341 341 341 341 341 341 341 341 341)
# # Fix all but Global, starting at budget of 16KB = (11 36 341)
# # Double / halve each time

# LOCAL=(11 11 11 11 11 11 11 11 11 11 11)
# GLOBAL=(36 36 36 36 36 36 36 36 36 36 36)
# COUNT=(43 85 171 341 642 1284 2568)
# # Fix all but counts, starting at budget of 16KB = (11 36 341)
# # Double / halve each time



if [[ -f "$PRED_FILE" ]]; then
    for i in {0..6}; do
        SIZE=$(python3 ./scripts/histories/size.py $PRED ${LOCAL[i]} ${GLOBAL[i]} ${COUNT[i]})

        # Change into build directory
        cd "$(dirname "$PRED_FILE")/Build" || exit 1
        echo "Size: ${SIZE}B, LOCAL: ${LOCAL[i]}, GLOBAL: ${GLOBAL[i]}, COUNT: ${COUNT[i]}"
        OUTPUT_FILE="${SIZE}_${LOCAL[i]}_${GLOBAL[i]}_${COUNT[i]}.txt"
        
        # Modify params
        sed -i "s/typedef\s\+\w\+\s\+PerceptronEntries;/typedef ${LOCAL[i]} PerceptronEntries;/" "$FILE_NAME"
        sed -i "s/typedef\s\+\w\+\s\+PerceptronGHistEntries;/typedef ${GLOBAL[i]} PerceptronGHistEntries;/" "$FILE_NAME"
        sed -i "s/typedef\s\+\w\+\s\+PerceptronCount;/typedef ${COUNT[i]} PerceptronCount;/" "$FILE_NAME"

        echo "Making $PRED"
        make all_bsim

        echo "Changing to top"
        # Change back to top
        cd "-" || exit 1
        
        echo "Removing old champsim"
        rm "./bin/champsim"
        
        echo "Making champsim"
        make

        echo "Running: $BASE_COMMAND $TRACE > results/budget/local/$OUTPUT_FILE"
        $BASE_COMMAND $TRACE > "results/budget/local/$OUTPUT_FILE"
    done
else
    echo "Error: $PRED_FILE not found."
    exit 1
fi
