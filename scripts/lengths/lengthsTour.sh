#!/bin/bash

# Define the base command
BASE_COMMAND="./bin/champsim --warmup_instructions 1000000"
TRACE="454.calculix-104B.champsimtrace.xz"

# Loop through factors of 10 for simulation instructions
for ((i=100; i<=10**7; i*=10)); do
    echo "Running: $BASE_COMMAND --simulation_instructions $i $TRACE"
    $BASE_COMMAND "--simulation_instructions" $i $TRACE > "results/lengths/lengthsTour/${i}.txt"
done
