/* 
* Parser pro SQL (MariaDB verze 10.1.31) 
* Soubor: sql.l
* Bc. Dominika Regeciova, xregec00
*/

%option noyywrap nodefault yylineno case-insensitive
%{
#include <iostream>
#include <string.h>
#include <stdarg.h>
#include "sql.tab.h"

int oldstate;

using namespace std;
#define YY_DECL extern int yylex()

void yyerror(const char *s, ...);
%}

%x COMMENT
%s BTWMODE
%%

 /*** Klicova slova, seznam prejat ze souboru /opt/lampp/include/private/lex.h ***/
ACCESSIBLE     { return ACCESSIBLE; }
ACTION         { return ACTION; }
ADD            { return ADD; }
ADMIN          { return ADMIN; }
AFTER          { return AFTER; }
AGAINST        { return AGAINST; }
AGGREGATE      { return AGGREGATE; }
ALL            { return ALL; }
ALGORITHM      { return ALGORITHM; }
ALTER          { return ALTER; }
ALWAYS         { return ALWAYS; }
ANALYZE        { return ANALYZE; }
 /* 
 * Hack for BETWEEN ... AND ... 
 * return special AND token if BETWEEN seen
 */
<BTWMODE>AND    { BEGIN INITIAL; return AND; }
AND            { return ANDOP; }
ANY            { return ANY; }
AS             { return AS; }
ASC            { return ASC; }
ASCII          { return ASCII; }
ASENSITIVE     { return ASENSITIVE; }
AT             { return AT; }
ATOMIC         { return ATOMIC; }
AUTO_INCREMENT { return AUTO_INCREMENT; }
AUTOEXTEND_SIZE    { return AUTOEXTEND_SIZE; }
AUTO           { return AUTO; }
AVG_ROW_LENGTH { return AVG_ROW_LENGTH; }
BACKUP         { return BACKUP; }
BEFORE         { return BEFORE; }
BEGIN          { return BEGINX; }
BETWEEN        { BEGIN BTWMODE; return BETWEEN; }
BIGINT         { return BIGINT; }
BINARY         { return BINARY; }
BINLOG         { return BINLOG; }
BIT            { return BIT; }
BLOB           { return BLOB; }
BLOCK          { return BLOCK; }
BOOL           { return BOOL; }
BOOLEAN        { return BOOLEAN; }
BOTH           { return BOTH; }
BTREE          { return BTREE; }
BY             { return BY; }
BYTE           { return BYTE; }
CACHE          { return CACHE; }
CALL           { return CALL; }
CASCADE        { return CASCADE; }
CASCADED       { return CASCADED; }
CASE           { return CASE; }
CATALOG_NAME   { return CATALOG_NAME; }
CHAIN          { return CHAIN; }
CHANGE         { return CHANGE; }
CHANGED        { return CHANGED; }
CHAR(ACTER)?   { return CHAR;}
CHARSET        { return CHARSET; }
CHECK          { return CHECK; }
CHECKPOINT     { return CHECKPOINT; }
CHECKSUM       { return CHECKSUM; }
CIPHER         { return CIPHER; }
CLASS_ORIGIN   { return CLASS_ORIGIN; }
CLIENT         { return CLIENT; }
CLOSE          { return CLOSE; }
COALESCE       { return COALESCE; }
CODE           { return CODE; }
COLLATE        { return COLLATE; }
COLLATION      { return COLLATION; }
COLUMN         { return COLUMN; }
COLUMN_NAME    { return COLUMN_NAME; }
COLUMNS        { return COLUMNS; }
COLUMN_ADD     { return COLUMN_ADD; }
COLUMN_CHECK   { return COLUMN_CHECK; }
COLUMN_CREATE  { return COLUMN_CREATE; }
COLUMN_DELETE  { return COLUMN_DELETE; }
COLUMN_GET     { return COLUMN_GET; }
COMMENT        { return COMMENT; }
COMMIT         { return COMMIT; }
COMMITTED      { return COMMITTED; }
COMPACT        { return COMPACT; }
COMPLETION     { return COMPLETION; }
COMPRESSED     { return COMPRESSED; }
CONCURRENT     { return CONCURRENT; }
CONDITION      { return CONDITION; }
CONNECTION     { return CONNECTION; }
CONSISTENT     { return CONSISTENT; }
CONSTRAINT     { return CONSTRAINT; }
CONSTRAINT_CATALOG     { return CONSTRAINT_CATALOG; }
CONSTRAINT_NAME        { return CONSTRAINT_NAME; }
CONSTRAINT_SCHEMA      { return CONSTRAINT_SCHEMA; }
CONTAINS       { return CONTAINS; }
CONTEXT        { return CONTEXT; }
CONTINUE       { return CONTINUE; }
CONTRIBUTORS   { return CONTRIBUTORS; }
CONVERT        { return CONVERT; }
CPU            { return CPU; }
CREATE         { return CREATE; }
CROSS          { return CROSS; }
CUBE           { return CUBE; }
CURRENT        { return CURRENT; }
CURRENT_DATE   { return CURRENT_DATE; }
CURRENT_POS    { return CURRENT_POS; }
CURRENT_ROLE   { return CURRENT_ROLE; }
CURRENT_TIME   { return CURRENT_TIME; }
CURRENT_TIMESTAMP      { return CURRENT_TIMESTAMP; }
CURRENT_USER   { return CURRENT_USER; }
CURSOR           { return CURSOR; }
CURSOR_NAME      { return CURSOR_NAME; }
DATA           { return DATA; }
DATABASE       { return DATABASE; }
DATABASES      { return DATABASES; }
DATAFILE       { return DATAFILE; }
DATE           { return DATE; }
DATETIME       { return DATETIME; }
DAY            { return DAY; }
DAY_HOUR       { return DAY_HOUR; }
DAY_MICROSECOND    { return DAY_MICROSECOND; }
DAY_MINUTE     { return DAY_MINUTE; }
DAY_SECOND     { return DAY_SECOND; }
DEALLOCATE     { return DEALLOCATE; }     
DEC            { return DECIMAL; }
DECIMAL        { return DECIMAL; }
DECLARE        { return DECLARE; }
DEFAULT        { return DEFAULT; }
DEFINER        { return DEFINER; }
DELAYED        { return DELAYED; }
DELAY_KEY_WRITE    { return DELAY_KEY_WRITE; }
DELETE         { return DELETE; }
DELETE_DOMAIN_ID   { return DELETE_DOMAIN_ID; }
DESC           { return DESC; }
DESCRIBE       { return DESCRIBE; }
DES_KEY_FILE   { return DES_KEY_FILE; }
DETERMINISTIC  { return DETERMINISTIC; }
DIAGNOSTICS    { return DIAGNOSTICS; }
DIRECTORY      { return DIRECTORY; }
DISABLE        { return DISABLE; }
DISCARD        { return DISCARD; }
DISK           { return DISK; }
DISTINCT       { return DISTINCT; }
DISTINCTROW    { return DISTINCTROW; }    /* Access likes this */
DIV            { return DIV; }
DO             { return DO; }
DOUBLE         { return DOUBLE; }
DO_DOMAIN_IDS      { return DO_DOMAIN_IDS; }
DROP           { return DROP; }
DUAL           { return DUAL; }
DUMPFILE       { return DUMPFILE; }
DUPLICATE      { return DUPLICATE; }
DYNAMIC        { return DYNAMIC; }
EACH           { return EACH; }
ELSE           { return ELSE; }
ELSEIF         { return ELSEIF; }
ENABLE         { return ENABLE; }
ENCLOSED       { return ENCLOSED; }
END            { return END; }
ENDS           { return ENDS; }
ENGINE         { return ENGINE; }
ENGINES        { return ENGINES; }
ENUM           { return ENUM; }
ERROR          { return ERROR; }
ERRORS         { return ERRORS; }
ESCAPE         { return ESCAPE; }
ESCAPED        { return ESCAPED; }
EVENT          { return EVENT; }
EVENTS         { return EVENTS; }
EVERY          { return EVERY; }
EXAMINED       { return EXAMINED; }
EXCHANGE       { return EXCHANGE; }
EXECUTE        { return EXECUTE; }
EXISTS         { yylval.subtok = 0; return EXISTS; }
NOT[ \t\n]+EXISTS   { yylval.subtok = 1; return EXISTS; }
EXIT           { return EXIT; }
EXPANSION      { return EXPANSION; }
EXPORT         { return EXPORT; }
EXPLAIN        { return DESCRIBE; }
EXTENDED       { return EXTENDED; }
EXTENT_SIZE    { return EXTENT_SIZE; }
FAST           { return FAST; }
FAULTS         { return FAULTS; }
FETCH          { return FETCH; }
FIELDS         { return COLUMNS; }
FILE           { return FILEX; }
FIRST          { return FIRST; }
FIXED          { return FIXED; }
FLOAT          { return FLOAT; }
FLOAT4         { return FLOAT; }
FLOAT8         { return DOUBLE; }
FLUSH          { return FLUSH; }
FOR            { return FOR; }
FORCE          { return FORCE; }
FOREIGN        { return FOREIGN; }
FORMAT         { return FORMAT; }
FOUND          { return FOUND; }
FROM           { return FROM; }
FULL           { return FULL; }
FULLTEXT       { return FULLTEXT; }
FUNCTION       { return FUNCTION; }
GENERAL        { return GENERAL; }
GENERATED      { return GENERATED; }
GEOMETRY       { return GEOMETRY; }
GEOMETRYCOLLECTION     { return GEOMETRYCOLLECTION; }
GET_FORMAT     { return GET_FORMAT; }
GET            { return GET; }
GLOBAL         { return GLOBAL; }
GRANT          { return GRANT; }
GRANTS         { return GRANTS; }
GROUP          { return GROUP; }
HANDLER        { return HANDLER; }
HARD           { return HARD; }
HASH           { return HASH; }
HAVING         { return HAVING; }
HELP           { return HELP; }
HIGH_PRIORITY  { return HIGH_PRIORITY; }
HOST           { return HOST; }
HOSTS          { return HOSTS; }
HOUR           { return HOUR; }
HOUR_MICROSECOND   { return HOUR_MICROSECOND; }
HOUR_MINUTE    { return HOUR_MINUTE; }
HOUR_SECOND    { return HOUR_SECOND; }
IDENTIFIED     { return IDENTIFIED; }
IF             { return IF; }
IGNORE         { return IGNORE; }
IGNORE_DOMAIN_IDS      { return IGNORE_DOMAIN_IDS; }
IGNORE_SERVER_IDS      { return IGNORE_SERVER_IDS; }
IMPORT         { return IMPORT; }
IN             { return IN; }
INDEX          { return INDEX; }
INDEXES        { return INDEXES; }
INFILE         { return INFILE; }
INITIAL_SIZE   { return INITIAL_SIZE; }
INNER          { return INNER; }
INOUT          { return INOUT; }
INSENSITIVE    { return INSENSITIVE; }
INSERT         { return INSERT; }
INSERT_METHOD  { return INSERT_METHOD; }
INSTALL        { return INSTALL; }
INT            { return INT; }
INT1           { return TINYINT; }
INT2           { return SMALLINT; }
INT3           { return MEDIUMINT; }
INT4           { return INT; }
INT8           { return BIGINT; }
INTEGER        { return INT; }
INTERVAL       { return INTERVAL; }
INTO           { return INTO; }
IO             { return IO; }
IO_THREAD      { return RELAY_THREAD; }
IPC            { return IPC; }
IS             { return IS; }
ISOLATION      { return ISOLATION; }
ISSUER         { return ISSUER; }
ITERATE        { return ITERATE; }
INVOKER        { return INVOKER; }
JOIN           { return JOIN; }
KEY            { return KEY; }
KEYS           { return KEYS; }
KEY_BLOCK_SIZE     { return KEY_BLOCK_SIZE; }
KILL           { return KILL; }
LANGUAGE       { return LANGUAGE; }
LAST           { return LAST; }
LAST_VALUE     { return LAST_VALUE; }
LEADING        { return LEADING; }
LEAVE          { return LEAVE; }
LEAVES         { return LEAVES; }
LEFT           { return LEFT; }
LESS           { return LESS; }
LEVEL          { return LEVEL; }
LIKE           { return LIKE; }
LIMIT          { return LIMIT; }
LINEAR         { return LINEAR; }
LINES          { return LINES; }
LINESTRING     { return LINESTRING; }
LIST           { return LIST; }
LOAD           { return LOAD; }
LOCAL          { return LOCAL; }
LOCALTIME      { return LOCALTIME; }
LOCALTIMESTAMP     { return LOCALTIMESTAMP; }
LOCK           { return LOCK; }
LOCKS          { return LOCKS; }
LOGFILE        { return LOGFILE; }
LOGS           { return LOGS; }
LONG           { return LONG; }
LONGBLOB       { return LONGBLOB; }
LONGTEXT       { return LONGTEXT; }
LOOP           { return LOOP; }
LOW_PRIORITY   { return LOW_PRIORITY; }
MASTER         { return MASTER; }
MASTER_CONNECT_RETRY   { return MASTER_CONNECT_RETRY; }
MASTER_GTID_POS        { return MASTER_GTID_POS; }
MASTER_HOST            { return MASTER_HOST; }
MASTER_LOG_FILE        { return MASTER_LOG_FILE; }
MASTER_LOG_POS         { return MASTER_LOG_POS; }
MASTER_PASSWORD        { return MASTER_PASSWORD; }
MASTER_PORT            { return MASTER_PORT; }
MASTER_SERVER_ID       { return MASTER_SERVER_ID; }
MASTER_SSL             { return MASTER_SSL; }
MASTER_SSL_CA          { return MASTER_SSL_CA; }
MASTER_SSL_CAPATH      { return MASTER_SSL_CAPATH; }
MASTER_SSL_CERT        { return MASTER_SSL_CERT; }
MASTER_SSL_CIPHER      { return MASTER_SSL_CIPHER; }
MASTER_SSL_CRL         { return MASTER_SSL_CRL; }
MASTER_SSL_CRLPATH     { return MASTER_SSL_CRLPATH; }
MASTER_SSL_KEY         { return MASTER_SSL_KEY; }
MASTER_SSL_VERIFY_SERVER_CERT  { return MASTER_SSL_VERIFY_SERVER_CERT; }
MASTER_USER            { return MASTER_USER; }
MASTER_USE_GTID        { return MASTER_USE_GTID; }
MASTER_HEARTBEAT_PERIOD        { return MASTER_HEARTBEAT_PERIOD; }
MATCH                  { return MATCH; }
MAX_CONNECTIONS_PER_HOUR       { return MAX_CONNECTIONS_PER_HOUR; }
MAX_QUERIES_PER_HOUR           { return MAX_QUERIES_PER_HOUR; }
MAX_ROWS       { return MAX_ROWS; }
MAX_SIZE       { return MAX_SIZE; }
MAX_STATEMENT_TIME     { return MAX_STATEMENT_TIME; }
MAX_UPDATES_PER_HOUR   { return MAX_UPDATES_PER_HOUR; }
MAX_USER_CONNECTIONS   { return MAX_USER_CONNECTIONS; }
MAX_VALUE      { return MAX_VALUE; }
MEDIUM         { return MEDIUM; }
MEDIUMBLOB     { return MEDIUMBLOB; }
MEDIUMINT      { return MEDIUMINT; }
MEDIUMTEXT     { return MEDIUMTEXT; }
MEMORY         { return MEMORY; }
MERGE          { return MERGE; }
MESSAGE_TEXT   { return MESSAGE_TEXT; }
MICROSECOND    { return MICROSECOND; }
MIDDLEINT      { return MEDIUMINT; }   /* For powerbuilder */
MIGRATE        { return MIGRATE; }
MINUTE         { return MINUTE; }
MINUTE_MICROSECOND     { return MINUTE_MICROSECOND; }
MINUTE_SECOND  { return MINUTE_SECOND; }
MIN_ROWS       { return MIN_ROWS; }
MOD            { return MOD; }
MODE           { return MODE; }
MODIFIES       { return MODIFIES; }
MODIFY         { return MODIFY; }
MONTH          { return MONTH; }
MULTILINESTRING        { return MULTILINESTRING; }
MULTIPOINT     { return MULTIPOINT; }
MULTIPOLYGON   { return MULTIPOLYGON; }
MUTEX          { return MUTEX; }
MYSQL          { return MYSQL; }
MYSQL_ERRNO    { return MYSQL_ERRNO; }
NAMES          { return NAMES; }
NATIONAL       { return NATIONAL; }
NATURAL        { return NATURAL; }
NCHAR          { return NCHAR; }
NEW            { return NEW; }
NEXT           { return NEXT; }
NO             { return NO; }
NOWAIT         { return NOWAIT; }
NODEGROUP      { return NODEGROUP; }
NONE           { return NONE; }
NOT            { return NOT; }
NO_WRITE_TO_BINLOG     { return NO_WRITE_TO_BINLOG; }
NULL           { return NULLX; }
NUMBER         { return NUMBER; }
NUMERIC        { return NUMERIC; }
NVARCHAR       { return NVARCHAR; }
OFFSET         { return OFFSET; }
OLD_PASSWORD   { return OLD_PASSWORD; }
ON             { return ON; }
ON[ \t\n]+DUPLICATE     {return ONDUPLICATE;}
ONE            { return ONE; }
ONLINE         { return ONLINE; }
ONLY           { return ONLY; }
OPEN           { return OPEN; }
OPTIMIZE       { return OPTIMIZE; }
OPTIONS        { return OPTIONS; }
OPTION         { return OPTION; }
OPTIONALLY     { return OPTIONALLY; }
OR             { return OR; }
ORDER          { return ORDER; }
OUT            { return OUT; }
OUTER          { return OUTER; }
OUTFILE        { return OUTFILE; }
OWNER          { return OWNER; }
PACK_KEYS      { return PACK_KEYS; }
PAGE           { return PAGE; }
PAGE_CHECKSUM  { return PAGE_CHECKSUM; }
PARSER         { return PARSER; }
PARSE_VCOL_EXPR        { return PARSE_VCOL_EXPR; }
PARTIAL        { return PARTIAL; }
PARTITION      { return PARTITION; }
PARTITIONING   { return PARTITIONING; }
PARTITIONS     { return PARTITIONS; }
PERSISTENT     { return PERSISTENT; }
PHASE          { return PHASE; }
PLUGIN         { return PLUGIN; }
PLUGINS        { return PLUGINS; }
POINT          { return POINT; }
POLYGON        { return POLYGON; }
PORT           { return PORT; }
PRECISION      { return PRECISION; }
PREPARE        { return PREPARE; }
PRESERVE       { return PRESERVE; }
PREV           { return PREV; }
PRIMARY        { return PRIMARY; }
PRIVILEGES     { return PRIVILEGES; }
PROCEDURE      { return PROCEDURE; }
PROCESS        { return PROCESS; }
PROCESSLIST    { return PROCESSLIST; }
PROFILE        { return PROFILE; }
PROFILES       { return PROFILES; }
PROXY          { return PROXY; }
PURGE          { return PURGE; }
QUARTER        { return QUARTER; }
QUERY          { return QUERY; }
QUICK          { return QUICK; }
RANGE          { return RANGE; }
READ           { return READ; }
READ_ONLY      { return READ_ONLY; }
READ_WRITE     { return READ_WRITE; }
READS          { return READS; }
REAL           { return REAL; }
REBUILD        { return REBUILD; }
RECOVER        { return RECOVER; }
REDO_BUFFER_SIZE       { return REDO_BUFFER_SIZE; }
REDOFILE       { return REDOFILE; }
REDUNDANT      { return REDUNDANT; }
REFERENCES     { return REFERENCES; }
REGEXP         { return REGEXP; }
RELAY          { return RELAY; }
RELAYLOG       { return RELAYLOG; }
RELAY_LOG_FILE       { return RELAY_LOG_FILE; }
RELAY_LOG_POS        { return RELAY_LOG_POS; }
RELAY_THREAD         { return RELAY_THREAD; }
RELEASE        { return RELEASE; }
RELOAD         { return RELOAD; }
REMOVE         { return REMOVE; }
RENAME         { return RENAME; }
REORGANIZE     { return REORGANIZE; }
REPAIR         { return REPAIR; }
REPEATABLE     { return REPEATABLE; }
REPLACE        { return REPLACE; }
REPLICATION    { return REPLICATION; }
REPEAT         { return REPEAT; }
REQUIRE        { return REQUIRE; }
RESET          { return RESET; }
RESIGNAL       { return RESIGNAL; }
RESTORE        { return RESTORE; }
RESTRICT       { return RESTRICT; }
RESUME         { return RESUME; }
RETURNED_SQLSTATE      { return RETURNED_SQLSTATE; }
RETURN         { return RETURN; }
RETURNING      { return RETURNING; }
RETURNS        { return RETURNS; }
REVERSE        { return REVERSE; }
REVOKE         { return REVOKE; }
RIGHT          { return RIGHT; }
RLIKE          { return REGEXP; }  /* Like in mSQL2 */
ROLE           { return ROLE; }
ROLLBACK       { return ROLLBACK; }
ROLLUP         { return ROLLUP; }
ROUTINE        { return ROUTINE; }
ROW            { return ROW; }
ROW_COUNT      { return ROW_COUNT; }
ROWS           { return ROWS; }
ROW_FORMAT     { return ROW_FORMAT; }
RTREE          { return RTREE; }
SAVEPOINT      { return SAVEPOINT; }
SCHEDULE       { return SCHEDULE; }
SCHEMA         { return DATABASE; }
SCHEMA_NAME    { return SCHEMA_NAME; }
SCHEMAS        { return DATABASES; }
SECOND         { return SECOND; }
SECOND_MICROSECOND     { return SECOND_MICROSECOND; }
SECURITY       { return SECURITY; }
SELECT         { return SELECT; }
SENSITIVE      { return SENSITIVE; }
SEPARATOR      { return SEPARATOR; }
SERIAL         { return SERIAL; }
SERIALIZABLE   { return SERIALIZABLE; }
SESSION        { return SESSION; }
SERVER         { return SERVER; }
SET            { return SET; }
SHARE          { return SHARE; }
SHOW           { return SHOW; }
SHUTDOWN       { return SHUTDOWN; }
SIGNAL         { return SIGNAL; }
SIGNED         { return SIGNED; }
SIMPLE         { return SIMPLE; }
SLAVE          { return SLAVE; }
SLAVES         { return SLAVES; }
SLAVE_POS      { return SLAVE_POS; }
SLOW           { return SLOW; }
SNAPSHOT       { return SNAPSHOT; }
SMALLINT       { return SMALLINT; }
SOCKET         { return SOCKET; }
SOFT           { return SOFT; }
SOME           { return ANY; }
SONAME         { return SONAME; }
SOUNDS         { return SOUNDS; }
SOURCE         { return SOURCE; }
SPATIAL        { return SPATIAL; }
SPECIFIC       { return SPECIFIC; }
REF_SYSTEM_ID  { return REF_SYSTEM_ID; }
SQL            { return SQL; }
SQLEXCEPTION   { return SQLEXCEPTION; }
SQLSTATE       { return SQLSTATE; }
SQLWARNING     { return SQLWARNING; }
SQL_BIG_RESULT { return SQL_BIG_RESULT; }
SQL_BUFFER_RESULT      { return SQL_BUFFER_RESULT; }
SQL_CACHE      { return SQL_CACHE; }
SQL_CALC_FOUND_ROWS    { return SQL_CALC_FOUND_ROWS; }
SQL_NO_CACHE   { return SQL_NO_CACHE; }
SQL_SMALL_RESULT       { return SQL_SMALL_RESULT; }
SQL_THREAD     { return SQL_THREAD; }
SQL_TSI_SECOND { return SECOND; }
SQL_TSI_MINUTE { return MINUTE; }
SQL_TSI_HOUR   { return HOUR; }
SQL_TSI_DAY    { return DAY; }
SQL_TSI_WEEK   { return WEEK; }
SQL_TSI_MONTH  { return MONTH; }
SQL_TSI_QUARTER        { return QUARTER; }
SQL_TSI_YEAR   { return YEAR; }
SSL            { return SSL; }
START          { return START; }
STARTING       { return STARTING; }
STARTS         { return STARTS; }
STATEMENT      { return STATEMENT; }
STATS_AUTO_RECALC      { return STATS_AUTO_RECALC; }
STATS_PERSISTENT       { return STATS_PERSISTENT; }
STATS_SAMPLE_PAGES     { return STATS_SAMPLE_PAGES; }
STOP           { return STOP; }
STORAGE        { return STORAGE; }
STRAIGHT_JOIN  { return STRAIGHT_JOIN; }
STRING         { return STRING; }
SUBCLASS_ORIGIN        { return SUBCLASS_ORIGIN; }
SUBJECT        { return SUBJECT; }
SUBPARTITION   { return SUBPARTITION; }
SUBPARTITIONS  { return SUBPARTITIONS; }
SUPER          { return SUPER; }
SUSPEND        { return SUSPEND; }
SWAPS          { return SWAPS; }
SWITCHES       { return SWITCHES; }
TABLE          { return TABLE; }
TABLES          { return TABLES; }
TABLESPACE     { return TABLESPACE; }
TABLE_CHECKSUM     { return TABLE_CHECKSUM; }
TEMPORARY      { return TEMPORARY; }
TEMPTABLE      { return TEMPTABLE; }
TERMINATED     { return TERMINATED; }
TEXT           { return TEXT; }
THAN           { return THAN; }
THEN           { return THEN; }
TIME           { return TIME; }
TIMESTAMP      { return TIMESTAMP; }
TIMESTAMPADD   { return TIMESTAMPADD; }
TIMESTAMPDIFF  { return TIMESTAMPDIFF; }
TINYBLOB       { return TINYBLOB; }
TINYINT        { return TINYINT; }
TINYTEXT       { return TINYTEXT; }
TO             { return TO; }
TRAILING       { return TRAILING; }
TRANSACTION    { return TRANSACTION; }
TRANSACTIONAL  { return TRANSACTIONAL; }
TRIGGER        { return TRIGGER; }
TRIGGERS       { return TRIGGERS; }
TRUNCATE       { return TRUNCATE; }
TYPE           { return TYPE; }
TYPES          { return TYPES; }
UNCOMMITTED    { return UNCOMMITTED; }
UNDEFINED      { return UNDEFINED; }
UNDO_BUFFER_SIZE       { return UNDO_BUFFER_SIZE; }
UNDOFILE       { return UNDOFILE; }
UNDO           { return UNDO; }
UNICODE        { return UNICODE; }
UNION          { return UNION; }
UNIQUE         { return UNIQUE; }
UNLOCK         { return UNLOCK; }
UNINSTALL      { return UNINSTALL; }
UNSIGNED       { return UNSIGNED; }
UNTIL          { return UNTIL; }
UPDATE         { return UPDATE; }
UPGRADE        { return UPGRADE; }
USAGE          { return USAGE; }
USE            { return USE; }
USER_RESOURCES { return USER_RESOURCES; }
USE_FRM        { return USE_FRM; }
USING          { return USING; }
UTC_DATE       { return UTC_DATE; }
UTC_TIME       { return UTC_TIME; }
UTC_TIMESTAMP  { return UTC_TIMESTAMP; }
VALUE          { return VALUE; }
VALUES         { return VALUES; }
VARBINARY      { return VARBINARY; }
VARCHAR(ACTER)?        { return VARCHAR; }
VARIABLES      { return VARIABLES; }
VARYING        { return VARYING; }
VIA            { return VIA; }
VIEW           { return VIEW; }
VIRTUAL        { return VIRTUAL; }
WAIT           { return WAIT; }
WARNINGS       { return WARNINGS; }
WEEK           { return WEEK; }
WEIGHT_STRING  { return WEIGHT_STRING; }
WHEN           { return WHEN; }
WHERE          { return WHERE; }
WHILE          { return WHILE; }
WITH           { return WITH; }
WRAPPER        { return WRAPPER; }
WRITE          { return WRITE; }
X509           { return X509; }
XOR            { return XOR; }
XA             { return XA; }
XML            { return XML; } /* LOAD XML Arnold/Erik */
YEAR           { return YEAR; }
YEAR_MONTH     { return YEAR_MONTH; }
ZEROFILL       { return ZEROFILL; }

 /*** Funkce ***/
