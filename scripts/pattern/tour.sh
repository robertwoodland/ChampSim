#!/bin/bash

# Define the base command
COMMAND="./build/test_main --gtest_filter=PerceptronTests.PredPatternTest*"
PRED_FILE="branch/bsv/tour/TourPred.bsv"
FILE_NAME="../TourPred.bsv"


LOCAL=(4 6 7 9 10 11 12 13 14 15 16 17)
GLOBAL=(4 6 7 8 9 11 12 13 14 15 16 17)
PC=(4 5 6 6 7 7 8 9 10 11 12 13)




# Run on range of hardware setups
for i in {0..11}; do
    SIZE=$(python3 ./scripts/histories/size.py tour ${LOCAL[i]} ${GLOBAL[i]} ${PC[i]})

    # Change into build directory
    cd "$(dirname "$PRED_FILE")/Build" || exit 1
    echo "Size: ${SIZE}B, Local: ${LOCAL[i]}, Global: ${GLOBAL[i]}, PC: ${PC[i]}"
    OUTPUT_FILE="${SIZE}_${LOCAL[i]}_${GLOBAL[i]}_${PC[i]}.txt"
    # Modify params
    sed -i "s/typedef\s\+\w\+\s\+TourLocalHistSz;/typedef ${LOCAL[i]} TourLocalHistSz;/" "$FILE_NAME"
    sed -i "s/typedef\s\+\w\+\s\+TourGlobalHistSz;/typedef ${GLOBAL[i]} TourGlobalHistSz;/" "$FILE_NAME"
    sed -i "s/typedef\s\+\w\+\s\+PCIndexSz;/typedef ${PC[i]} PCIndexSz;/" "$FILE_NAME"

    echo "Making tour"
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
    $COMMAND > "results/pattern/tour/${OUTPUT_FILE}"
done
