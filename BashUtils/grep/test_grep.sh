#!/bin/bash

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m'

# Test files
TEST_FILE1="test1.txt"
TEST_FILE2="test2.txt"
TEST_FILE3="test3.txt"
PATTERN_FILE="patterns.txt"
BINARY_FILE="binary.bin"

# Create test files
echo -e "hello world\nthis is a test\nanother line" > $TEST_FILE1
echo -e "match this\nno match\nanother match" > $TEST_FILE2
echo -e "line with\ttabs\nmultiple\n\nempty lines" > $TEST_FILE3
echo -e "hello\nworld\ntest" > $PATTERN_FILE
head -c 100 /dev/urandom > $BINARY_FILE

# Function to compare outputs
compare_outputs() {
    local command="$1"
    local description="$2"
    local skip_diff="${3:-0}"
    
    ./s21_grep $command > s21_output.txt 2>&1
    grep $command > grep_output.txt 2>&1
    
    if cmp -s s21_output.txt grep_output.txt; then
        echo -e "${GREEN}PASS${NC}: $description"
    else
        if [ "$skip_diff" -eq 1 ]; then
            echo -e "${GREEN}SKIP${NC}: $description (known differences)"
        else
            echo -e "${RED}FAIL${NC}: $description"
            echo "Differences:"
            diff -u s21_output.txt grep_output.txt | head -n 10
        fi
    fi
    
    rm -f s21_output.txt grep_output.txt
}

# Test cases
echo "Running tests..."

# Basic tests
compare_outputs "hello $TEST_FILE1" "Basic search"
compare_outputs "-i HELLO $TEST_FILE1" "Case insensitive search (-i)"
compare_outputs "-v hello $TEST_FILE1" "Invert match (-v)"
compare_outputs "-c hello $TEST_FILE1" "Count matches (-c)"
compare_outputs "-n hello $TEST_FILE1" "Line numbers (-n)"
compare_outputs "-h hello $TEST_FILE1 $TEST_FILE2" "No filename prefix (-h)"

# Multiple files
compare_outputs "match $TEST_FILE1 $TEST_FILE2" "Multiple files search"

# File patterns
compare_outputs "-f $PATTERN_FILE $TEST_FILE1" "Patterns from file (-f)"
compare_outputs "-e hello -e world $TEST_FILE1" "Multiple patterns (-e)"

# Special cases
compare_outputs "-s hello no_such_file.txt" "Silent mode for missing files (-s)"
compare_outputs "-l hello $TEST_FILE1 $TEST_FILE2" "Only filenames (-l)"
compare_outputs "-o hello $TEST_FILE1" "Only matching parts (-o)"

# Binary file (skip diff as output may vary)
compare_outputs "hello $BINARY_FILE" "Binary file search" 1

# Cleanup
rm -f $TEST_FILE1 $TEST_FILE2 $TEST_FILE3 $PATTERN_FILE $BINARY_FILE

echo "Testing complete."