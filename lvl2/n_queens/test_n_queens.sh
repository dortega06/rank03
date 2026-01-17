#!/bin/bash

# Colors for output
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Compile the program
echo "Compiling n_queens.c..."
gcc -Wall -Wextra -Werror n_queens.c -o n_queens
if [ $? -ne 0 ]; then
    echo -e "${RED}Compilation failed! ${NC}"
    exit 1
fi
echo -e "${GREEN}Compilation successful!${NC}\n"

# Test counters
total_tests=0
passed_tests=0
manual_tests=0

# Function to run a test
run_test() {
    local test_name=$1
    local input=$2
    local expected_file=$3
    
    total_tests=$((total_tests + 1))
    echo "=========================================="
    echo "Test: $test_name"
    echo "Input: $input"
    echo "------------------------------------------"
    
    if [ -z "$input" ]; then
        ./n_queens > output.txt 2>&1
    else
        ./n_queens "$input" > output.txt 2>&1
    fi
    
    if [ -f "$expected_file" ]; then
        if diff -q output.txt "$expected_file" > /dev/null; then
            echo -e "${GREEN}✓ PASSED${NC}"
            passed_tests=$((passed_tests + 1))
        else
            echo -e "${RED}✗ FAILED${NC}"
            echo "Expected:"
            cat "$expected_file"
            echo "Got:"
            cat output.txt
        fi
    else
        echo "Output:"
        cat output.txt
        echo -e "${YELLOW}(No expected file to compare)${NC}"
    fi
    echo ""
}

# Function for manual verification tests
run_manual_test() {
    local test_name=$1
    local input=$2
    
    total_tests=$((total_tests + 1))
    manual_tests=$((manual_tests + 1))
    echo "=========================================="
    echo "Test: $test_name"
    echo "Input: $input"
    echo "------------------------------------------"
    
    if [ -z "$input" ]; then
        ./n_queens > output.txt 2>&1
    else
        ./n_queens "$input" > output.txt 2>&1
    fi
    
    echo "Output:"
    cat output. txt
    echo -e "${BLUE}ℹ  MANUAL VERIFICATION (not counted as pass/fail)${NC}"
    echo ""
}

# Create expected output files

# N=1
cat > expected_1.txt << 'EOF'
0
EOF

# N=2 (no solutions)
touch expected_2.txt

# N=3 (no solutions)
touch expected_3.txt

# N=4
cat > expected_4.txt << 'EOF'
1 3 0 2
2 0 3 1
EOF

# N=5
cat > expected_5.txt << 'EOF'
0 2 4 1 3
0 3 1 4 2
1 3 0 2 4
1 4 2 0 3
2 0 3 1 4
2 4 1 3 0
3 0 2 4 1
3 1 4 2 0
4 1 3 0 2
4 2 0 3 1
EOF

# N=6
cat > expected_6.txt << 'EOF'
1 3 5 0 2 4
2 5 1 4 0 3
3 0 4 1 5 2
4 2 0 5 3 1
EOF

echo "Running tests..."
echo ""

# Test valid inputs
run_test "N=1 (single queen)" "1" "expected_1.txt"
run_test "N=2 (no solution)" "2" "expected_2.txt"
run_test "N=3 (no solution)" "3" "expected_3.txt"
run_test "N=4 (2 solutions)" "4" "expected_4.txt"
run_test "N=5 (10 solutions)" "5" "expected_5.txt"
run_test "N=6 (4 solutions)" "6" "expected_6.txt"

# Test edge cases - error handling
echo "=========================================="
echo "Test: No arguments"
total_tests=$((total_tests + 1))
./n_queens > output.txt 2>&1
exit_code=$?
if [ $exit_code -eq 1 ] && [ ! -s output. txt ]; then
    echo -e "${GREEN}✓ PASSED (returns 1, no output)${NC}"
    passed_tests=$((passed_tests + 1))
else
    echo -e "${RED}✗ FAILED (should return 1 with no output)${NC}"
    echo "Exit code: $exit_code"
    echo "Output:"
    cat output.txt
fi
echo ""

echo "=========================================="
echo "Test:  Empty string argument"
total_tests=$((total_tests + 1))
./n_queens "" > output.txt 2>&1
exit_code=$?
if [ $exit_code -eq 1 ] && [ ! -s output.txt ]; then
    echo -e "${GREEN}✓ PASSED (returns 1, no output)${NC}"
    passed_tests=$((passed_tests + 1))
else
    echo -e "${RED}✗ FAILED (should return 1 with no output)${NC}"
    echo "Exit code: $exit_code"
    echo "Output:"
    cat output.txt
fi
echo ""

echo "=========================================="
echo "Test:  Multiple arguments"
total_tests=$((total_tests + 1))
./n_queens "4" "5" > output.txt 2>&1
exit_code=$?
if [ $exit_code -eq 1 ] && [ ! -s output. txt ]; then
    echo -e "${GREEN}✓ PASSED (returns 1, no output)${NC}"
    passed_tests=$((passed_tests + 1))
else
    echo -e "${RED}✗ FAILED (should return 1 with no output)${NC}"
    echo "Exit code: $exit_code"
    echo "Output:"
    cat output.txt
fi
echo ""

# Manual verification tests (edge cases without strict specification)
run_manual_test "N=0 (edge case)" "0"
run_manual_test "Negative number (edge case)" "-1"
run_manual_test "Non-numeric input (edge case)" "abc"

# Performance test
echo "=========================================="
echo "Test: N=8 (Performance test - should complete quickly)"
total_tests=$((total_tests + 1))
echo "Running N=8 (92 solutions expected)..."
timeout 5 ./n_queens "8" > output.txt 2>&1
if [ $? -eq 124 ]; then
    echo -e "${RED}✗ FAILED (timeout after 5 seconds)${NC}"
else
    solutions=$(wc -l < output.txt)
    if [ "$solutions" -eq 92 ]; then
        echo -e "${GREEN}✓ PASSED (92 solutions found)${NC}"
        passed_tests=$((passed_tests + 1))
    else
        echo -e "${RED}✗ FAILED (expected 92 solutions, got $solutions)${NC}"
    fi
fi
echo ""

# Cleanup
rm -f output.txt expected_*.txt

# Summary
auto_tests=$((total_tests - manual_tests))
echo "=========================================="
echo "SUMMARY"
echo "=========================================="
echo -e "Automated tests: $auto_tests"
echo -e "  Passed:   ${GREEN}$passed_tests${NC}"
echo -e "  Failed:   ${RED}$((auto_tests - passed_tests))${NC}"
echo ""
echo -e "Manual verification tests: ${BLUE}$manual_tests${NC}"
echo -e "Total tests run: $total_tests"

if [ $passed_tests -eq $auto_tests ]; then
    echo -e "\n${GREEN}✅ All automated tests passed!  🎉${NC}"
    exit 0
else
    echo -e "\n${RED}❌ Some automated tests failed.${NC}"
    exit 1
fi

# Cleanup executable
rm -f n_queens
