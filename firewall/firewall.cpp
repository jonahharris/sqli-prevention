/* 
    SQLi Firewall
    firewall.cpp
    Bc. Dominika Regeciova, xregec00
*/

#include <algorithm>
#include <bitset>
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

class Firewall
{
    public:
        Firewall(string permissions, string sql_query, string user_input)
        {
            this->sql_query = sql_query;
            this->user_input = user_input;

            // Vlozeni uzivatelskeho vstupu do dotazu
            size_t index = 0;
            this->untrusted = this->sql_query;
            index = this->untrusted.find("***");
            if (index == std::string::npos)
            {
                cout << "V SQL dotazu chybi ***!" << endl; 
                exit(RESULT_FAILURE);
            }
            this->untrusted.replace(index, 3, user_input);

            this->parsed_sql = "";
            this->parsed_untrusted = "";

            // access mode ovlivni databases, tables a stmt
            access_mode(permissions);
        }

        Firewall()
        {}

        // "database sqli-prevention - - -; table authors select - - -; table book select insert update delete; stmt 1;"
        void access_mode(string permissions)
        {
            istringstream iss(permissions);
            string rule;
            vector<string> rules;
            int counter = 0;
            while(getline(iss, rule, ';'))
            {
                rules.push_back(rule);
            }
            if (rules.size() < 2)
            {
                cout << "Access Mode: nedostatecne mnozstvi pravidel!" << endl; 
                exit(RESULT_FAILURE);
            }
            // Pravidlo prvni musi stanovovat databazi
            while (counter < rules.size())
            {
                istringstream iss2(rules.at(counter));
                vector<string> v;
                string word;
                string key;
                iss2 >> key;
                while(iss2 >> word)
                {
                    v.push_back(word);
                }
                if (v.size() == 0)
                {
                    cout << "Access Mode: chybi jmena nebo pocet dotazu!" << endl;  
                    exit(RESULT_FAILURE);   
                }
                // database NAME (create | '-') (alter | '-') (drop | '-') ';'
                if (counter == 0 && key == "database")
                {
                    if (v.size() != 4)
                    {
                        cout << "Access Mode: nespravny pocet prav pro databazi!"  << endl;
                        exit(RESULT_FAILURE);
                    }
                    this->database = v.at(0);
                    bitset<3> welp(000);
                    if (v.at(1) == "create")
                        welp |= 4; // 100
                    if (v.at(2) == "alter")
                        welp |= 2; // 010
                    if (v.at(3) == "drop")
                        welp |= 1; // 001
                    this->database_bits = welp;
                }
                // table NAME (select | '-') (insert | '-') (update | '-') (delete | '-');
                else if (counter <  (rules.size() - 1) && key == "table")
                {
                    if (v.size() != 5)
                    {
                        cout << "Access Mode: nespravny pocet prav pro tabulku!"  << endl;
                        exit(RESULT_FAILURE);
                    }
                    this->tables.push_back(v.at(0));
                    this->dtables.push_back(this->database + "." + v.at(0));
                    bitset<4> welp(0000); //0000
                    if (v.at(1) == "select")
                        welp |= 8; // 1000
                    if (v.at(2) == "insert")
                        welp |= 4; // 0100
                    if (v.at(3) == "update")
                        welp |= 2; // 0010
                    if (v.at(4) == "delete")
                        welp |= 1; // 0001
                    this->tables_bites.push_back(welp);
                }
                // stmt NUMBER ';'
                else if (counter == (rules.size() - 1) && key == "stmt")
                {
                    if (v.size() != 1)
                    {
                        cout << "Access Mode: nespravny pocet dotazu!"  << endl;
                        exit(RESULT_FAILURE);
                    }
                    this->stmt = atoi(v.at(0).c_str());
                }
                else
                {
                    cout << "Access Mode: neznamy format!" << endl; 
                    exit(RESULT_FAILURE);
                }
                v.clear();
                counter++;
            }
        }

