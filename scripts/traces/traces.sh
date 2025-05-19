#!/bin/bash

TESTPRED_FILE="branch/testpred/testpred.cc"
SCRIPT="branch/testpred/script.sh"

if [[ -f "$TESTPRED_FILE" ]]; then
    sed -i "s|Bluesim::sim\s\+load\s\+/home/redacted/cam/part2/project/ChampSim/branch/bsv/[^ ]*|Bluesim::sim load /home/redacted/cam/part2/project/ChampSim/branch/bsv/perceptron/Build/mkTestbench_bsim.so|" "$SCRIPT"
    ./scripts/traces/perceptron.sh
    echo "Changing"
    sed -i "s|Bluesim::sim\s\+load\s\+/home/redacted/cam/part2/project/ChampSim/branch/bsv/[^ ]*|Bluesim::sim load /home/redacted/cam/part2/project/ChampSim/branch/bsv/bht/Build/mkTestbench_bsim.so|" "$SCRIPT"
    ./scripts/traces/bht.sh
    sed -i "s|Bluesim::sim\s\+load\s\+/home/redacted/cam/part2/project/ChampSim/branch/bsv/[^ ]*|Bluesim::sim load /home/redacted/cam/part2/project/ChampSim/branch/bsv/tour/Build/mkTestbench_bsim.so|" "$SCRIPT"
    ./scripts/traces/tour.sh
    sed -i "s|Bluesim::sim\s\+load\s\+/home/redacted/cam/part2/project/ChampSim/branch/bsv/[^ ]*|Bluesim::sim load /home/redacted/cam/part2/project/ChampSim/branch/bsv/perceptron/Build/mkTestbench_bsim.so|" "$SCRIPT"
else
    echo "Error: $TESTPRED_FILE not found."
    exit 1
fi