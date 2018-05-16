#!/bin/bash

# Testovani SQLi Firewallu
# Bc. Dominika Regeciova, xregec00

if [ $# -eq 1 ]
then
    verbose=1
else
    verbose=0
fi
echo ">>> Spoustim Makefile"
make
if [ $verbose -eq 1 ]
then
    echo ">>> Spoustim testy SQL parseru s volbou verbose"
    bash ./sql_test.sh -v
    echo ">>> Spoustim testy SQLi Firewallu s volbou verbose"
    bash ./firewall_test.sh -v
else
    echo ">>> Spoustim testy SQL parseru"
    bash ./sql_test.sh
    echo ">>> Spoustim testy SQLi Firewallu"
    bash ./firewall_test.sh
fi
echo ">>> Spoustim make clean"
make clean
