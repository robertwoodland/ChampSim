#!/bin/bash


# Read the Perceptron.bsv file and extract the required values
PRED="perceptron"
UPPER="Perceptron"
PRED_FILE="branch/bsv/$PRED/$UPPER.bsv"
FILE_NAME="../$UPPER.bsv"

# 10^6 = 30s per trace
# 10^7 - 3 hours for 36 = 5 mins per trace
BASE_COMMAND="./bin/champsim --warmup_instructions 10000000 --simulation_instructions 10000000"
TRACEDIR="traces/"
TRACE="454.calculix-104B.champsimtrace.xz"


LOCAL=(2 2 2 5 5 10 10 11 12 13 15 16)
GLOBAL=(8 10 23 25 31 34 34 36 40 50 60 80)
COUNT=(11 19 19 33 64 91 182 341 680 1360 2720 5440)
WEIGHTS=(1 2 4 6 8 10 12 14 16)

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

        for i in {0..11}; do
            SIZE=$(python3 ./scripts/histories/size.py $PRED ${LOCAL[i]} ${GLOBAL[i]} ${COUNT[i]} ${WEIGHT})

            # Change into build directory
            cd "$(dirname "$PRED_FILE")/Build" || exit 1
            echo "Size: ${SIZE}B, LOCAL: ${LOCAL[i]}, GLOBAL: ${GLOBAL[i]}, COUNT: ${COUNT[i]}, WIDTH:${WEIGHT}"
            OUTPUT_FILE="${SIZE}_${LOCAL[i]}_${GLOBAL[i]}_${COUNT[i]}_${WEIGHT}.txt"
            
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

            echo "Running: $BASE_COMMAND $TRACE > results/width/$OUTPUT_FILE"
            $BASE_COMMAND ${TRACEDIR}${TRACE} > "results/width/$OUTPUT_FILE"
        done
    done
else
    echo "Error: $PRED_FILE not found."
    exit 1
fi