        void parse_sql()
        {
            // Originalni SQL dotaz
            this->parsed_sql = my_parse(this->sql_query.c_str());
            // Kontrola, parser vraci minimalne '1;' v pripade prazdneho dotazy, jinak '...;0;', nebo '...;1;' 
            // 0 znamena, ze parsovani probehlo v poradku, 1 zanci chybu v dotaze, nebo neznamy dotaz
            if (this->parsed_sql.size() < 2)
            {
                cout << "Prilis kratky vysledek parsovaneho SQL dotazu!" << endl;
                exit(RESULT_FAILURE);
            }
            char c = this->parsed_sql[(this->parsed_sql.size()-2)];
            int check_result = c - '0';
            if (check_result != 0)
                exit(RESULT_FAILURE);

            // Dotaz doplneni o vstup uzivatele
            this->parsed_untrusted = my_parse(this->untrusted.c_str());
            if (this->parsed_untrusted.size() < 2)
            {
                cout << "Prilis kratky vysledek parsovaneho SQL dotazu!" << endl;
                exit(RESULT_FAILURE);
            }
            c = this->parsed_untrusted[(this->parsed_untrusted.size()-2)];
            check_result = c - '0';
            if (check_result != 0)
            {
                cout << "SQL dotaz nebyl spravne rozpoznan!" << endl;
                exit(RESULT_FAILURE);
            }
        }

