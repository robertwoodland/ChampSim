#!/bin/bash


# Read the Perceptron.bsv file and extract the required values
PRED="tour"
UPPER="TourPred"
PRED_FILE="branch/bsv/$PRED/$UPPER.bsv"
FILE_NAME="../$UPPER.bsv"

BASE_COMMAND="./bin/champsim --warmup_instructions 10000000 --simulation_instructions 10000000"
TRACE="454.calculix-104B.champsimtrace.xz"


LOCAL=(8 8 9 9 9 12 13 13)
GLOBAL=(6 9 10 10 12 12 12 14)
PC=(4 5 5 8 9 10 11 12)

if [[ -f "$PRED_FILE" ]]; then
    for i in {0..7}; do
        # Change into build directory
        cd "$(dirname "$PRED_FILE")/Build" || exit 1
        echo "Local: ${LOCAL[i]}, Global: ${GLOBAL[i]}, PC: ${PC[i]}"
        OUTPUT_FILE="${LOCAL[i]}_${GLOBAL[i]}_${PC[i]}.txt"
        
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

        echo "Running: $BASE_COMMAND $TRACE > results/histories/$PRED/$OUTPUT_FILE"
        $BASE_COMMAND $TRACE > "results/histories/$PRED/$OUTPUT_FILE"
    done
else
    echo "Error: $PRED_FILE not found."
    exit 1
fi
