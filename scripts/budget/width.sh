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


LOCAL=(11 11 11 11 11 11 11 )
GLOBAL=(36 36 36 36 36 36 36)
COUNT=(341 341 341 341 341 341 341)
# Fix all but width, starting at budget of 16KB = (11 36 341, 8)
WEIGHTS=(5 6 7 8 9 10 11)
# Vary by factors of two

if [[ -f "$PRED_FILE" ]]; then
    for WEIGHT in "${WEIGHTS[@]}"
    do
        # Change into build directory
        cd "$(dirname "$PRED_FILE")/Build" || exit 1
        
        # Modify bit width
        sed -i 's|typedef\s\+Vector#(TAdd#(PerceptronEntries, 1),\s\+Int#([^)]\+))\s\+PerceptronWeights;|typedef Vector#(TAdd#(PerceptronEntries, 1), '"Int#(${WEIGHT}"')) PerceptronWeights;|' "$FILE_NAME"
        sed -i 's/typedef\s\+Vector#(PerceptronGHistEntries,\s\+Int#([^)]\+))\s\+PerceptronGWeights;/typedef Vector#(PerceptronGHistEntries, '"Int#(${WEIGHT}"')) PerceptronGWeights;/' "$FILE_NAME"

        echo "Changing to top"
        # Change back to top
        cd "-" || exit 1

        SIZE=$(python3 ./scripts/histories/size.py $PRED ${LOCAL[0]} ${GLOBAL[0]} ${COUNT[0]} ${WEIGHT})

        # Change into build directory
        cd "$(dirname "$PRED_FILE")/Build" || exit 1
        echo "Size: ${SIZE}B, LOCAL: ${LOCAL[0]}, GLOBAL: ${GLOBAL[0]}, COUNT: ${COUNT[0]}, WIDTH:${WEIGHT}"
        OUTPUT_FILE="${SIZE}_${LOCAL[0]}_${GLOBAL[0]}_${COUNT[0]}_${WEIGHT}.txt"
        
        # Modify params
        sed -i "s/typedef\s\+\w\+\s\+PerceptronEntries;/typedef ${LOCAL[0]} PerceptronEntries;/" "$FILE_NAME"
        sed -i "s/typedef\s\+\w\+\s\+PerceptronGHistEntries;/typedef ${GLOBAL[0]} PerceptronGHistEntries;/" "$FILE_NAME"
        sed -i "s/typedef\s\+\w\+\s\+PerceptronCount;/typedef ${COUNT[0]} PerceptronCount;/" "$FILE_NAME"


        echo "Making $PRED"
        make all_bsim

        echo "Changing to top"
        # Change back to top
        cd "-" || exit 1
        
        echo "Removing old champsim"
        rm "./bin/champsim"
        
        echo "Making champsim"
        make

        echo "Running: $BASE_COMMAND $TRACE > results/budget/width/$OUTPUT_FILE"
        $BASE_COMMAND $TRACE > "results/budget/width/$OUTPUT_FILE"
    done
else
    echo "Error: $PRED_FILE not found."
    exit 1
fi