        void check_sql()
        {
            // Kontrola, zda uz probehlo parsovani dotazu
            if (this->parsed_sql == "" || this->parsed_untrusted == "")
            {
                cout << "Firewall nema k dispozici zproacovane dotazy, pouzijte nejdrive funkci 'parse_sql()'" << endl;
                exit(RESULT_FAILURE);
            }
            // Kontrola, zda zpracovane dotazy maji minimalni delku
            if (this->parsed_sql.size() < 4 || this->parsed_untrusted.size() < 4)
            {
                cout << "Prilis kratky vysledek parsovaneho SQL dotazu!" << endl;
                exit(RESULT_FAILURE);
            }

            // Krok 1: kontrola poctu dotazu
            // Odhaluje pridane dotazy typu
            char c = this->parsed_sql[(this->parsed_sql.size()-4)];
            int check_stmt = c - '0';
            c = this->parsed_untrusted[(this->parsed_untrusted.size()-4)];
            int check_stmt2 = c - '0';
            if (check_stmt != this->stmt || check_stmt2 != this->stmt)
            {
                cout << "stmt: " << std::to_string(stmt);
                cout << " stmt originalniho dotazu: " << std::to_string(check_stmt);
                cout << " stmt upraveneho dotazu: " << std::to_string(check_stmt2) << endl;
                cout << "Pravdepdobny SQLi utok detekovan, rozdilne stmt hodnoty!" << endl;
                exit(RESULT_FAILURE);
            }

            // Krok 2: kontrola AM (hledani klicovych slov v kazdem dotazu (rozdelit dle STMT;))
            // Priklad: SELECTALL;TABLE authors;NAME name;STRING 'Terry';CMP 4;WHERE;SELECT 0 1 1;STMT;1;0;
            istringstream iss(this->parsed_untrusted);
            string command;
            vector<bitset<4>>tt;
            while(getline(iss, command, ';'))
            {
                vector<string> commands;
                while (command != "STMT")
                {
                    commands.push_back(command);
                    break;
                }
                // pro kazdy dotaz resime prava zvlast
                if (command == "STMT")
                    tt.clear();
                unsigned int i;
                for (i = 0; i < commands.size(); i++)
                {
                    istringstream iss2(commands.at(i));
                    string word;
                    while(iss2 >> word)
                    {
                        if (word == "DATABASE")
                        {
                            iss2 >> word;
                            if (word != this->database & word != "THIS")
                            {
                                cout << "SQL dotaz neopravenene pristupuje k databazi" << endl;
                                exit(RESULT_FAILURE);
                            }
                            cout << "Prosla kontrola pro databazi " << word << endl;
                            break;
                        }
                        else if (word == "TABLE")
                        {
                            iss2 >> word;
                            size_t t = find(this->tables.begin(), this->tables.end(), word) - this->tables.begin();
                            if (t >= this->tables.size())
                            {
                                t = find(this->dtables.begin(), this->dtables.end(), word) - this->dtables.begin(); 
                                if (t >= this->dtables.size())
                                {
                                    cout << "SQL dotaz neopravenene pristupuje k tabulce" << endl;
                                    exit(RESULT_FAILURE);
                                }
                            }
                            cout << "Prosla kontrola pro tabulky " << word << " s opravnenim " << this->tables_bites.at(t) << endl;
                            tt.push_back(this->tables_bites.at(t));
                            break;
                        }
                        else if (word == "CREATE")
                        {
                            bitset<3> r(4);
                            r &= this->database_bits;
                            if (r == 0)
                            {
                                cout << "SQL dotaz nema pravo na create database" << endl;
                                exit(RESULT_FAILURE);
                            }
                            cout << "create opravneni OK" << endl;
                            break;
                        }
                        else if (word == "ALTER")
                        {
                            bitset<3> r(2);
                            r &= this->database_bits;
                            if (r == 0)
                            {
                                cout << "SQL dotaz nema pravo na alter database" << endl;
                                exit(RESULT_FAILURE);
                            }
                            cout << "alter opravneni OK" << endl;
                            break;
                        }
                        else if (word == "DROP")
                        {
                            bitset<3> r(1);
                            r &= this->database_bits;
                            if (r == 0)
                            {
                                cout << "SQL dotaz nema pravo na drop database" << endl;
                                exit(RESULT_FAILURE);
                            }
                            cout << "drop opravneni OK" << endl;
                            break;
                        }
                        else if (word == "SELECT")
                        {
                            if (tt.size() == 0)
                            {
                                cout << "Nenalezena zadna opravneni" << endl;
                                exit(RESULT_FAILURE);   
                            }
                            for (auto i: tt)
                            {
                                bitset<4> r(8);
                                r &= i;
                                if (r == 0)
                                {
                                    cout << "SQL dotaz nema pravo na select table" << endl;
                                    exit(RESULT_FAILURE);
                                }
                                cout << "select opravneni OK" << endl;
                            }
                            break;
                        }
                        else if (word == "INSERT")
                        {
                            if (tt.size() == 0)
                            {
                                cout << "Nenalezena zadna opravneni" << endl;
                                exit(RESULT_FAILURE);   
                            }
                            for (auto i: tt)
                            {
                                bitset<4> r(4);
                                r &= i;
                                if (r == 0)
                                {
                                    cout << "SQL dotaz nema pravo na insert table" << endl;
                                    exit(RESULT_FAILURE);
                                }
                                cout << "insert opravneni OK" << endl;
                            }
                            break;
                        }
                        else if (word == "UPDATE")
                        {
                            if (tt.size() == 0)
                            {
                                cout << "Nenalezena zadna opravneni" << endl;
                                exit(RESULT_FAILURE);   
                            }
                            for (auto i: tt)
                            {
                                bitset<4> r(2);
                                r &= i;
                                if (r == 0)
                                {
                                    cout << "SQL dotaz nema pravo na update table" << endl;
                                    exit(RESULT_FAILURE);
                                }
                                cout << "update opravneni OK" << endl;
                            }
                            break;
                        }
                        else if (word == "DELETE" | word == "TRUNCATE" | word == "DROPTABLE")
                        {
                            if (tt.size() == 0)
                            {
                                cout << "Nenalezena zadna opravneni" << endl;
                                exit(RESULT_FAILURE);   
                            }
                            for (auto i: tt)
                            {
                                bitset<4> r(1);
                                r &= i;
                                if (r == 0)
                                {
                                    cout << "SQL dotaz nema pravo na delete table" << endl;
                                    exit(RESULT_FAILURE);
                                }
                                cout << "delete opravneni OK" << endl;
                            }
                            break;
                        }
                        else if (word == "REPLACE")
                        {
                            if (tt.size() == 0)
                            {
                                cout << "Nenalezena zadna opravneni" << endl;
                                exit(RESULT_FAILURE);   
                            }
                            for (auto i: tt)
                            {
                                // replace potrebuje opravneni insert i delete
                                bitset<4> r(5);
                                r &= i;
                                if (r == 0)
                                {
                                    cout << "SQL dotaz nema pravo na replace table" << endl;
                                    exit(RESULT_FAILURE);
                                }
                                cout << "replace opravneni OK" << endl;
                            }
                            break;
                        }
                        else if (word == "SHOW" | word == "DESCRIBE")
                        {
                            cout << "SQL dotaz byl implicitne zakazan" << endl;
                            exit(RESULT_FAILURE);
                        }
                        // nemusime prohledavat vsechny casti dotazu
                        else
                            break;
                    }
                }
                commands.clear();
            }

            // Krok 3: postupne porovnavani this->parsed_sql a this->parsed_untrusted
            vector<string>original;
            vector<string>newone;

            istringstream iss3(this->parsed_sql);
            string rule;
            while(getline(iss3, rule, ';'))
                original.push_back(rule);

            istringstream iss4(this->parsed_untrusted);
            string rule2;
            while(getline(iss4, rule2, ';'))
            {
                newone.push_back(rule2);
            }

            // Bud nekde nastala nesrovnalost, nebo utocnik zakomentoval zbytek dotazu
            if (newone.size() < original.size())
            {
                cout << "SQL dotaz s uzivatelskym vstupem je kratsi nez vzorovy dotaz!" << endl;
                exit(RESULT_FAILURE);
            }
            
            unsigned int i = 0;
            while (i < original.size())
            {
                if (original.at(i).size() > 5)
                {
                    if ((original.at(i).substr(original.at(i).length() - 3 ) == "***") || (original.at(i).substr(original.at(i).length() - 5 ) == "'***'") || original.at(i) == "ORDERBY 3")
                    {
                        // mozna i + AM konstanta pro volani char()???
                        i++;
                        continue;
                    }
                }
                if (original.at(i) != newone.at(i))
                {
                    cout << "SQL dotaz s uzivatelskym vstupem se neshoduje se vzorovym dotazem!" << endl;
                    exit(RESULT_FAILURE);
                }
                i++;
            }

            cout << "SQL dotaz je pravdepodobne bezpecny." << endl;
        }

