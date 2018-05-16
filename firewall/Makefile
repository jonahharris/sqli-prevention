# SQLi Firewall
# Makefile
# Bc. Dominika Regeciova, xregec00

all:
	flex sql.l
	bison -d sql.y
	g++ -std=c++11 firewall.cpp -DYYDEBUG=1 sql.tab.c lex.yy.c -o firewall
clean:
	rm -f firewall sql lex.yy.c sql.tab.c sql.tab.h