#!/bin/bash

# Read the hash.bsv file and extract the required values

# HASH=("Truncate" "Mix" "Mod" "Hybrid" "MSB", "HybridDrop", "HybridMod", "HybridMod2")
HASH=("HybridMod2" "HybridMod3")
FILE_NAME="./test/bsv/hash.bsv"
BUILD_COMMAND="bsc -u -sim -elab -keep-fires -aggressive-conditions -no-warn-action-shadowing"
LINK_COMMAND="bsc -e mkHashTestBench -sim -o hash_bsim"
BASE_COMMAND="./test/bsv/hash_bsim -V"
FUNCTION_CALL="getIndex"


# 2^18. Set according to timings!
MAX=262144
# COUNTS=(11 16 19 33 55 91 182 341)
COUNTS=(55)


if [[ -f "$FILE_NAME" ]]; then
    # Set max val to iterate up to
    sed -i 's/if (pc_reg < [0-9]\+)/if (pc_reg < '"${MAX}"')/' "$FILE_NAME"
    for COUNT in "${COUNTS[@]}"
    do
        # Set perceptron count
        sed -i "s/typedef\s\+\w\+\s\+PerceptronCount;/typedef ${COUNT} PerceptronCount;/" "$FILE_NAME"
        for FUN in "${HASH[@]}"
        do
            # Choose hash function
            sed -i 's/\$display("%d:%d", pc_reg, getIndex\w*(pc_reg));/\$display("%d:%d", pc_reg, getIndex'"${FUN}(pc_reg));/" "$FILE_NAME"

            echo "Perceptrons: ${COUNT}, Hash: ${FUN}"

            OUTPUT_FILE="${COUNT}/${FUN}.txt"
            
            echo "Making $FUN"
            $BUILD_COMMAND "$FILE_NAME"

            # Change into build directory
            cd "$(dirname "$FILE_NAME")/" || exit 1
            $LINK_COMMAND
            # Change back to top
            cd "-" || exit 1

            echo "Running: $BASE_COMMAND > "test/bsv/results/$OUTPUT_FILE""
            $BASE_COMMAND > "test/bsv/results/$OUTPUT_FILE"
        done
    done
else
    echo "Error: $PRED_FILE not found."
    exit 1
fi
