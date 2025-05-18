#!/bin/bash


# Read the Perceptron.bsv file and extract the required values
PRED="perceptron"
UPPER="Perceptron"
PRED_FILE="branch/bsv/$PRED/$UPPER.bsv"
FILE_NAME="../$UPPER.bsv"

# 10^7 = 300s per trace
BASE_COMMAND="./bin/champsim --warmup_instructions 10000000 --simulation_instructions 10000000"
TRACE="403.gcc-17B.champsimtrace.xz"

# New test rig gcc:
LOCAL=14
GLOBAL=71
COUNT=750

# Thresholds
# THRESHOLDS=(1.89 1.9 1.91 1.92 1.93 1.94 1.95 1.96 1.97)
# THRESHOLDS=(1.5 1.6 1.7 1.8 1.93 2.0 2.1 2.2 2.3)
THRESHOLDS=(0.125 0.25 0.5 1 4 8 16)


if [[ -f "$PRED_FILE" ]]; then

        # for i in {0..8}; do
        for i in {0..6}; do
            # Change into build directory
            cd "$(dirname "$PRED_FILE")/Build" || exit 1
            echo "Threshold: ${THRESHOLDS[i]}"
            OUTPUT_FILE="${THRESHOLDS[i]}_14.txt"
            
            # Modify param
            # Bool forceTrain = (abs(sum) < fromInteger(trunc((1.93 * (fromInteger(valueOf(PerceptronEntries)))) + 14)));
            # Bool forceTrain = (abs(sum) < fromInteger(trunc((1.93 * (fromInteger(valueOf(PerceptronEntries)))) + 14)));
            sed -i "s/fromInteger(trunc((\w\+\.[0-9]\{2,\} \*/fromInteger(trunc((${THRESHOLDS[i]} */" "$FILE_NAME"
            sed -i "s/fromInteger(trunc(([^ ]* \*/fromInteger(trunc((${THRESHOLDS[i]} */" "$FILE_NAME"
            echo "Making $PRED"
            make all_bsim

            echo "Changing to top"
            # Change back to top
            cd "-" || exit 1
            
            echo "Removing old champsim"
            rm "./bin/champsim"
            
            echo "Making champsim"
            make

            echo "Running: $BASE_COMMAND $TRACE > results/threshold/$OUTPUT_FILE"
            $BASE_COMMAND $TRACE > "results/threshold/$OUTPUT_FILE"
        done
else
    echo "Error: $PRED_FILE not found."
    exit 1
fi
