#!/bin/bash

# Set predictor

TESTPRED_FILE="branch/testpred/testpred.cc"
SCRIPT="branch/testpred/script.sh"



if [[ -f "$TESTPRED_FILE" ]]; then
    # Ensure test_mode
    sed -i "s|//\s\+#define\s\+TEST_MODE|#define TEST_MODE|" "$TESTPRED_FILE"

    # make
    

    # # Set script to point to predictor
    sed -i "s|Bluesim::sim\s\+load\s\+/home/robert/cam/part2/project/ChampSim/branch/bsv/[^ ]*|Bluesim::sim load /home/robert/cam/part2/project/ChampSim/branch/bsv/perceptron/Build/mkTestbench_bsim.so|" "$SCRIPT"
    ./scripts/pattern/perceptron.sh
    
    # # BHT
    sed -i "s|Bluesim::sim\s\+load\s\+/home/robert/cam/part2/project/ChampSim/branch/bsv/[^ ]*|Bluesim::sim load /home/robert/cam/part2/project/ChampSim/branch/bsv/bht/Build/mkTestbench_bsim.so|" "$SCRIPT"
    ./scripts/pattern/bht.sh
    
    # # Tour
    sed -i "s|Bluesim::sim\s\+load\s\+/home/robert/cam/part2/project/ChampSim/branch/bsv/[^ ]*|Bluesim::sim load /home/robert/cam/part2/project/ChampSim/branch/bsv/tour/Build/mkTestbench_bsim.so|" "$SCRIPT"
    ./scripts/pattern/tour.sh
fi
# run

# Repeat!
