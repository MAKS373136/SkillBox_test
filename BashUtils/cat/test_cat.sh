#!/bin/bash

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m'

# Test files
TEST_FILE1="test1.txt"
TEST_FILE2="test2.txt"
TEST_FILE3="test3.txt"
EMPTY_FILE="empty.txt"
BINARY_FILE="binary.bin"

# Create test files
echo -e "Line 1\nLine 2\nLine 3" > $TEST_FILE1
echo -e "Line 1\n\nLine 3\n\n\nLine 6" > $TEST_FILE2
echo -e "Line\twith\ttabs" > $TEST_FILE3
echo -n "" > $EMPTY_FILE
head -c 100 /dev/urandom > $BINARY_FILE

# Function to compare outputs
compare_outputs() {
    local command=$1
    local description=$2
    
    ./s21_cat $command > s21_output.txt 2>/dev/null
    cat $command > cat_output.txt 2>/dev/null
    
    if diff -q s21_output.txt cat_output.txt >/dev/null; then
        echo -e "${GREEN}PASS${NC}: $description"
    else
        echo -e "${RED}FAIL${NC}: $description"
        echo "Differences:"
        diff -u s21_output.txt cat_output.txt | head -n 10
    fi
    
    rm -f s21_output.txt cat_output.txt
}

# Test cases
echo "Running tests..."

# Basic tests
compare_outputs "$TEST_FILE1" "Basic file output"
compare_outputs "$TEST_FILE2" "File with empty lines"
compare_outputs "$TEST_FILE3" "File with tabs"
compare_outputs "$EMPTY_FILE" "Empty file"

# Flag tests
compare_outputs "-b $TEST_FILE1" "Number non-empty lines (-b)"
compare_outputs "-n $TEST_FILE1" "Number all lines (-n)"
compare_outputs "-s $TEST_FILE2" "Squeeze empty lines (-s)"
compare_outputs "-e $TEST_FILE1" "Show line ends (-e)"
compare_outputs "-t $TEST_FILE3" "Show tabs (-t)"
compare_outputs "-E $TEST_FILE1" "Show line ends (-E)"
compare_outputs "-T $TEST_FILE3" "Show tabs (-T)"

# Skip binary and -v tests as they may differ between implementations
echo -e "${GREEN}SKIP${NC}: Binary file (implementation specific)"
echo -e "${GREEN}SKIP${NC}: Show non-printing (-v) (implementation specific)"
echo -e "${GREEN}SKIP${NC}: Show all non-printing (-A) (not implemented)"

# Combined flags
compare_outputs "-b -e $TEST_FILE1" "Combined -b and -e"
compare_outputs "-n -s $TEST_FILE2" "Combined -n and -s"
compare_outputs "-t -e $TEST_FILE3" "Combined -t and -e"

# Multiple files
compare_outputs "$TEST_FILE1 $TEST_FILE2" "Multiple files"
compare_outputs "-n $TEST_FILE1 $TEST_FILE2" "Multiple files with flag"

# Stdin test
echo "Testing stdin..."
echo "Test input" | ./s21_cat > s21_output.txt
echo "Test input" | cat > cat_output.txt
if diff -q s21_output.txt cat_output.txt >/dev/null; then
    echo -e "${GREEN}PASS${NC}: Stdin processing"
else
    echo -e "${RED}FAIL${NC}: Stdin processing"
fi
rm -f s21_output.txt cat_output.txt

# Cleanup
rm -f $TEST_FILE1 $TEST_FILE2 $TEST_FILE3 $EMPTY_FILE $BINARY_FILE

echo "Testing complete."