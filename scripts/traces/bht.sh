#!/bin/bash


# Read the Perceptron.bsv file and extract the required values
PRED="bht"
UPPER="Bht"
PRED_FILE="branch/bsv/$PRED/$UPPER.bsv"
FILE_NAME="../$UPPER.bsv"

# 10^6 = 30s per trace
BASE_COMMAND="./bin/champsim --warmup_instructions 10000000 --simulation_instructions 10000000"
TRACEDIR="traces/"
TRACES=("454.calculix-104B.champsimtrace.xz" "400.perlbench-50B.champsimtrace.xz" "401.bzip2-277B.champsimtrace.xz" "403.gcc-17B.champsimtrace.xz" "429.mcf-217B.champsimtrace.xz")
NUMS=(454 400 401 403 429)



# ENTRIES=(512 1024 2048 4096 8192 16384 32768 65536)
ENTRIES=(512 1024 2048 4096 8192 16384 32768 65536 131072 262144 524288 1048576)

if [[ -f "$PRED_FILE" ]]; then
    for i in {0..4}; 
    do
        TRACE=${TRACES[${i}]}
        NUM=${NUMS[${i}]}
        echo "Running trace: $TRACE, NUM: $NUM"

        for i in {0..11}; do
            SIZE=$(python3 ./scripts/histories/size.py $PRED ${ENTRIES[i]})


            # Change into build directory
            cd "$(dirname "$PRED_FILE")/Build" || exit 1
            echo "Size: ${SIZE}B, Entries: ${ENTRIES[i]}"
            OUTPUT_FILE="${SIZE}_${ENTRIES[i]}.txt"

            
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

            echo "Running: $BASE_COMMAND $TRACE > results/traces/$PRED/$NUM/$OUTPUT_FILE"
            $BASE_COMMAND ${TRACEDIR}${TRACE} > "results/traces/$PRED/$NUM/$OUTPUT_FILE"
        done
    done
else
    echo "Error: $PRED_FILE not found."
    exit 1
fi