        string to_string()
        {
            string s;
            s += "Firewall:\n";
            s += "Originalni dotaz: " + this->sql_query + "\n";
            s += "Vstup uzivatele: " + this->user_input + "\n";
            s += "Upraveny dotaz: " + this->untrusted + "\n";
            s += "Databaze: " + this->database + " " + database_bits.to_string() + "\n";
            s += "Tabulky: \n";
            for (unsigned int i =0; i < tables.size(); i++)
            {
                s += tables.at(i) + " (" + dtables.at(i) + ") " + tables_bites.at(i).to_string() + "\n";
            }
            s += "Hodnota stmt: " + std::to_string(stmt) + "\n";
            s += "Tokeny originalniho dotazu: " + this->parsed_sql + "\n";
            s += "Tokeny upraveneho dotazu: " + this->parsed_untrusted; + "\n";
            return s;
        }

    private:
        string sql_query;
        string user_input;
        string untrusted;
        string parsed_sql;
        string parsed_untrusted;

        // Access Mode informace
        string database;
        bitset<3> database_bits;
        vector<string> dtables;
        vector<string> tables;
        vector<bitset<4>>tables_bites;
        int stmt;
};


void Print_Help()
{
    cout << "Prevence SQL Injection utoku" << endl;
    cout << "./firewall access_mode sql_query user_input" << endl;
    cout << "./firewall \"database sqli_prevention - - -; table authors select - - -; stmt 1;\" ";
    cout << "\"SELECT * FROM authors WHERE name='***';\" \"Terry\"" << endl;
    cout << "./firewall \"database sqli_prevention - - -; table authors select - - -; stmt 1;\" ";
    cout << "\"SELECT * FROM authors WHERE name='***';\" \"' OR 1--'\"" << endl;
    exit(RESULT_FAILURE);
}

int main(int argc, char *argv[])
{
    if (argc != 4)
        Print_Help();

    Firewall f;
    f = Firewall(argv[1], argv[2], argv[3]);
    f.parse_sql();
    cout << f.to_string() << endl;
    f.check_sql();

    return RESULT_OK;
}
