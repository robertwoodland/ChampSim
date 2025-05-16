#!/bin/bash


# Read the Perceptron.bsv file and extract the required values
PRED="tour"
UPPER="TourPred"
PRED_FILE="branch/bsv/$PRED/$UPPER.bsv"
FILE_NAME="../$UPPER.bsv"

# 10^6 - 30s per trace
BASE_COMMAND="./bin/champsim --warmup_instructions 1000000 --simulation_instructions 1000000"
TRACES=("454.calculix-104B.champsimtrace.xz" "400.perlbench-50B.champsimtrace.xz" "401.bzip2-277B.champsimtrace.xz" "403.gcc-17B.champsimtrace.xz" "429.mcf-217B.champsimtrace.xz")
NUMS=(454 400 401 403 429)



# LOCAL=(8 8 9 9 9 12 13 13 16 18 22 26)
# GLOBAL=(6 9 10 10 12 12 12 14 16 18 22 26)
# PC=(4 5 5 8 9 10 11 12 13 14 15 16)
LOCAL=(4 6 7 9 10 11 12 13 14 15 16 17)
GLOBAL=(4 6 7 8 9 11 12 13 14 15 16 17)
PC=(4 5 6 6 7 7 8 9 10 11 12 13)



if [[ -f "$PRED_FILE" ]]; then
    for i in {0..4}; 
    do
        TRACE=${TRACES[${i}]}
        NUM=${NUMS[${i}]}
        echo "Running trace: $TRACE, NUM: $NUM"

        for i in {0..11}; do
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

            echo "Running: $BASE_COMMAND $TRACE > results/traces/$PRED/$NUM/$OUTPUT_FILE"
            $BASE_COMMAND $TRACE > "results/traces/$PRED/$NUM/$OUTPUT_FILE"
        done
    done
else
    echo "Error: $PRED_FILE not found."
    exit 1
fi