ADDDATE/"("        { return FDATE_ADD; }
AVG/"("            { return FAVG; }
BIT_AND/"("        { return FBIT_AND; }
BIT_OR/"("         { return FBIT_OR; }
BIT_XOR/"("        { return FBIT_XOR; }
CHAR/"("           { return FCHAR; }
CHARSET/"("        { return FCHARSET; }
CONCAT/"("         { return FCONCAT; }
COUNT              { return FCOUNT; }
CURDATE/"("        { return FCURDATE; }
CURTIME/"("        { return FCURTIME; }
DATE_ADD/"("       { return FDATE_ADD; }
DATE_SUB/"("       { return FDATE_SUB; }
MAX/"("            { return FMAX; }
MID/"("            { return FSUBSTRING; }
MIN/"("            { return FMIN; }
NOW/"("            { return FNOW; }
SUBDATE/"("        { return FDATE_SUB; }
SUBSTR/"("         { return FSUBSTRING; }
SUBSTRING/"("      { return FSUBSTRING; }
SUM/"("            { return FSUM; }
TRIM/"("           { return FTRIM; }
TRUNCATE/"("       { return FTRUNCATE; }

 /*** Cisla ***/
[-+]?[0-9]+           { yylval.ival = atoi(yytext); return INT;  }
[-+]?[0-9]+"."[0-9]* |
[-+]?"."[0-9]+     |
[-+]?[0-9]+E[-+]?[0-9]+    |
[-+]?[0-9]+"."[0-9]*E[-+]?[0-9]+ |
[-+]?"."[0-9]+E[-+]?[0-9]+     { yylval.fval = atof(yytext); return FLOAT; }

 /*** Extra firewall promenna ***/
