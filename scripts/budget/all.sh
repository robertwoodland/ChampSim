#!/bin/bash

TESTPRED_FILE="branch/testpred/testpred.cc"
SCRIPT="branch/testpred/script.sh"

if [[ -f "$TESTPRED_FILE" ]]; then
    # Set script to point to perceptron
    sed -i "s|Bluesim::sim\s\+load\s\+/home/robert/cam/part2/project/ChampSim/branch/bsv/[^ ]*|Bluesim::sim load /home/robert/cam/part2/project/ChampSim/branch/bsv/perceptron/Build/mkTestbench_bsim.so|" "$SCRIPT"

    ./scripts/budget/local.sh
    ./scripts/budget/global.sh
    ./scripts/budget/count.sh
    ./scripts/budget/width.sh
else
    echo "Error: $TESTPRED_FILE not found."
    exit 1
fi