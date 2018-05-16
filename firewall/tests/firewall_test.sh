#!/bin/bash

# Testovani SQLi Firewallu
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

file1="./ok/ok_permission.txt"
file2="./ok/ok.txt"
file3="./ok/ok_user.txt"
check=0
counter=0
while IFS=$'\t' read -r line1 line2 line3; do
    [[ "$line1" =~ ^\>.*$ ]] && echo "${line1}" && continue
    [[ "$line1" =~ ^#.*$ ]]  && continue
    [[ verbose -eq 1 ]] && echo "./firewall" \""${line1}"\" \""${line2}"\" \""${line3}"\"
    ((counter++))
    res=$(./firewall "${line1}" "${line2}" "${line3}")
    if [ $? != 0 ]
    then
        echo -e "${RED}CHYBA:${NC} \n $res"
        check=1
    fi
done <<< $(paste $file1 $file2 $file3)
if [ $check == 0 ]
then
    echo -e "${GREEN}OK${NC}"
else
    echo -e "${RED}CHYBA:${NC}"
fi
echo -e "Spusteno $counter firewall ok testu"

file1="./nope/nope_permission.txt"
file2="./nope/nope.txt"
file3="./nope/nope_user.txt"
check=0
counter=0
while IFS=$'\t' read -r line1 line2 line3; do
    [[ "$line1" =~ ^\>.*$ ]] && echo "${line1}" && continue
    [[ "$line1" =~ ^#.*$ ]]  && continue
    [[ verbose -eq 1 ]] && echo "./firewall" \""${line1}"\" \""${line2}"\" \""${line3}"\"
    ((counter++))
    res=$(./firewall "${line1}" "${line2}" "${line3}")
    if [ $? == 0 ]
    then
        echo -e "${RED}CHYBA:${NC} \n $res"
        check=1
    fi
done  <<< $(paste $file1 $file2 $file3)
if [ $check == 0 ]
then
    echo -e "${GREEN}OK${NC}"
else
    echo -e "${RED}CHYBA:${NC}"
fi
echo -e "Spusteno $counter firewall nope testu"