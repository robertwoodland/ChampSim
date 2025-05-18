#!/bin/bash


# Read the Perceptron.bsv file and extract the required values
PRED="perceptron"
UPPER="Perceptron"
PRED_FILE="branch/bsv/$PRED/$UPPER.bsv"
FILE_NAME="../$UPPER.bsv"

# 10^7 = 300s per trace
BASE_COMMAND="./bin/champsim --warmup_instructions 10000000 --simulation_instructions 10000000"
# TRACE="401.bzip2-277B.champsimtrace.xz"
TRACE="403.gcc-17B.champsimtrace.xz"


LOCAL=(11 11 11 11 11 11 11 11 11 11 11)
GLOBAL=(1 10 22 36 80 174 360)
COUNT=(341 341 341 341 341 341 341 341 341 341 341 341)
# Fix all but Global, starting at budget of 16KB = (11 36 341)
# Double / halve each time



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

        echo "Running: $BASE_COMMAND $TRACE > results/budget/global/$OUTPUT_FILE"
        $BASE_COMMAND ${TRACEDIR}${TRACE} > "results/budget/global/$OUTPUT_FILE"
    done
else
    echo "Error: $PRED_FILE not found."
    exit 1
fi
