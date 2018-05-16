#!/bin/bash

# Testovani SQL parseru
# Bc. Dominika Regeciova, xregec00

if [ $# -eq 1 ]
then
    verbose=1
else
    verbose=0
fi

RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m'
counter=0
for file1 in sql/*.in; do
    check=0
    file2=$(echo $file1 | cut -f 1 -d '.')
    file2="$file2.out"
    while IFS=$'\t' read -r line1 line2; do
        [[ "$line1" =~ ^\>.*$ ]] && echo "${line1}" && continue
        [[ "$line1" =~ ^#.*$ ]]  && continue
        [[ verbose -eq 1 ]] && echo "./sql_test" \""${line1}"\"
        ((counter++))
        res=$(./sql_test "${line1}")
        if [ "${res}" != "${line2}" ]
        then
            echo -e "${RED}CHYBA:${NC} \"$line1"\": \""$line2\" != \"$res\""
            check=1
        fi
    done <<< $(paste $file1 $file2)
    if [ $check -eq 0 ]
    then
        echo -e "${GREEN}OK${NC}"
    else
        echo -e "${RED}CHYBA${NC}"
    fi
done
echo -e "Spusteno $counter sql testu"
