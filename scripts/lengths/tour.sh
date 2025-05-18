#!/bin/bash

# Read the TourPred.bsv file and extract the required values
PRED="tour"
UPPER="TourPred"
PRED_FILE="branch/bsv/$PRED/$UPPER.bsv"
FILE_NAME="../$UPPER.bsv"

# Define the base command
BASE_COMMAND="./bin/champsim --warmup_instructions 10000000"
TRACEDIR="traces/"
TRACE="403.gcc-17B.champsimtrace.xz"

LOCAL=(4 6 7 9 10 11 12 13 14 15 16 17)
GLOBAL=(4 6 7 8 9 11 12 13 14 15 16 17)
PC=(4 5 6 6 7 7 8 9 10 11 12 13)


if [[ -f "$PRED_FILE" ]]; then
    # Loop through factors of 10 for simulation instructions
    # for ((j=100; j<=10**7; j*=10)); do
    j=100000000
    echo "Running: $BASE_COMMAND --simulation_instructions $j $TRACE"
    for i in {9..9}; do
        SIZE=$(python3 ./scripts/histories/size.py $PRED ${LOCAL[i]} ${GLOBAL[i]} ${PC[i]})

        # Change into build directory
        cd "$(dirname "$PRED_FILE")/Build" || exit 1
        echo "Size: ${SIZE}B, Local: ${LOCAL[i]}, Global: ${GLOBAL[i]}, PC: ${PC[i]}"
        OUTPUT_FILE="${SIZE}_${LOCAL[i]}_${GLOBAL[i]}_${PC[i]}.txt"
        # Modify params
        sed -i "s/typedef\s\+\w\+\s\+TourLocalHistSz;/typedef ${LOCAL[i]} TourLocalHistSz;/" "$FILE_NAME"
        sed -i "s/typedef\s\+\w\+\s\+TourGlobalHistSz;/typedef ${GLOBAL[i]} TourGlobalHistSz;/" "$FILE_NAME"
        sed -i "s/typedef\s\+\w\+\s\+PCIndexSz;/typedef ${PC[i]} PCIndexSz;/" "$FILE_NAME"

        echo "Making $PRED"
        make all_bsim

        echo "Changing to top"
        # Change back to top
        cd "-" || exit 1
        echo "Removing old champsim"
        rm "./bin/champsim"
        echo "Making champsim"
        make

        echo "Running: $BASE_COMMAND --simulation_instructions $j $TRACE > results/lengths/tour/${j}.txt"
    $BASE_COMMAND "--simulation_instructions" $j ${TRACEDIR}${TRACE} > "results/lengths/tour/${j}.txt"
    done
    # done
else
    echo "Error: $PRED_FILE not found."
    exit 1
fi