#!/bin/bash

# Define the base command

# I CAN DO BETTER
# Read in the Perceptron.bsv file. Extract local hist length, global hist length, perceptron count. Write to file!

# Read the Perceptron.bsv file and extract the required values
PERCEPTRON_FILE="branch/bsv/perceptron/Perceptron.bsv"

if [[ -f "$PERCEPTRON_FILE" ]]; then
    LOCAL_HIST=$(grep -oP 'typedef\s+\K\d+(?=\s+PerceptronEntries)' "$PERCEPTRON_FILE")
    GLOBAL_HIST=$(grep -oP 'typedef\s+\K\w+(?=\s+PerceptronGHistEntries)' "$PERCEPTRON_FILE")

    # Deal with GLOBAL_HIST being set to PerceptronEntries
    if [[ "$GLOBAL_HIST" == "PerceptronEntries" ]]; then
        GLOBAL_HIST=$LOCAL_HIST
    elif [[ !("$GLOBAL_HIST" =~ ^[0-9]+$) ]]; then
        echo "Global History Length is a string: $GLOBAL_HIST"
    fi

    PERCEPTRON_COUNT=$(grep -oP 'typedef\s+\K\d+(?=\s+PerceptronCount)' "$PERCEPTRON_FILE")
    # echo "Local: $LOCAL_HIST, Global: $GLOBAL_HIST, Count: $PERCEPTRON_COUNT"
else
    echo "Error: $PERCEPTRON_FILE not found."
    exit 1
fi

OUTPUT_FILE="${LOCAL_HIST}_${GLOBAL_HIST}_${PERCEPTRON_COUNT}.txt"


BASE_COMMAND="./bin/champsim --warmup_instructions 10000000 --simulation_instructions 10000000"
TRACE="454.calculix-104B.champsimtrace.xz"
echo "Running: $BASE_COMMAND $TRACE > results/histories/$OUTPUT_FILE"
$BASE_COMMAND $TRACE > "results/histories/$OUTPUT_FILE"
