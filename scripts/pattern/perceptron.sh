#!/bin/bash

# Define the base command
COMMAND="./build/test_main --gtest_filter=PerceptronTests.PredPatternTest"
echo "Running: $COMMAND"
$COMMAND > "results/pattern/perceptron.txt"
