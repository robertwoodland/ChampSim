#!/bin/bash


# Read the Perceptron.bsv file and extract the required values
PRED="perceptron"
UPPER="Perceptron"
PRED_FILE="branch/bsv/$PRED/$UPPER.bsv"
FILE_NAME="../$UPPER.bsv"

# 10^7 = 300s per trace
BASE_COMMAND="./bin/champsim --warmup_instructions 10000000 --simulation_instructions 10000000"
TRACEDIR="traces/"
TRACE="403.gcc-17B.champsimtrace.xz"

# New test rig gcc:
LOCAL=14
GLOBAL=71
COUNT=750

# Thresholds
# THRESHOLDS=(1.89 1.9 1.91 1.92 1.93 1.94 1.95 1.96 1.97)
# THRESHOLDS=(1.5 1.6 1.7 1.8 1.93 2.0 2.1 2.2 2.3)
# THRESHOLDS=(0.125 0.25 0.5 1 4 8 16)
THRESHOLD=1.93
CONSTS=(2 3 7 14 28 56 112)


if [[ -f "$PRED_FILE" ]]; then

        # for i in {0..8}; do
        for i in {1..6}; do
            # Change into build directory
            cd "$(dirname "$PRED_FILE")/Build" || exit 1
            echo "Const: ${CONSTS[i]}"
            OUTPUT_FILE="1.93_${CONSTS[i]}.txt"
            
            # Modify param
            sed -i "s/(fromInteger(valueOf(PerceptronEntries)))) + [^ ]*)))/(fromInteger(valueOf(PerceptronEntries)))) + ${CONSTS[i]})))/" "$FILE_NAME"


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
            $BASE_COMMAND ${TRACEDIR}${TRACE} > "results/threshold/$OUTPUT_FILE"
        done
else
    echo "Error: $PRED_FILE not found."
    exit 1
fi