\*\*\*     { yylval.sval = strdup(yytext); return STRING; }

TRUE                { yylval.ival = 1; return BOOL; }
UNKNOWN             { yylval.ival = -1; return BOOL; }
FALSE               { yylval.ival = 0; return BOOL; }

 /*** Retezce ***/
'(\\.|''|[^'\n])*'   |
\"(\\.|\"\"|[^"\n])*\"      { yylval.sval = strdup(yytext); return STRING; }

'(\\.|[^'\n])*$     { yyerror("Neukonceny retezec %s", yytext); }
\"(\\.|[^"\n])*$    { yyerror("Neukonceny retezec %s", yytext); }

 /*** Retezce v hex ***/
X'[0-9A-F]+' |
0x[0-9A-F]+         { yylval.sval = strdup(yytext); return STRING; }

 /*** Binarni retezce ***/
0b[01]+  |
B'[01]+'            { yylval.sval = strdup(yytext); return STRING; }

 /*** Operatory ***/
[-+&~|^/%*(),.;!]   { return yytext[0]; }

"&&"                { return ANDOP; }
"||"                { return OR; }

"="                 { yylval.subtok = 4; return COMPARISON; }
"<=>"               { yylval.subtok = 12; return COMPARISON; }
">="                { yylval.subtok = 6; return COMPARISON; }
">"                 { yylval.subtok = 2; return COMPARISON; }
"<="                { yylval.subtok = 5; return COMPARISON; }
"<"                 { yylval.subtok = 1; return COMPARISON; }
"!=" | "<>"         { yylval.subtok = 3; return COMPARISON; }
"<<"                { yylval.subtok = 1; return SHIFT; }
">>"                { yylval.subtok = 2; return SHIFT; }
":="                { return ASSIGN; }

 /*** Identifikator ***/
[0-9a-zA-Z$_]+     { yylval.sval = strdup(yytext); return NAME; }

`[^`/\\.\n]+`       { yylval.sval = strdup(yytext+1);
                      yylval.sval[yyleng-2] = 0;
                      return NAME; }

`[^`\n]*$           { yyerror("Neukoncene uvozeni identifikatoru %s", yytext); }

 /*** Uzivatelske promenne ***/
@[0-9a-z_.$]+ |
@\"[^"\n]+\" |
@`[^`\n]+` |
@'[^'\n]+'          { yylval.sval = strdup(yytext+1); return USERVAR; }

 /*** Komentare ***/   
#.*                 ;
"--"[ \t].*         ;

"/*"                { oldstate = YY_START; BEGIN COMMENT; }
<COMMENT>"*/"       { BEGIN oldstate; }
<COMMENT>.|\n       ;
<COMMENT><<EOF>>    { yyerror("Neukonceny komentar"); exit(1);}

  /*** Vse ostatni ***/
[ \t\n]             /* whitespace */
.                   { yyerror("Neznamy znak '%c'", *yytext); }

%%
