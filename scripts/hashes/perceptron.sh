#!/bin/bash


# Read the Perceptron.bsv file and extract the required values
PRED="perceptron"
UPPER="Perceptron"
# HASHES=("Truncate" "Fold" "Mod" "FoldDrop" "FoldMod" "HybridMod" "HybridMod1" "HybridMod2" "HybridMod3")
HASHES=("Fold" "Mod" "FoldDrop" "FoldMod" "HybridMod" "HybridMod1" "HybridMod2" "HybridMod3")


PRED_FILE="branch/bsv/$PRED/$UPPER.bsv"
FILE_NAME="../$UPPER.bsv"

# 10^7 approx 8hrs for all hash functions?
# 10^6 approx 1.5hrs for all?
BASE_COMMAND="./bin/champsim --warmup_instructions 10000000 --simulation_instructions 10000000"
TRACEDIR="traces/"
# TRACE="401.bzip2-277B.champsimtrace.xz"
TRACE="403.gcc-17B.champsimtrace.xz"

# New test rig gcc:
LOCAL=(2 2 2 5 5 10 10 11 12 14 15 18)
GLOBAL=(8 10 23 25 31 34 34 36 51 71 115 155)
COUNT=(11 19 19 33 55 91 182 341 500 750 1000 1500)

if [[ -f "$PRED_FILE" ]]; then
    for HASH in "${HASHES[@]}"
    do
        # Change into build directory
        cd "$(dirname "$PRED_FILE")/Build" || exit 1
            
        # Choose hash function
        # sed -i 's/\$display("%d:%d", pc_reg, getIndex\w*(pc_reg));/\$display("%d:%d", pc_reg, getIndex'"${FUN}(pc_reg));/" "$FILE_NAME"
        sed -i 's/\HashFunction#(PerceptronsRegIndex) hash <- \w*;/\HashFunction#(PerceptronsRegIndex) hash <- '"mk${HASH}"';/' "$FILE_NAME"

        echo "Hash: ${HASH}"

        echo "Changing to top"
        cd "-" || exit 1

        # Run on range of hardware setups
        for i in {0..11}; do
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

            echo "Running: $BASE_COMMAND $TRACE > results/hashesNew/${HASH}/$OUTPUT_FILE"
            $BASE_COMMAND ${TRACEDIR}${TRACE} > "results/hashesNew/${HASH}/$OUTPUT_FILE"
        done
    done
else
    echo "Error: $PRED_FILE not found."
    exit 1
fi

