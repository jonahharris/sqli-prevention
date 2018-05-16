/* 
    SQL parser test
    sql_test.cpp
    Bc. Dominika Regeciova, xregec00
*/

#include <iostream>
#include <string.h>
#include <string>
#include <stdio.h>
#include <sstream>
#include <vector>
#include "sql.tab.h"

using namespace std;

#define RESULT_OK 0
#define RESULT_FAILURE 1

extern string my_parse(const char *s);

int main(int argc, char *argv[])
{
    if (argc != 2)
        return RESULT_FAILURE;

    string result;
    result = my_parse(argv[1]);
    cout << result;
    if (result.size() < 2)
    {
        cout << "Prilis kratky vysledek parsovaneho SQL dotazu!" << endl;
        return RESULT_FAILURE;
    }
    char c = result[(result.size()-2)];
    int check_result = c - '0';
    if (check_result != 0)
        return RESULT_FAILURE;
    return RESULT_OK;
}
