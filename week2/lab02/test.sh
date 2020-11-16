#!/bin/sh

echo "CSC 365"
echo "Lab 1-a test suite"
echo ""

mkdir test_output
echo ""
echo "======================================="

echo "TC-0"
echo "Tests Requirements R1->R3"
echo "Testing Multiple Filters and Functions."
echo "Expected file is:     test0.out"
echo "Output file is:       mytest0.out"
echo ""
python3 schoolsearch.py < ./tests/test0.in > ./test_output/mytest0.out
diff -q ./test_output/test0.out ./test_output/mytest0.out
echo ""
echo "======================================="

echo "TC-1"
echo "Tests Requirements R4"
echo "S[tudent] search with no B[us] option"
echo "Input:    S: COOKUS"
echo "Expected file is:     test1.out"
echo "Output file is:       mytest1.out"
echo ""
python3 schoolsearch.py < ./tests/test1.in > ./test_output/mytest1.out
diff -q ./test_output/test1.out ./test_output/mytest1.out
echo ""
echo "======================================="

echo "TC-2"
echo "Tests Requirements R5"
echo "S[tudent] search with B[us] option"
echo "Input:    S: COOKUS B:"
echo "Expected file is:     test2.out"
echo "Output file is:       mytest2.out"
echo ""
python3 schoolsearch.py < ./tests/test2.in > ./test_output/mytest2.out
diff -q ./test_output/test2.out ./test_output/mytest2.out
echo ""
echo "======================================="

echo "TC-3"
echo "Tests Requirements R6"
echo "T[eacher] search option"
echo "Input:    T: KERBS"
echo "Expected file is:     test3.out"
echo "Output file is:       mytest3.out"
echo ""
python3 schoolsearch.py < ./tests/test3.in > ./test_output/mytest3.out
diff -q ./test_output/test3.out ./test_output/mytest3.out
echo ""
echo "======================================="

echo "TC-4"
echo "Tests Requirements R7"
echo "G[rade] search option"
echo "Input:    G: 4"
echo "Expected file is:     test4.out"
echo "Output file is:       mytest4.out"
echo ""
python3 schoolsearch.py < ./tests/test4.in > ./test_output/mytest4.out
diff -q ./test_output/test4.out ./test_output/mytest4.out
echo ""
echo "======================================="

echo "TC-5"
echo "Tests Requirements R8"
echo "B[us] search option"
echo "Input:    B: 55"
echo "Expected file is:     test5.out"
echo "Output file is:       mytest5.out"
echo ""
python3 schoolsearch.py < ./tests/test5.in > ./test_output/mytest5.out
diff -q ./test_output/test5.out ./test_output/mytest5.out
echo ""
echo "======================================="

echo "TC-6"
echo "Tests Requirements R9"
echo "G[rade] search option with H[igh]"
echo "Input:    G: 2 H:"
echo "Expected file is:     test6.out"
echo "Output file is:       mytest6.out"
echo ""
python3 schoolsearch.py < ./tests/test6.in > ./test_output/mytest6.out
diff -q ./test_output/test6.out ./test_output/mytest6.out
echo ""
echo "======================================="

echo "TC-7"
echo "Tests Requirements R9"
echo "G[rade] search option with L[ow]"
echo "Input:    G: 2 L:"
echo "Expected file is:     test7.out"
echo "Output file is:       mytest7.out"
echo ""
python3 schoolsearch.py < ./tests/test7.in > ./test_output/mytest7.out
diff -q ./test_output/test7.out ./test_output/mytest7.out
echo ""
echo "======================================="

echo "TC-8"
echo "Tests Requirements R10"
echo "A[verage] search option"
echo "Input:    A: 4"
echo "Expected file is:     test8.out"
echo "Output file is:       mytest8.out"
echo ""
python3 schoolsearch.py < ./tests/test8.in > ./test_output/mytest8.out
diff -q ./test_output/test8.out ./test_output/mytest8.out
echo ""
echo "======================================="

echo "TC-9"
echo "Tests Requirements R11"
echo "I[nfo] search option"
echo "Input:    I:"
echo "Expected file is:     test9.out"
echo "Output file is:       mytest9.out"
echo ""
python3 schoolsearch.py < ./tests/test9.in > ./test_output/mytest9.out
diff -q ./test_output/test9.out ./test_output/mytest9.out
echo ""
echo "======================================="

echo "TC-10"
echo "Tests Requirements R12"
echo "Q[uit] option"
echo "Input:    Q:"
echo "Expected file is:     test10.out"
echo "Output file is:       mytest10.out"
echo ""
python3 schoolsearch.py < ./tests/test10.in > ./test_output/mytest10.out
diff -q ./test_output/test10.out ./test_output/mytest10.out
echo ""
echo "======================================="

echo "TC-11"
echo "Tests Requirements R13"
echo "Assuming students.txt is present."
echo "Expected file is:     test0.out"
echo "Output file is:       mytest11.out"
echo ""
python3 schoolsearch.py < ./tests/test0.in > ./test_output/mytest11.out
diff -q ./test_output/test0.out ./test_output/mytest11.out
echo ""
echo "======================================="

echo "TC-12"
echo "Tests Requirements E1"
echo "Assuming students.txt is not present."
echo "Expected file is:     test0.out"
echo "Output file is:       mytest12.out"
echo ""
python3 schoolsearch.py < ./tests/test0.in > ./test_output/mytest12.out
diff -q ./test_output/test0.out ./test_output/mytest12.out
echo ""
echo "======================================="
