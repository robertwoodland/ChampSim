#!/bin/bash

# Define the base command
COMMAND="./build/test_main --gtest_filter=PerceptronTests.PredPatternTest*"
PRED_FILE="branch/bsv/bht/Bht.bsv"
FILE_NAME="../Bht.bsv"

# ENTRIES=(512 1024 2048 4096 8192 16384 32768 65536)
ENTRIES=(512 1024 2048 4096 8192 16384 32768 65536 131072 262144 524288 1048576)



# Run on range of hardware setups
for i in {0..11}; do
    SIZE=$(python3 ./scripts/histories/size.py bht ${ENTRIES[i]})


    # Change into build directory
    cd "$(dirname "$PRED_FILE")/Build" || exit 1
    echo "Size: ${SIZE}B, Entries: ${ENTRIES[i]}"
    OUTPUT_FILE="${SIZE}_${ENTRIES[i]}.txt"

    # Modify params
    sed -i "s/typedef\s\+\w\+\s\+BhtEntries;/typedef ${ENTRIES[i]} BhtEntries;/" "$FILE_NAME"

    echo "Making bht"
    make all_bsim

    echo "Changing to top"
    # Change back to top
    cd "-" || exit 1

    # Change to test dir
    cd "./build/"
    # CMAKE
    cmake ".."
    # Make
    make
    # Change back to top
    cd "-" || exit 1

    echo "Running: $COMMAND"
    $COMMAND > "results/pattern/bht/${OUTPUT_FILE}"
done
