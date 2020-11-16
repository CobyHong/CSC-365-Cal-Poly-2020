#!/bin/sh

echo "CSC 365"
echo "Lab 1-a test suite"
echo ""

echo "TC-1"
echo "Tests Requirements R4"
echo "S[tudent] search with no B[us] option"
echo "Input:    S: COOKUS"
python3 studentsearch.py < test1.in > test1.out, mytest1.out
echo "Expected: check test1.out"
echo "Actual:   check mytest1.out"