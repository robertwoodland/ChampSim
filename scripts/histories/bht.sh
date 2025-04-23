#!/bin/bash


# Read the Perceptron.bsv file and extract the required values
PRED="bht"
UPPER="Bht"
PRED_FILE="branch/bsv/$PRED/$UPPER.bsv"
FILE_NAME="../$UPPER.bsv"

BASE_COMMAND="./bin/champsim --warmup_instructions 10000000 --simulation_instructions 10000000"
TRACE="454.calculix-104B.champsimtrace.xz"


ENTRIES=(512 1024 2048 4096 8192 16384 32768 65536)

if [[ -f "$PRED_FILE" ]]; then
    for i in {0..7}; do
        # Change into build directory
        cd "$(dirname "$PRED_FILE")/Build" || exit 1
        echo "ENTRIES: ${ENTRIES[i]}"
        OUTPUT_FILE="${ENTRIES[i]}.txt"
        
        # Modify params
        sed -i "s/typedef\s\+\w\+\s\+BhtEntries;/typedef ${ENTRIES[i]} BhtEntries;/" "$FILE_NAME"

        echo "Making $PRED"
        make all_bsim

        echo "Changing to top"
        # Change back to top
        cd "-" || exit 1
        
        echo "Removing old champsim"
        rm "./bin/champsim"
        
        echo "Making champsim"
        make

        echo "Running: $BASE_COMMAND $TRACE > results/histories/$PRED/$OUTPUT_FILE"
        $BASE_COMMAND $TRACE > "results/histories/$PRED/$OUTPUT_FILE"
    done
else
    echo "Error: $PRED_FILE not found."
    exit 1
fi
