#!/bin/bash

TRACEDIR="traces/"
TRACE="454.calculix-104B.champsimtrace.xz"

# Run with warmup instructions from 10 to 10**7, and simulation instructions of 10**6
for ((i=10; i<=10**7; i*=10)); do
    BASE_COMMAND="./bin/champsim --warmup_instructions $i"
    echo "Running: $BASE_COMMAND --simulation_instructions 1000"
    echo $BASE_COMMAND "--simulation_instructions" 1000 $TRACE "&> results/startup/perceptron/${i}.txt"
    $BASE_COMMAND "--simulation_instructions" 1000 ${TRACEDIR}${TRACE} > "results/startup/perceptron/${i}.txt"
done
