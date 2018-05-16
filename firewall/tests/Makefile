# SQL parser test
# Makefile
# Bc. Dominika Regeciova, xregec00

all:
	cp ../sql.l .
	flex ./sql.l
	cp ../sql.y .
	bison -d ./sql.y
	g++ -std=c++11 sql_test.cpp -DYYDEBUG=1 sql.tab.c lex.yy.c -o sql_test
	cp ../firewall.cpp .
	g++ -std=c++11 ./firewall.cpp -DYYDEBUG=1 sql.tab.c lex.yy.c -o firewall
clean:
	rm -f firewall sql_test lex.yy.c sql.tab.c sql.tab.h sql.l sql.y firewall.cpp