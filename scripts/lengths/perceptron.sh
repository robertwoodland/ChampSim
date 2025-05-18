#!/bin/bash

# Read the Perceptron.bsv file and extract the required values
PRED="perceptron"
UPPER="Perceptron"
PRED_FILE="branch/bsv/$PRED/$UPPER.bsv"
FILE_NAME="../$UPPER.bsv"

# New test rig gcc:
LOCAL=(2 2 2 5 5 10 10 11 12 14 15 18)
GLOBAL=(8 10 23 25 31 34 34 36 51 71 115 155)
COUNT=(11 19 19 33 55 91 182 341 500 750 1000 1500)


# Define the base command
# 10^7 warmup
BASE_COMMAND="./bin/champsim --warmup_instructions 10000000"
TRACEDIR="traces/"
TRACE="403.gcc-17B.champsimtrace.xz"

if [[ -f "$PRED_FILE" ]]; then
    # Loop through factors of 10 for simulation instructions
    # for ((j=100; j<=10**7; j*=10)); do
        j=100000000
        echo "Running: $BASE_COMMAND --simulation_instructions $j $TRACE"


        for i in {9..9}; do
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

            echo "Running: $BASE_COMMAND --simulation_instructions $j $TRACE > results/lengths/perceptron/${j}.txt"

            $BASE_COMMAND "--simulation_instructions" $j ${TRACEDIR}${TRACE} > "results/lengths/perceptron/${j}.txt"
        done
    # done
else
    echo "Error: $PRED_FILE not found."
    exit 1
fi
