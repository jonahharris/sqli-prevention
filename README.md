# SQLi Firewall
# Bc. Dominika Regéciová, xregec00

## MariaDB SQL Syntaktický analýzator
### Zdroje:
* LEVINE, John. 2009. Flex & bison. Sebastopol, CA: O'Reilly Media. ISBN 978-0-596-15597-1.
* http://blog.ptsecurity.com/2018/01/mysql-grammar-in-antlr-4.html
* https://mariadb.com/kb/en/library/
* https://dev.mysql.com/doc/refman/8.0/en/

## Access Mode
### Stanovení pravidel pro daný dotaz
    AM => DATABASE (TABLE)* STMT
    DATABASE => database NAME (create | -) (alter | -) (drop | -) ;
    TABLE => table NAME (select | -) (insert | -) (update | -) (delete | -) ;
    STMT => NUMBER ;
    NAME => [0-9a-zA-Z$_]+ | `UNICODE`
    NUMBER => 0-9 

    např.: database sqli-prevention - - -; table authors select - - -; stmt 1;

## Návod
### Překlad:
    $ make
### Použití:
    $ ./firewall access_mode sql_query user_input
    $ ./firewall "database sqli_prevention - - -; table authors select - - -; stmt 1;" "SELECT * FROM authors WHERE name='***';" "Terry"
    $ ./firewall "database sqli_prevention - - -; table authors select - - -; stmt 1;" "SELECT * FROM authors WHERE name='***';" "' OR 1;-- '"
    $ ./firewall "database sqli_prevention - - -; table authors select - - -; stmt 1;" "SELECT * FROM authors WHERE name='***';" "'; delete from authors;-- '"
### Definování sql_query:
Místo v dotazu, kam bude vložen uživatelský vstup lze definovat 3 způsoby - pokud očekáváme řetězec, vkládáme na dané místo '***'. Pro identifikátory, jakými jsou například jména tabulek
a sloupců, je potřeba použít zpětných uvozovek (*backtick*) \`***\`, ve všech dalších případech stačí ***.
### Úklid:
    $ make clean

## Rozpoznávané útoky:
### Příkaz navíc pomoc stmt
    ./firewall "database sqli_prevention - - -; table authors select - - -; stmt 1;" "SELECT * FROM authors WHERE name='***';" "'; delete from authors;-- '"

### Nesprávně zadané SQL (neznámé modifikace SQL)
* jiná syntax (například jiný SQL jazyk, chybějící ; na konci příkazu,...)

### Porušení oprávnění
* použití jiné databáze, tabulky, nebo provádění jiných dotazů, než které byly povoleny (v případě nahrazených dotazů <br/>za pomoci komentáře)

### Kratší dotaz s uživatelským vstupem než originálním
    Dotaz bez SQLi
    ./firewall "database sqli_prevention - - -; table authors select - - -; stmt 1;" "SELECT * FROM authors WHERE name='***' and active=1;" "Terry"
    Dotaz s SQLi
    ./firewall "database sqli_prevention - - -; table authors select - - -; stmt 1;" "SELECT * FROM authors WHERE name='***' and active=1;" "' or 1;-- "

### Další změny/nahrazení části dotazu po '***'
* testuji i část předtím (chyba možná jedině v mé aplikaci, útočník nemá jak upravit část dotazu předcházející jeho vstup)
* zatím rozdíl napevno nastaven na 1, možná rozšíření o AM
* v uživatelském vstupu proto nelze použít volání funkcí


## Testování
Pro účely testování byly vytvořeny sady SQL dotazů, přičemž bylo hodnoceno jak jejich správné rozpoznávání, tak detekce možného SQLi.
    
    $ cd /tests
    $ chmod +x *.sh
    $ bash ./run_tests.sh [-v]
    Volba -v slouží pro podrobnější výpis prováděných testů

V případě používání školních serverů FIT VUT  je potřeba spouštět testy na eva.fit.vutbr.cz, kde je Bash ve verzi 4.4.19. <br/>
Druhý server, merlin.fit.vutbr.cz, sice testy rovněž interpretuje úspěšně, ale zde umístěný Bash ve verzi 4.2.46 vede <br/>k neúplnému vyhodnocení skriptů, které zhoršuje čitelnost výsledků.
