#!/bin/bash

# Define the base command
COMMAND="./build/test_main --gtest_filter=PerceptronTests.PredPatternTest*"
PRED_FILE="branch/bsv/perceptron/Perceptron.bsv"
FILE_NAME="../Perceptron.bsv"


# New test rig gcc:
LOCAL=(2 2 2 5 5 10 10 11 12 14 15 18)
GLOBAL=(8 10 23 25 31 34 34 36 51 71 115 155)
COUNT=(11 19 19 33 55 91 182 341 500 750 1000 1500)




# Run on range of hardware setups
for i in {0..11}; do
    SIZE=$(python3 ./scripts/histories/size.py perceptron ${LOCAL[i]} ${GLOBAL[i]} ${COUNT[i]})

    # Change into build directory
    cd "$(dirname "$PRED_FILE")/Build" || exit 1
    echo "Size: ${SIZE}B, LOCAL: ${LOCAL[i]}, GLOBAL: ${GLOBAL[i]}, COUNT: ${COUNT[i]}"
    OUTPUT_FILE="${SIZE}_${LOCAL[i]}_${GLOBAL[i]}_${COUNT[i]}.txt"
    # Modify params
    sed -i "s/typedef\s\+\w\+\s\+PerceptronEntries;/typedef ${LOCAL[i]} PerceptronEntries;/" "$FILE_NAME"
    sed -i "s/typedef\s\+\w\+\s\+PerceptronGHistEntries;/typedef ${GLOBAL[i]} PerceptronGHistEntries;/" "$FILE_NAME"
    sed -i "s/typedef\s\+\w\+\s\+PerceptronCount;/typedef ${COUNT[i]} PerceptronCount;/" "$FILE_NAME"

    echo "Making perceptron"
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
    $COMMAND > "results/pattern/perceptron/${OUTPUT_FILE}"
done
