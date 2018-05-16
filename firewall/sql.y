/* 
* Parser pro SQL (MariaDB verze 10.1.31) 
* Soubor: sql.y
* Bc. Dominika Regeciova, xregec00
*/

%{
#include <cstdio>
#include <iostream>
#include <stdlib.h>
#include <stdarg.h>
#include <string.h>

using namespace std;

string parse_result;
int counter_stmt;

extern int yylex();
extern int yyparse();

extern int yylineno;

typedef struct yy_buffer_state * YY_BUFFER_STATE;
extern YY_BUFFER_STATE yy_scan_string(const char * str);
extern void yy_delete_buffer(YY_BUFFER_STATE buffer);

void yyerror(const char *s, ...);
void emit(const char *s, ...);
void emit2(string s);
string my_parse(const char *s);
%}

%union
{
   int ival;
   float fval;
   char *sval;
   int subtok;
}


%token <ival> INT
%token <fval> FLOAT
%token <sval> STRING
%token <sval> NAME
%token <ival> BOOL
%token <sval> USERVAR

%right ASSIGN
%left OR
%left XOR
%left ANDOP
%nonassoc IN IS LIKE REGEXP
%left NOT '!'
%left BETWEEN
%left <subtok> COMPARISON /* = <> < > <= >= <=> */
%left '|'
%left '&'
%left <subtok> SHIFT /* << >> */
%left '+' '-'
%left '*' '/' '%' MOD
%left '^'
%nonassoc UMINUS

%token ACCESSIBLE
%token ACTION
%token ADD
%token ADMIN
%token AFTER
%token AGAINST
%token AGGREGATE
%token ALL
%token ALGORITHM
%token ALTER
%token ALWAYS
%token ANALYZE
%token AND
%token ANDB
%token ANY
%token AS
%token ASC
%token ASCII
%token ASENSITIVE
%token AT
%token ATOMIC
%token AUTO_INCREMENT
%token AUTOEXTEND_SIZE
%token AUTO
%token AVG_ROW_LENGTH
%token BACKUP
%token BEFORE
%token BEGINX
%token BETWEEN
%token BIGINT
%token BINARY
%token BINLOG
%token BIT
%token BLOB
%token BLOCK
%token BOOLEAN
%token BOTH
%token BTREE
%token BY
%token BYTE
%token CACHE
%token CALL
%token CASCADE
%token CASCADED
%token CASE
%token CATALOG_NAME
%token CHAIN
%token CHANGE
%token CHANGED
%token CHAR
%token CHARSET
%token CHECK
%token CHECKPOINT
%token CHECKSUM
%token CIPHER
%token CLASS_ORIGIN
%token CLIENT
%token CLOSE
%token COALESCE
%token CODE
%token COLLATE
%token COLLATION
%token COLUMN
%token COLUMN_NAME
%token COLUMNS
%token COLUMN_ADD
%token COLUMN_CHECK
%token COLUMN_CREATE
%token COLUMN_DELETE
%token COLUMN_GET
%token COMMENT
%token COMMIT
%token COMMITTED
%token COMPACT
%token COMPLETION
%token COMPRESSED
%token CONCURRENT
%token CONDITION
%token CONNECTION
%token CONSISTENT
%token CONSTRAINT
%token CONSTRAINT_CATALOG
%token CONSTRAINT_NAME
%token CONSTRAINT_SCHEMA
%token CONTAINS
%token CONTEXT
%token CONTINUE
%token CONTRIBUTORS
%token CONVERT
%token CPU
%token CREATE
%token CROSS
%token CUBE
%token CURRENT
%token CURRENT_DATE
%token CURRENT_POS
%token CURRENT_ROLE
%token CURRENT_TIME
%token CURRENT_TIMESTAMP
%token CURRENT_USER
%token CURSOR
%token CURSOR_NAME
%token DATA
%token DATABASE
%token DATABASES
%token DATAFILE
%token DATE
%token DATETIME
%token DAY
%token DAY_HOUR
%token DAY_MICROSECOND
%token DAY_MINUTE
%token DAY_SECOND
%token DEALLOCATE
%token DEC
%token DECIMAL
%token DECLARE
%token DEFAULT
%token DEFINER
%token DELAYED
%token DELAY_KEY_WRITE
%token DELETE
%token DELETE_DOMAIN_ID
%token DESC
%token DESCRIBE
%token DES_KEY_FILE
%token DETERMINISTIC
%token DIAGNOSTICS
%token DIRECTORY
%token DISABLE
%token DISCARD
%token DISK
%token DISTINCT
%token DISTINCTROW
%token DIV
%token DO
%token DOUBLE
%token DO_DOMAIN_IDS
%token DROP
%token DUAL
%token DUMPFILE
%token DUPLICATE
%token DYNAMIC
%token EACH
%token ELSE
%token ELSEIF
%token ENABLE
%token ENCLOSED
%token END
%token ENDS
%token ENGINE
%token ENGINES
%token ENUM
%token ERROR
%token ERRORS
%token ESCAPE
%token EVENT
%token EVENTS
%token EVERY
%token EXAMINED
%token EXCHANGE
%token EXECUTE
%token EXIT
%token EXPANSION
%token EXPORT
%token EXPLAIN
%token EXTENDED
%token EXTENT_SIZE
%token FAST
%token FAULTS
%token FETCH
%token FIELDS
%token FILEX
%token FIRST
%token FIXED
%token FLOAT4
%token FLOAT8
%token FLUSH
%token FOR
%token FORCE
%token FOREIGN
%token FORMAT
%token FOUND
%token FROM
%token FULL
%token FULLTEXT
%token FUNCTION
%token GENERAL
%token GENERATED
%token GEOMETRY
%token GEOMETRYCOLLECTION
%token GET_FORMAT
%token GET
%token GLOBAL
%token GRANT
%token GRANTS
%token GROUP
%token HANDLER
%token HARD
%token HASH
%token HAVING
%token HELP
%token HIGH_PRIORITY
%token HOST
%token HOSTS
%token HOUR
%token HOUR_MICROSECOND
%token HOUR_MINUTE
%token HOUR_SECOND
%token IDENTIFIED
%token IF
%token IGNORE
%token IGNORE_DOMAIN_IDS
%token IGNORE_SERVER_IDS
%token IMPORT
%token IN
%token INDEX
%token INDEXES
%token INFILE
%token INITIAL_SIZE
%token INNER
%token INOUT
%token INSENSITIVE
%token INSERT
%token INSERT_METHOD
%token INSTALL
%token INT1
%token INT2
%token INT3
%token INT4
%token INT8
%token INTEGER
%token INTERVAL
%token INTO
%token IO
%token IO_THREAD
%token IPC
%token IS
%token ISOLATION
%token ISSUER
%token ITERATE
%token INVOKER
%token JOIN
%token KEY
%token KEYS
%token KEY_BLOCK_SIZE
%token KILL
%token LANGUAGE
%token LAST
%token LAST_VALUE
%token LEADING
%token LEAVE
%token LEAVES
%token LEFT
%token LESS
%token LEVEL
%token LIKE
%token LIMIT
%token LINEAR
%token LINES
%token LINESTRING
%token LIST
%token LOAD
%token LOCAL
%token LOCALTIME
%token LOCALTIMESTAMP
%token LOCK
%token LOCKS
%token LOGFILE
%token LOGS
%token LONG
%token LONGBLOB
%token LONGTEXT
%token LOOP
%token LOW_PRIORITY
%token MASTER
%token MASTER_CONNECT_RETRY
%token MASTER_GTID_POS
%token MASTER_HOST
%token MASTER_LOG_FILE
%token MASTER_LOG_POS
%token MASTER_PASSWORD
%token MASTER_PORT
%token MASTER_SERVER_ID
%token MASTER_SSL
%token MASTER_SSL_CA
%token MASTER_SSL_CAPATH
%token MASTER_SSL_CERT
%token MASTER_SSL_CIPHER
%token MASTER_SSL_CRL
%token MASTER_SSL_CRLPATH
%token MASTER_SSL_KEY
%token MASTER_SSL_VERIFY_SERVER_CERT
%token MASTER_USER
%token MASTER_USE_GTID
%token MASTER_HEARTBEAT_PERIOD
%token MATCH
%token MAX_CONNECTIONS_PER_HOUR
%token MAX_QUERIES_PER_HOUR
%token MAX_ROWS
%token MAX_SIZE
%token MAX_STATEMENT_TIME
%token MAX_UPDATES_PER_HOUR
%token MAX_USER_CONNECTIONS
%token MAX_VALUE
%token MEDIUM
%token MEDIUMBLOB
%token MEDIUMINT
%token MEDIUMTEXT
%token MEMORY
%token MERGE
%token MESSAGE_TEXT
%token MICROSECOND
%token MIDDLEINT
%token MIGRATE
%token MINUTE
%token MINUTE_MICROSECOND
%token MINUTE_SECOND
%token MIN_ROWS
%token MOD
%token MODE
%token MODIFIES
%token MODIFY
%token MONTH
%token MULTILINESTRING
%token MULTIPOINT
%token MULTIPOLYGON
%token MUTEX
%token MYSQL
%token MYSQL_ERRNO
%token NAMES
%token NATIONAL
%token NATURAL
%token NCHAR
%token NEW
%token NEXT
%token NO
%token NOWAIT
%token NODEGROUP
%token NONE
%token NOT
%token NO_WRITE_TO_BINLOG
%token NULLX
%token NUMBER
%token NUMERIC
%token NVARCHAR
%token OFFSET
%token OLD_PASSWORD
%token ON
%token ONDUPLICATE
%token ONE
%token ONLINE
%token ONLY
%token OPEN
%token OPTIMIZE
%token OPTIONS
%token OPTION
%token OPTIONALLY
%token OR
%token ORDER
%token OUT
%token OUTER
%token OUTFILE
%token OWNER
%token PACK_KEYS
%token PAGE
%token PAGE_CHECKSUM
%token PARSER
%token PARSE_VCOL_EXPR
%token PARTIAL
%token PARTITION
%token PARTITIONING
%token PARTITIONS
%token PERSISTENT
%token PHASE
%token PLUGIN
%token PLUGINS
%token POINT
%token POLYGON
%token PORT
%token PRECISION
%token PREPARE
%token PRESERVE
%token PREV
%token PRIMARY
%token PRIVILEGES
%token PROCEDURE
%token PROCESS
%token PROCESSLIST
%token PROFILE
%token PROFILES
%token PROXY
%token PURGE
%token QUARTER
%token QUERY
%token QUICK
%token RANGE
%token READ
%token READ_ONLY
%token READ_WRITE
%token READS
%token REAL
%token REBUILD
%token RECOVER
%token REDO_BUFFER_SIZE
%token REDOFILE
%token REDUNDANT
%token REFERENCES
%token REGEXP
%token RELAY
%token RELAYLOG
%token RELAY_LOG_FILE
%token RELAY_LOG_POS
%token RELAY_THREAD
%token RELEASE
%token RELOAD
%token REMOVE
%token RENAME
%token REORGANIZE
%token REPAIR
%token REPEATABLE
%token REPLACE
%token REPLICATION
%token REPEAT
%token REQUIRE
%token RESET
%token RESIGNAL
%token RESTORE
%token RESTRICT
%token RESUME
%token RETURNED_SQLSTATE
%token RETURN
%token RETURNING
%token RETURNS
%token REVERSE
%token REVOKE
%token RIGHT
%token RLIKE
%token ROLE
%token ROLLBACK
%token ROLLUP
%token ROUTINE
%token ROW
%token ROW_COUNT
%token ROWS
%token ROW_FORMAT
%token RTREE
%token SAVEPOINT
%token SCHEDULE
%token SCHEMA
%token SCHEMA_NAME
%token SCHEMAS
%token SECOND
%token SECOND_MICROSECOND
%token SECURITY
%token SELECT
%token SENSITIVE
%token SEPARATOR
%token SERIAL
%token SERIALIZABLE
%token SESSION
%token SERVER
%token SET
%token SHARE
%token SHOW
%token SHUTDOWN
%token SIGNAL
%token SIGNED
%token SIMPLE
%token SLAVE
%token SLAVES
%token SLAVE_POS
%token SLOW
%token SNAPSHOT
%token SMALLINT
%token SOCKET
%token SOFT
%token SOME
%token SONAME
%token SOUNDS
%token SOURCE
%token SPATIAL
%token SPECIFIC
%token REF_SYSTEM_ID
%token SQL
%token SQLEXCEPTION
%token SQLSTATE
%token SQLWARNING
%token SQL_BIG_RESULT
%token SQL_BUFFER_RESULT
%token SQL_CACHE
%token SQL_CALC_FOUND_ROWS
%token SQL_NO_CACHE
%token SQL_SMALL_RESULT
%token SQL_THREAD
%token SQL_TSI_SECOND
%token SQL_TSI_MINUTE
%token SQL_TSI_HOUR
%token SQL_TSI_DAY
%token SQL_TSI_WEEK
%token SQL_TSI_MONTH
%token SQL_TSI_QUARTER
%token SQL_TSI_YEAR
%token SSL
%token START
%token STARTING
%token STARTS
%token STATEMENT
%token STATS_AUTO_RECALC
%token STATS_PERSISTENT
%token STATS_SAMPLE_PAGES
%token STOP
%token STORAGE
%token STRAIGHT_JOIN
%token SUBCLASS_ORIGIN
%token SUBJECT
%token SUBPARTITION
%token SUBPARTITIONS
%token SUPER
%token SUSPEND
%token SWAPS
%token SWITCHES
%token TABLE
%token TABLES
%token TABLESPACE
%token TABLE_CHECKSUM
%token TEMPORARY
%token TEMPTABLE
%token TERMINATED
%token TEXT
%token THAN
%token THEN
%token TIME
%token TIMESTAMP
%token TIMESTAMPADD
%token TIMESTAMPDIFF
%token TINYBLOB
%token TINYINT
%token TINYTEXT
%token TO
%token TRAILING
%token TRANSACTION
%token TRANSACTIONAL
%token TRIGGER
%token TRIGGERS
%token TRUNCATE
%token TYPE
%token TYPES
%token UNCOMMITTED
%token UNDEFINED
%token UNDO_BUFFER_SIZE
%token UNDOFILE
%token UNDO
%token UNICODE
%token UNION
%token UNIQUE
%token UNLOCK
%token UNINSTALL
%token UNSIGNED
%token UNTIL
%token UPDATE
%token UPGRADE
%token USAGE
%token USE
%token USER_RESOURCES
%token USE_FRM
%token USING
%token UTC_DATE
%token UTC_TIME
%token UTC_TIMESTAMP
%token VALUE
%token VALUES
%token VARBINARY
%token VARCHAR
%token VARIABLES
%token VARYING
%token VIA
%token VIEW
%token VIRTUAL
%token WAIT
%token WARNINGS
%token WEEK
%token WEIGHT_STRING
%token WHEN
%token WHERE
%token WHILE
%token WITH
%token WRAPPER
%token WRITE
%token X509
%token XOR
%token XA
%token XML
%token YEAR
%token YEAR_MONTH
%token ZEROFILL

%token ESCAPED
%token <subtok> EXISTS /* NOT EXISTS or EXISTS */

/*** funkce ***/
%token FAVG
%token FBIT_AND
%token FBIT_OR
%token FBIT_XOR
%token FCHAR
%token FCHARSET
%token FCONCAT
%token FCOUNT
%token FCURDATE
%token FCURTIME
%token FDATE_ADD
%token FDATE_SUB
%token FMAX
%token FMIN
%token FNOW
%token FSUBSTRING
%token FSUM
%token FTRIM
%token FTRUNCATE

%type <ival> stmt_list stmt select_opts select_expr_list
%type <ival> val_list opt_val_list case_list
%type <ival> groupby_list orderby_list opt_with_rollup opt_asc_desc opt_as
%type <ival> table_references opt_inner_cross opt_outer
%type <ival> left_or_right opt_left_or_right_outer column_list
%type <ival> index_list union_stmt

%type <ival> delete_opts delete_list replace_opts union_opt
%type <ival> insert_opts insert_vals insert_vals_list
%type <ival> insert_asgn_list opt_if_not_exists update_opts update_asgn_list
%type <ival> opt_temporary opt_length opt_binary opt_uz enum_list
%type <ival> column_atts data_type opt_ignore_replace create_col_list
%type <ival> opt_replace opt_default opt_eq opt_drop opt_wait opt_full

%start stmt_list

%%

stmt_list: stmt ';' { emit("STMT"); counter_stmt = $1; }
  | stmt_list stmt ';' { counter_stmt = counter_stmt + $1; emit("STMT"); }
  ;

 /*** Expressions ***/
expr: NAME         { emit("NAME %s", $1); free($1); }
   | NAME '.' NAME '.' NAME { emit("FIELDNAME %s.%s.%s", $1, $3, $5); free($1); free($3); free($5); }
   | NAME '.' NAME '.' '*'  { emit("FIELDNAME %s.%s.*", $1, $3); free($1); free($3); }
   | NAME '.' NAME { emit("FIELDNAME %s.%s", $1, $3); free($1); free($3); }
   | NAME '.' '*'  { emit("FIELDNAME %s.*", $1); free($1); }
   | USERVAR       { emit("USERVAR %s", $1); free($1); }
   | STRING        { emit("STRING '***'"); free($1); }
   | INT           { emit("NUMBER %d", $1); }
   | FLOAT         { emit("FLOAT %g", $1); }
   | BOOL          { emit("BOOL %d", $1); }
   | NULLX        { emit("NULL"); }
   ;
expr: expr '+' expr { emit("ADD"); }
   | expr '-' expr { emit("SUB"); }
   | expr '*' expr { emit("MUL"); }
   | expr '/' expr { emit("DIV"); }
   | expr '%' expr { emit("MOD"); }
   | expr MOD expr { emit("MOD"); }
   | '-' expr %prec UMINUS { emit("NEG"); }
   | expr ANDOP expr { emit("AND"); }
   | expr OR expr { emit("OR"); }
   | expr XOR expr { emit("XOR"); }
   | expr '|' expr { emit("BITOR"); }
   | expr '&' expr { emit("BITAND"); }
   | expr '^' expr { emit("BITXOR"); }
   | expr SHIFT expr { emit("SHIFT %s", $2==1?"left":"right"); }
   | NOT expr { emit("NOT"); }
   | '!' expr { emit("NOT"); }
   | expr COMPARISON expr { emit("CMP %d", $2); }
   | expr COMPARISON '(' select_stmt ')' { emit("CMPSELECT %d", $2); }
   | expr COMPARISON ANY '(' select_stmt ')' { emit("CMPANYSELECT %d", $2); }
   | expr COMPARISON SOME '(' select_stmt ')' { emit("CMPANYSELECT %d", $2); }
   | expr COMPARISON ALL '(' select_stmt ')' { emit("CMPALLSELECT %d", $2); }
   ;

expr:  expr IS NULLX     { emit("ISNULL"); }
   |   expr IS NOT NULLX { emit("ISNULL"); emit("NOT"); }
   |   expr IS BOOL      { emit("ISBOOL %d", $3); }
   |   expr IS NOT BOOL  { emit("ISBOOL %d", $4); emit("NOT"); }

   | USERVAR ASSIGN expr { emit("ASSIGN @%s", $1); free($1); }
   ;

expr: expr BETWEEN expr AND expr %prec BETWEEN { emit("BETWEEN"); }
   ;

val_list: expr { $$ = 1; }
   | expr ',' val_list { $$ = 1 + $3; }
   ;

opt_val_list: /* nil */ { $$ = 0; }
   | val_list
   ;

expr: expr IN '(' val_list ')'       { emit("ISIN %d", $4); }
   | expr NOT IN '(' val_list ')'    { emit("ISIN %d", $5); emit("NOT"); }
   | expr IN '(' select_stmt ')'     { emit("CMPANYSELECT 4"); }
   | expr NOT IN '(' select_stmt ')' { emit("CMPALLSELECT 3"); }
   | EXISTS '(' select_stmt ')'      { emit("EXISTSSELECT"); if($1)emit("NOT"); }
   ;

/*** Funkce ***/

expr: FAVG '(' expr ')' { emit("CALL 1 AVG"); }
   | FAVG '(' DISTINCT expr ')' { emit("CALL 2 AVG"); }
   ;

expr: FBIT_AND '(' expr ')'   { emit(" CALL 1 BIT_AND"); } 
   ;

expr: FBIT_OR '(' expr ')'   { emit(" CALL 1 BIT_OR"); } 
   ;

expr: FBIT_XOR '(' expr ')'   { emit(" CALL 1 BIT_XOR"); } 
   ;

expr: FCHAR '(' val_list ')'                    {  emit("CALL %d CHAR", $3); }
   | FCHAR '(' val_list USING NAME ')'          {  emit("CALL %d CHAR with USING %s", $3, $5); free($5); }

expr: FCHARSET '(' expr ')'   { emit(" CALL 1 FCHARSET"); } 
   ;

expr: FCONCAT '(' opt_val_list ')' {  emit("CALL %d CONCAT", $3); }
   ;

expr: FCOUNT '(' '*' ')' { emit("COUNTALL"); }
   | FCOUNT '(' expr ')' { emit(" CALL 1 COUNT"); } 
   ;

expr: FCURDATE '(' ')' { emit("CALL 0 CURDATE"); }
   ;

expr: FCURTIME '(' ')' { emit("CALL 0 CURTIME"); }
   ;

expr: FMAX '(' expr ')' { emit("CALL 1 MAX"); }
   | FMAX '(' DISTINCT expr ')' { emit("CALL 2 MAX"); }
   ;

expr: FMIN '(' expr ')' { emit("CALL 1 MIN"); }
   | FMIN '(' DISTINCT expr ')' { emit("CALL 2 MIN"); }
   ;

expr: FNOW '(' ')' { emit("CALL 0 NOW"); }
   ;

expr: FSUBSTRING '(' val_list ')'               {  emit("CALL %d SUBSTR", $3); }
   | FSUBSTRING '(' expr FROM expr ')'          {  emit("CALL 2 SUBSTR"); }
   | FSUBSTRING '(' expr FROM expr FOR expr ')' {  emit("CALL 3 SUBSTR"); }

   | FTRIM '(' val_list ')'                     { emit("CALL %d TRIM", $3); }
   | FTRIM '(' trim_ltb expr FROM val_list ')'  { emit("CALL 3 TRIM"); }
   ;

expr: FSUM '(' expr ')' { emit("CALL 1 SUM"); }
   | FSUM '(' DISTINCT expr ')' { emit("CALL 2 SUM"); }
   ;

expr: FTRUNCATE '(' expr ',' INT ')'                      { emit("CALL %d TRUNCATE", $5); }
   ;

trim_ltb: LEADING { emit("NUMBER 1"); }
   | TRAILING     { emit("NUMBER 2"); }
   | BOTH         { emit("NUMBER 3"); }
   ;

expr: FDATE_ADD '(' expr ',' expr ')' { emit("CALL 2 DATE_ADD"); }
   |  FDATE_ADD '(' expr ',' interval_exp ')' { emit("CALL 3 DATE_ADD"); }
   |  FDATE_SUB '(' expr ',' expr ')' { emit("CALL 2 DATE_SUB"); }
   |  FDATE_SUB '(' expr ',' interval_exp ')' { emit("CALL 3 DATE_SUB"); }
   ;

interval_exp: INTERVAL expr YEAR     { emit("INTERVAL YEAR"); }
   | INTERVAL expr QUARTER           { emit("INTERVAL QUARTER"); }
   | INTERVAL expr YEAR_MONTH        { emit("INTERVAL YEAR_MONTH"); }
   | INTERVAL expr MONTH             { emit("INTERVAL MONTH"); }
   | INTERVAL expr WEEK              { emit("INTERVAL WEEK"); }
   | INTERVAL expr DAY               { emit("INTERVAL DAY"); }
   | INTERVAL expr DAY_HOUR          { emit("INTERVAL DAY_HOUR"); }
   | INTERVAL expr DAY_MINUTE        { emit("INTERVAL DAY_MINUTE"); }
   | INTERVAL expr DAY_SECOND        { emit("INTERVAL DAY_SECOND"); }
   | INTERVAL expr DAY_MICROSECOND   { emit("INTERVAL DAY_MICROSECOND"); }
   | INTERVAL expr HOUR              { emit("INTERVAL HOUR"); }
   | INTERVAL expr HOUR_MINUTE       { emit("INTERVAL HOUR_MINUTE"); }
   | INTERVAL expr HOUR_SECOND       { emit("INTERVAL HOUR_SECOND"); }
   | INTERVAL expr HOUR_MICROSECOND  { emit("INTERVAL HOUR_MICROSECOND"); }
   | INTERVAL expr MINUTE            { emit("INTERVAL MINUTE"); }
   | INTERVAL expr SECOND            { emit("INTERVAL SECOND"); }
   | INTERVAL expr MINUTE_SECOND     { emit("INTERVAL MINUTE_SECOND"); }
   | INTERVAL expr MINUTE_MICROSECOND   { emit("INTERVAL MINUTE_MICROSECOND"); }
   | INTERVAL expr SECOND_MICROSECOND   { emit("INTERVAL SECOND_MICROSECOND"); }
   | INTERVAL expr MICROSECOND       { emit("INTERVAL MICROSECOND"); }
   ;

expr: CASE expr case_list END           { emit("CASEVAL %d 0", $3); }
   |  CASE expr case_list ELSE expr END { emit("CASEVAL %d 1", $3); }
   |  CASE case_list END                { emit("CASE %d 0", $2); }
   |  CASE case_list ELSE expr END      { emit("CASE %d 1", $2); }
   ;

case_list: WHEN expr THEN expr     { $$ = 1; }
         | case_list WHEN expr THEN expr { $$ = $1+1; } 
   ;

expr: expr LIKE expr { emit("LIKE"); }
   | expr NOT LIKE expr { emit("LIKE"); emit("NOT"); }
   ;

expr: expr REGEXP expr { emit("REGEXP"); }
   | expr NOT REGEXP expr { emit("REGEXP"); emit("NOT"); }
   ;

expr: CURRENT_TIMESTAMP { emit("NOW"); };
   | CURRENT_DATE       { emit("NOW"); };
   | CURRENT_TIME       { emit("NOW"); };
   ;

expr: BINARY expr %prec UMINUS { emit("STRTOBIN"); }
   ;

/********************************** SELECT ***********************************/

/*** union ***/


stmt: union_stmt { $$ = $1; }
   ;

union_stmt:
   select_stmt                                                              { $$ = 1; }
   | '(' select_stmt ')'                                                    { $$ = 1; }
   | union_stmt UNION union_opt select_stmt                                 { emit("UNION %d", $3); $$ = $1 + 1; }
   | union_stmt UNION union_opt '(' select_stmt ')' opt_orderby opt_limit   { emit("UNION %d", $3); $$ = $1 + 1; }
   ;

union_opt: /* nil */       { $$ = 0; }
   | ALL                   { $$ = 1; }
   | DISTINCT              { $$ = 2; }
   ;

/*** select table ***/


select_stmt: SELECT select_opts select_expr_list { emit("SELECTNODATA %d %d", $2, $3); };

    | SELECT select_opts select_expr_list 
     FROM table_references
     opt_where opt_groupby opt_having opt_orderby opt_limit { emit("SELECT %d %d %d", $2, $3, $5); };
   ;

opt_where: /* nil */ 
   | WHERE expr { emit("WHERE"); };

opt_groupby: /* nil */ 
   | GROUP BY groupby_list opt_with_rollup
                             { emit("GROUPBYLIST %d %d", $3, $4); }
   ;

groupby_list: expr opt_asc_desc
                             { emit("GROUPBY %d",  $2); $$ = 1; }
   | groupby_list ',' expr opt_asc_desc
                             { emit("GROUPBY %d",  $4); $$ = $1 + 1; }
   ;

opt_asc_desc: /* nil */ { $$ = 0; }
   | ASC                { $$ = 1; }
   | DESC               { $$ = 2; }
   | STRING             { if (strcmp($1, "***") != 0) {yyerror("Nepovolena volba ORDER BY"); free($1); YYERROR; } $$ = 3; }
    ;

opt_with_rollup: /* nil */  { $$ = 0; }
   | WITH ROLLUP  { $$ = 1; }
   ;

opt_having: /* nil */ 
   | HAVING expr { emit("HAVING"); };

opt_orderby: /* nil */ 
   | ORDER BY orderby_list { emit("ORDERBYLIST %d", $3); }
   ;

orderby_list: expr opt_asc_desc
                             { emit("ORDERBY %d",  $2); $$ = 1; }
   | orderby_list ',' expr opt_asc_desc
                             { emit("ORDERBY %d",  $4); $$ = $1 + 1; }
   ;

opt_limit: /* nil */
   | LIMIT expr                        { emit("LIMIT 1"); }
   | LIMIT expr ',' expr               { emit("LIMIT 2"); }
   | LIMIT expr OFFSET expr            { emit("LIMIT 3"); }
   ;

column_list: NAME { emit("COLUMN %s", $1); free($1); $$ = 1; }
   | column_list ',' NAME  { emit("COLUMN %s", $3); free($3); $$ = $1 + 1; }
   ;

select_opts:                          { $$ = 0; }
   | select_opts ALL                 
      { if($1 & 01) yyerror("Duplicitni volba ALL"); $$ = $1 | 01; }
   | select_opts DISTINCT            
      { if($1 & 02) yyerror("Duplicitni volba DISTINCT"); $$ = $1 | 02; }
   | select_opts DISTINCTROW         
      { if($1 & 04) yyerror("Duplicitni volba DISTINCTROW"); $$ = $1 | 04; }
   | select_opts HIGH_PRIORITY       
      { if($1 & 010) yyerror("Duplicitni volba HIGH_PRIORITY"); $$ = $1 | 010; }
   | select_opts STRAIGHT_JOIN       
      { if($1 & 020) yyerror("Duplicitni volba STRAIGHT_JOIN"); $$ = $1 | 020; }
   | select_opts SQL_SMALL_RESULT    
      { if($1 & 040) yyerror("Duplicitni volba SQL_SMALL_RESULT"); $$ = $1 | 040; }
   | select_opts SQL_BIG_RESULT      
      { if($1 & 0100) yyerror("Duplicitni volba SQL_BIG_RESULT"); $$ = $1 | 0100; }
   | select_opts SQL_BUFFER_RESULT     
      { if($1 & 0200) yyerror("Duplicitni volba SQL_BUFFER_RESULT"); $$ = $1 | 0200; }
   | select_opts SQL_CACHE      
      { if($1 & 0400) yyerror("Duplicitni volba SQL_CACHE"); $$ = $1 | 0400; }
   | select_opts SQL_NO_CACHE      
      { if($1 & 01000) yyerror("Duplicitni volba SQL_NO_CACHE"); $$ = $1 | 01000; }
   | select_opts SQL_CALC_FOUND_ROWS 
      { if($1 & 02000) yyerror("Duplicitni volba SQL_CALC_FOUND_ROWS"); $$ = $1 | 02000; }
   ;

select_expr_list: select_expr { $$ = 1; }
    | select_expr_list ',' select_expr {$$ = $1 + 1; }
    | '*' { emit("SELECTALL"); $$ = 1; }
    ;

select_expr: expr opt_as_alias ;

opt_as_alias: AS NAME { emit ("ALIAS %s", $2); free($2); }
   | NAME              { emit ("ALIAS %s", $1); free($1); }
   | /* nil */
   ;
  
table_references:    table_reference { $$ = 1; }
   | table_references ',' table_reference { $$ = $1 + 1; }
   ;

table_reference:  table_factor
   | join_table
   ;

table_factor:
    NAME opt_as_alias index_hint_list { emit("TABLE %s", $1); free($1); }
   | NAME '.' NAME opt_as_alias index_hint_list { emit("TABLE %s.%s", $1, $3);
                               free($1); free($3); }
   | NAME '.' TABLES { emit("TABLE %s.tables", $1); free($1); }
   | table_subquery opt_as NAME { emit("SUBQUERYAS %s", $3); free($3); }
   | '(' table_references ')' { emit("TABLEREFERENCES %d", $2); }
   ;

opt_as: /* nil */    { $$ = 0; }
   | AS              { $$ = 1; }
   ;

join_table:
    table_reference opt_inner_cross JOIN table_factor opt_join_condition
                  { emit("JOIN %d", 100+$2); }
   | table_reference STRAIGHT_JOIN table_factor
                  { emit("JOIN %d", 200); }
   | table_reference STRAIGHT_JOIN table_factor ON expr
                  { emit("JOIN %d", 200); }
   | table_reference STRAIGHT_JOIN table_factor ON '(' expr ')'
                  { emit("JOIN %d", 200); }
   | table_reference left_or_right opt_outer JOIN table_factor join_condition
                  { emit("JOIN %d", 300+$2+$3); }
   | table_reference NATURAL opt_left_or_right_outer JOIN table_factor
                  { emit("JOIN %d", 400+$3); }
   ;

opt_inner_cross: /* nil */ { $$ = 0; }
   | INNER { $$ = 1; }
   | CROSS  { $$ = 2; }
   ;

opt_outer: /* nil */  { $$ = 0; }
   | OUTER {$$ = 4; }
   ;

left_or_right: LEFT { $$ = 1; }
    | RIGHT { $$ = 2; }
    ;

opt_left_or_right_outer: LEFT opt_outer { $$ = 1 + $2; }
   | RIGHT opt_outer  { $$ = 2 + $2; }
   | /* nil */ { $$ = 0; }
   ;

opt_join_condition: /* nil */
   | join_condition ;

join_condition:
    ON expr                      { emit("ONEXPR"); }
   | ON '(' expr ')'             { emit("ONEXPR"); }
   | USING '(' column_list ')'   { emit("USING %d", $3); }
   ;

index_hint_list:
   | index_hint index_hint_list
   ;

index_hint:
    USE opt_key opt_for '(' index_list ')'
                  { emit("INDEXHINT USE %d", $5); }
   | USE opt_key opt_for '(' ')'
                  { emit("INDEXHINT USE EMPTY"); }
   | IGNORE opt_key opt_for '(' index_list ')'
                  { emit("INDEXHINT IGNORE %d", $5); }
   | FORCE opt_key opt_for '(' index_list ')'
                  { emit("INDEXHINT FORCE %d", $5); }
   ;

opt_key:
    KEY
   | INDEX
   ;

opt_for: 
   | FOR JOIN               { emit("FOR JOIN"); }
   | FOR ORDER BY           { emit("FOR ORDER BY"); }
   | FOR GROUP BY           { emit("FOR GROUP BY"); }
   ;

index_list: NAME  { emit("INDEX %s", $1); free($1); $$ = 1; }
   | index_list ',' NAME { emit("INDEX %s", $3); free($3); $$ = $1 + 1; }
   ;

table_subquery: '(' select_stmt ')' { emit("SUBQUERY"); }
   ;

/********************************** INSERT ***********************************/

/*** insert statement ***/

stmt: insert_stmt { $$ = 1; }
   ;

insert_stmt: INSERT insert_opts opt_into NAME
     opt_col_names
     opt_val insert_vals_list
     opt_ondupupdate { emit("TABLE %s;INSERT VALS %d %d", $4, $2, $7); free($4); }
   ;

opt_ondupupdate: /* nil */
   | ONDUPLICATE KEY UPDATE insert_asgn_list { emit("DUPUPDATE %d", $4); }
   ;

insert_opts: /* nil */ { $$ = 0; }
   | insert_opts LOW_PRIORITY { $$ = $1 | 01 ; }
   | insert_opts DELAYED { $$ = $1 | 02 ; }
   | insert_opts HIGH_PRIORITY { $$ = $1 | 04 ; }
   | insert_opts IGNORE { $$ = $1 | 010 ; }
   ;

opt_into: INTO | /* nil */
   ;

opt_val: 
     VALUE 
   | VALUES
   ;

opt_col_names: /* nil */
   | '(' column_list ')' { emit("INSERTCOLS %d", $2); }
   ;

insert_vals_list: '(' insert_vals ')' { emit("VALUES %d", $2); $$ = 1; }
   | insert_vals_list ',' '(' insert_vals ')' { emit("VALUES %d", $4); $$ = $1 + 1; }

insert_vals:
     expr { $$ = 1; }
   | DEFAULT { emit("DEFAULT"); $$ = 1; }
   | insert_vals ',' expr { $$ = $1 + 1; }
   | insert_vals ',' DEFAULT { emit("DEFAULT"); $$ = $1 + 1; }
   ;

insert_stmt: INSERT insert_opts opt_into NAME
    SET insert_asgn_list
    opt_ondupupdate
     { emit("TABLE %s;INSERT ASGN %d %d", $4, $2, $6); free($4); }
   ;

insert_asgn_list:
     NAME COMPARISON expr 
       { if ($2 != 4) { yyerror("Nespravne prirazeni pro %s", $1); YYERROR; }
       emit("ASSIGN %s", $1); free($1); $$ = 1; }
   | NAME COMPARISON DEFAULT
       { if ($2 != 4) { yyerror("Nespravne prirazeni pro %s", $1); YYERROR; }
                 emit("DEFAULT"); emit("ASSIGN %s", $1); free($1); $$ = 1; }
   | insert_asgn_list ',' NAME COMPARISON expr
       { if ($4 != 4) { yyerror("Nespravne prirazeni pro %s", $3); YYERROR; }
                 emit("ASSIGN %s", $3); free($3); $$ = $1 + 1; }
   | insert_asgn_list ',' NAME COMPARISON DEFAULT
       { if ($4 != 4) { yyerror("Nespravne prirazeni pro %s", $3); YYERROR; }
                 emit("DEFAULT"); emit("ASSIGN %s", $3); free($3); $$ = $1 + 1; }
   |  NAME '.' NAME COMPARISON expr 
       { if ($4 != 4) { yyerror("Nespravne prirazeni pro %s.%s", $1, $3); YYERROR; }
       emit("ASSIGN %s.%s", $1, $3); free($1); free($3); $$ = 1; }
   | NAME '.' NAME COMPARISON DEFAULT
       { if ($4 != 4) { yyerror("Nespravne prirazeni pro %s.%s", $1, $3); YYERROR; }
       emit("DEFAULT;ASSIGN %s.%s", $1, $3); free($1); free($3); $$ = 1; }
   | insert_asgn_list ',' NAME '.' NAME COMPARISON expr
       { if ($6 != 4) { yyerror("Nespravne prirazeni pro %s.%s", $3, $5); YYERROR; }
                 emit("ASSIGN %s.%s", $3, $5); free($3); free($5); $$ = $1 + 1; }
   | insert_asgn_list ',' NAME '.' NAME  COMPARISON DEFAULT
       { if ($6 != 4) { yyerror("Nespravne prirazeni pro %s.%s", $3, $5); YYERROR; }
                 emit("DEFAULT;ASSIGN %s.%s", $3, $5); free($3); free($5); $$ = $1 + 1; }
   ;
   
insert_stmt: INSERT insert_opts opt_into NAME opt_col_names
    select_stmt
    opt_ondupupdate { emit("TABLE %s;INSERT SELECT %d", $4, $2); free($4); }
  ;

/********************************** REPLACE **********************************/

/*** replace statement ***/

stmt: replace_stmt { $$ = 1; }
   ;

replace_stmt: REPLACE replace_opts opt_into NAME
     opt_col_names
     opt_val insert_vals_list
     opt_ondupupdate { emit("TABLE %s;REPLACE VALS %d %d", $4, $2, $7); free($4); }
   ;

replace_opts: /* nil */       { $$ = 0; }
   | LOW_PRIORITY             { $$ = 1; }
   | DELAYED                  { $$ = 2; }
   ;

replace_stmt: REPLACE replace_opts opt_into NAME
    SET insert_asgn_list
    opt_ondupupdate
     { emit("TABLE %s;REPLACE ASGN %d %d", $4, $2, $6); free($4); }
   ;

replace_stmt: REPLACE replace_opts opt_into NAME opt_col_names
    select_stmt
    opt_ondupupdate { emit("TABLE %s;REPLACE SELECT %d", $4, $2); free($4); }
  ;
  
/********************************** UPDATE ***********************************/

/*** update statement ***/

stmt: update_stmt { $$ = 1; }
   ;

/* single table update */
update_stmt: UPDATE update_opts NAME
    SET update_asgn_list
    opt_where opt_orderby opt_limit
                  { emit("TABLE %s;UPDATE ONE %d", $3, $2); free($3); }
;

update_opts: /* nil */ { $$ = 0; }
   | update_opts LOW_PRIORITY { $$ = $1 | 01 ; }
   | update_opts IGNORE { $$ = $1 | 02 ; }
   ;

/* multitable update */
update_stmt: UPDATE update_opts table_reference ',' table_references
    SET update_asgn_list opt_where
                     { emit("UPDATE MULTI %d %d %d", $2, $5+1, $7); }

update_asgn_list:
     NAME COMPARISON DEFAULT 
     { if ($2 != 4) { yyerror("Nespravne prirazeni pro %s", $1); YYERROR; }
     emit("DEFAULT;ASSIGN %s", $1); free($1); $$ = 1; }
   |  NAME COMPARISON expr 
     { if ($2 != 4) { yyerror("Nespravne prirazeni pro %s", $1); YYERROR; }
     emit("ASSIGN %s", $1); free($1); $$ = 1; }
   | NAME '.' NAME COMPARISON expr 
       { if ($4 != 4) { yyerror("Nespravne prirazeni pro %s", $1); YYERROR; }
     emit("ASSIGN %s.%s", $1, $3); free($1); free($3); $$ = 1; }
   | update_asgn_list ',' NAME COMPARISON expr
       { if ($4 != 4) { yyerror("Nespravne prirazeni pro %s", $3); YYERROR; }
     emit("ASSIGN %s", $3); free($3); $$ = $1 + 1; }
   | update_asgn_list ',' NAME '.' NAME COMPARISON expr
       { if ($6 != 4) { yyerror("Nespravne prirazeni pro %s.$s", $3, $5); 
          YYERROR; }
         emit("ASSIGN %s.%s", $3, $5); free($3); free($5); $$ = 1; }
   | NAME '.' NAME COMPARISON DEFAULT 
       { if ($4 != 4) { yyerror("Nespravne prirazeni pro %s", $1); YYERROR; }
     emit("DEFAULT;ASSIGN %s.%s", $1, $3); free($1); free($3); $$ = 1; }
   | update_asgn_list ',' NAME COMPARISON DEFAULT
       { if ($4 != 4) { yyerror("Nespravne prirazeni pro %s", $3); YYERROR; }
     emit("DEFAULT;ASSIGN %s", $3); free($3); $$ = $1 + 1; }
   | update_asgn_list ',' NAME '.' NAME COMPARISON DEFAULT
       { if ($6 != 4) { yyerror("Nespravne prirazeni pro %s.$s", $3, $5); 
          YYERROR; }
         emit("DEFAULT;ASSIGN %s.%s", $3, $5); free($3); free($5); $$ = 1; }
   ;

/********************************** CREATE ***********************************/

/*** create database ***/

stmt: create_database_stmt { $$ = 1; }
   ;

create_database_stmt: 
     CREATE opt_replace DATABASE opt_if_not_exists NAME create_specification
       { emit("DATABASE %s;CREATE %d %d", $5, $2, $4); free($5); }
   | CREATE opt_replace SCHEMA opt_if_not_exists NAME create_specification
       { emit("DATABASE %s;CREATEDATABASE %d %d", $5, $2, $4); free($5); }
   ;

opt_replace:  /* nil */ { $$ = 0; }
   | OR REPLACE { $$ = 1; }
   ;

opt_if_not_exists:  /* nil */ { $$ = 0; }
   | IF EXISTS           
       { if(!$2) { yyerror("Chybi NOT v IF NOT EXISTS"); YYERROR; }
                        $$ = $2; }
   ;

create_specification: /* nil */
   | create_specification opt_default CHAR SET opt_eq STRING { emit("STRING '***';CHARACTER SET %d %d", $2, $5); free($6); }
   | create_specification opt_default COLLATE opt_eq STRING { emit("STRING '***';COLLATE %d %d", $2, $4); free($5); }
   ;

opt_default: /* nil */ { $$ = 0; }
   | DEFAULT   { $$ = 1; }
   ;

opt_eq: /* nil */ { $$ = 0; }
   | COMPARISON { if($1 != 4) { yyerror("Zde musi byt '='"); YYERROR; $$ = 1; }}
   ;

/*** create table ***/
stmt: create_table_stmt { $$ = 1; }
   ;

create_table_stmt: CREATE opt_replace opt_temporary TABLE opt_if_not_exists tbl_name
   '(' create_col_list ')' { emit("CREATE %d %d %d %d", $2, $3, $5, $8); }
   ;

create_table_stmt: CREATE opt_replace opt_temporary TABLE opt_if_not_exists tbl_name
   '(' create_col_list ')'
    create_select_statement { emit("CREATE SELECT %d %d %d %d", $2, $3, $5, $8); }
    ;

create_table_stmt: CREATE opt_replace opt_temporary TABLE opt_if_not_exists tbl_name
   create_select_statement { emit("CREATE SELECT %d %d %d 0", $2, $3, $5); }
    ;

create_table_stmt: CREATE opt_replace opt_temporary TABLE opt_if_not_exists tbl_name
   LIKE tbl_name { emit("CREATE LIKE %d %d %d 0", $2, $3, $5); }
    ;

create_table_stmt: CREATE opt_replace opt_temporary TABLE opt_if_not_exists tbl_name
   '(' LIKE tbl_name ')' { emit("CREATE LIKE %d %d %d 0", $2, $3, $5); }
    ;

tbl_name: NAME          { emit("TABLE %s", $1); free($1); }
   | NAME '.' NAME      { emit("TABLE %s.%s", $1, $3); free($1); free($3); }
   ;

opt_temporary:   /* nil */ { $$ = 0; }
   | TEMPORARY { $$ = 1;}
   ;
   
create_col_list: create_definition { $$ = 1; }
    | create_col_list ',' create_definition { $$ = $1 + 1; }
    ;

create_definition: PRIMARY KEY '(' column_list ')'    { emit("PRIKEY %d", $4); }
    | KEY '(' column_list ')'            { emit("KEY %d", $3); }
    | INDEX '(' column_list ')'          { emit("KEY %d", $3); }
    | FULLTEXT INDEX '(' column_list ')' { emit("TEXTINDEX %d", $4); }
    | FULLTEXT KEY '(' column_list ')'   { emit("TEXTINDEX %d", $4); }
    ;
    
create_definition: NAME data_type column_atts { emit("COLUMN %d %s", $2, $1); free($1); }
   ;

column_atts: /* nil */ { $$ = 0; }
    | column_atts NOT NULLX             { emit("ATTR NOTNULL"); $$ = $1 + 1; }
    | column_atts NULLX
    | column_atts DEFAULT STRING        
        { emit("STRING '***';ATTR DEFAULT"); free($3); $$ = $1 + 1; }
    | column_atts DEFAULT INT       
        { emit("ATTR DEFAULT NUMBER %d", $3); $$ = $1 + 1; }
    | column_atts DEFAULT FLOAT     
        { emit("ATTR DEFAULT FLOAT %g", $3); $$ = $1 + 1; }
    | column_atts DEFAULT BOOL          
        { emit("ATTR DEFAULT BOOL %d", $3); $$ = $1 + 1; }
    | column_atts AUTO_INCREMENT        
        { emit("ATTR AUTOINC"); $$ = $1 + 1; }
    | column_atts UNIQUE '(' column_list ')' 
        { emit("ATTR UNIQUEKEY %d", $4); $$ = $1 + 1; }
    | column_atts UNIQUE KEY { emit("ATTR UNIQUEKEY"); $$ = $1 + 1; }
    | column_atts PRIMARY KEY { emit("ATTR PRIKEY"); $$ = $1 + 1; }
    | column_atts KEY { emit("ATTR PRIKEY"); $$ = $1 + 1; }
    | column_atts COMMENT STRING 
        { emit("STRING '***';ATTR COMMENT"); free($3); $$ = $1 + 1; }
    ;
    
opt_length: /* nil */ { $$ = 0; }
   | '(' INT ')' { $$ = $2; }
   | '(' INT ',' INT ')' { $$ = $2 + 1000*$4; }
   ;

opt_binary: /* nil */ { $$ = 0; }
   | BINARY { $$ = 4000; }
   ;

opt_uz: /* nil */ { $$ = 0; }
   | opt_uz UNSIGNED { $$ = $1 | 1000; }
   | opt_uz ZEROFILL { $$ = $1 | 2000; }
   ;

opt_csc: /* nil */
   | opt_csc CHAR SET STRING { emit("STRING '***';COLCHARSET"); free($4); }
   | opt_csc COLLATE STRING { emit("STRING '***';COLCOLLATE"); free($3); }
   ;

data_type:
     BIT opt_length { $$ = 10000 + $2; }
   | TINYINT opt_length opt_uz { $$ = 10000 + $2; }
   | SMALLINT opt_length opt_uz { $$ = 20000 + $2 + $3; }
   | MEDIUMINT opt_length opt_uz { $$ = 30000 + $2 + $3; }
   | INT opt_length opt_uz { $$ = 40000 + $2 + $3; }
   | INTEGER opt_length opt_uz { $$ = 50000 + $2 + $3; }
   | BIGINT opt_length opt_uz { $$ = 60000 + $2 + $3; }
   | REAL opt_length opt_uz { $$ = 70000 + $2 + $3; }
   | DOUBLE opt_length opt_uz { $$ = 80000 + $2 + $3; }
   | FLOAT opt_length opt_uz { $$ = 90000 + $2 + $3; }
   | DECIMAL opt_length opt_uz { $$ = 110000 + $2 + $3; }
   | DATE { $$ = 100001; }
   | TIME { $$ = 100002; }
   | TIMESTAMP { $$ = 100003; }
   | DATETIME { $$ = 100004; }
   | YEAR { $$ = 100005; }
   | CHAR opt_length opt_csc { $$ = 120000 + $2; }
   | VARCHAR '(' INT ')' opt_csc { $$ = 130000 + $3; }
   | BINARY opt_length { $$ = 140000 + $2; }
   | VARBINARY '(' INT ')' { $$ = 150000 + $3; }
   | TINYBLOB { $$ = 160001; }
   | BLOB { $$ = 160002; }
   | MEDIUMBLOB { $$ = 160003; }
   | LONGBLOB { $$ = 160004; }
   | TINYTEXT opt_binary opt_csc { $$ = 170000 + $2; }
   | TEXT opt_binary opt_csc { $$ = 171000 + $2; }
   | MEDIUMTEXT opt_binary opt_csc { $$ = 172000 + $2; }
   | LONGTEXT opt_binary opt_csc { $$ = 173000 + $2; }
   | ENUM '(' enum_list ')' opt_csc { $$ = 200000 + $3; }
   | SET '(' enum_list ')' opt_csc { $$ = 210000 + $3; }
   ;

enum_list: STRING { emit("STRING '***';ENUMVAL"); free($1); $$ = 1; }
   | enum_list ',' STRING { emit("STRING '***';ENUMVAL"); free($3); $$ = $1 + 1; }
   ;
   
   create_select_statement: opt_ignore_replace opt_as select_stmt { emit("OPTSELECT %d %d", $1, $2); }
   ;

opt_ignore_replace: /* nil */ { $$ = 0; }
   | IGNORE { $$ = 1; }
   | REPLACE { $$ = 2; }
   ;

/*********************************** ALTER ***********************************/

/*** alter database ***/
stmt: alter_stmt { $$ = 1; }
   ;

alter_stmt: 
   ALTER DATABASE create_specification                   { emit("DATABASE THIS;ALTER DATABASE"); }
   | ALTER SCHEMA create_specification                   { emit("DATABASE THIS;ALTER DATABASE"); }
   | ALTER DATABASE NAME create_specification            { emit("DATABASE %s;ALTER DATABASE", $3); free($3); }
   | ALTER SCHEMA NAME create_specification              { emit("DATABASE %s;ALTER DATABASE", $3); free($3); }
   | ALTER DATABASE NAME UPGRADE DATA DIRECTORY NAME     { emit("DATABASE %s;ALTER DATABASE UPGRADE", $3); free($3); }
   | ALTER SCHEMA NAME UPGRADE DATA DIRECTORY NAME       { emit("DATABASE %s;ALTER DATABASE UPGRADE", $3); free($3); }
   ;

/*********************************** DROP ************************************/

/*** drop database ***/
stmt: drop_stmt { $$ = 1; }
   ;

drop_stmt: DROP DATABASE NAME { emit("DATABASE %s;DROP 0", $3); free($3); }
   | DROP SCHEMA NAME { emit("DATABASE %s;DROP 0", $3); free($3); }
   | DROP DATABASE IF EXISTS NAME { emit("DATABASE %s;DROP 1", $5); free($5); }
   | DROP SCHEMA IF EXISTS NAME { emit("DATABASE %s;DROP 1", $5); free($5); }
   ;

/********************************** DELETE ***********************************/

/*** drop table ***/

stmt: drop_table_stmt { $$ = 1; }
   ;

drop_table_stmt: DROP opt_temporary TABLE table_references opt_wait opt_drop    { emit("DROPTABLE %d 0 %d %d", $2, $4, $5); }
   | DROP opt_temporary TABLE IF EXISTS table_references opt_wait opt_drop      { emit("DROPTABLE %d 1 %d %d", $2, $7, $8); }
   ;

opt_drop: /* nil */ { $$ = 0; }
   | RESTRICT       { $$ = 1; }
   | CASCADE        { $$ = 2; }
   ;

/*** truncate table ***/
stmt: truncate_stmt { $$ = 1; }
   ;

truncate_stmt: TRUNCATE NAME opt_wait { emit("TABLE %s;TRUNCATE %d", $2, $3); free($2); }
   | TRUNCATE TABLE NAME opt_wait { emit("TABLE %s;TRUNCATE %d", $3, $4); free($3); }
   ;

opt_wait: /* nil */      { $$ = 0; }
   | WAIT INT  { $$ = $2; }
   | NOWAIT    { $$ = 0; }
   ;

/*** delete statement ***/

stmt: delete_stmt { $$ = 1; }
   ;

/* single table delete */
delete_stmt: DELETE delete_opts FROM NAME
    opt_where opt_orderby opt_limit
                  { emit("TABLE %s;DELETE ONE %d", $4, $2); free($4); }
;

delete_opts: delete_opts LOW_PRIORITY { $$ = $1 + 01; }
   | delete_opts QUICK { $$ = $1 + 02; }
   | delete_opts IGNORE { $$ = $1 + 04; }
   | /* nil */ { $$ = 0; }
   ;

/* multitable delete, first version */
delete_stmt: DELETE delete_opts
    delete_list
    FROM table_references opt_where
            { emit("DELETE MULTI %d %d %d", $2, $3, $5); }

delete_list: NAME opt_dot_star { emit("TABLE %s", $1); free($1); $$ = 1; }
   | delete_list ',' NAME opt_dot_star
            { emit("TABLE %s", $3); free($3); $$ = $1 + 1; }
   ;

opt_dot_star: /* nil */ | '.' '*' ;

/* multitable delete, second version */
delete_stmt: DELETE delete_opts
    FROM delete_list
    USING table_references opt_where
            { emit("DELETE MULTI %d %d %d", $2, $4, $6); }
;

/*********************************** ++++ ************************************/
/*** show database ***/

stmt: show_database_stmt { $$ = 1; }
   ;

show_database_stmt: 
   SHOW DATABASES opt_show             { emit("SHOW DATABASES"); }
   | SHOW SCHEMAS opt_show             { emit("SHOW DATABASES"); }

opt_show:
   | LIKE STRING                       { emit("STRING '***';LIKE"); free($2); }
   | WHERE expr                       { emit("WHERE"); }
   ;

/*** show tables ***/

stmt: show_tables_stmt { $$ = 1; }

show_tables_stmt:
   SHOW opt_full TABLES opt_from opt_show { emit("SHOW TABLES %d", $2); }
   ;

opt_full: /* nil */ { $$ = 0; }
   | FULL { $$ = 1; }
   ;

opt_from:
   | FROM NAME             { emit("FROM %s", $2); free($2); }
   ;

/*** describe ***/

stmt: describe_stmt { $$ = 1; }
   ;

describe_stmt: 
   DESCRIBE NAME              { emit("TABLE %s;DESCRIBE", $2); free($2); }
   | DESC NAME                { emit("TABLE %s;DESCRIBE", $2); free($2); }
   | DESCRIBE NAME NAME       { emit("TABLE %s;COLUMN %s;DESCRIBE", $2, $3); free($2); free($3); }
   | DESC NAME NAME           { emit("TABLE %s;COLUMN %s;DESCRIBE", $2, $3); free($2); free($3); }
   ;

/*** use database ***/

stmt: use_stmt { $$ = 1; }

use_stmt: USE NAME            { emit("DATABASE %s;USE", $2); free($2); }
   ;

/**** set user variables ****/

stmt: set_stmt { $$ = 1; }
   ;

set_stmt: SET set_list ;

set_list: set_expr | set_list ',' set_expr ;

set_expr:
      USERVAR COMPARISON expr { if ($2 != 4) { yyerror("Zde musi byt '=' pro @%s", $1); YYERROR; }
                 emit("SET %s", $1); free($1); }
    | USERVAR ASSIGN expr { emit("SET %s", $1); free($1); }
    ;

%%

string my_parse(const char *s)
{
   parse_result = "";
   YY_BUFFER_STATE buffer;
   buffer = yy_scan_string(s);
   int ret = yyparse(); 
   yy_delete_buffer(buffer);
   if (ret)
   {
      cout << "Nespravny SQL dotaz!" << endl;
      parse_result += "1;";
   }
   else
   {
      parse_result += to_string(counter_stmt);
      parse_result += ";";
      parse_result += "0;";
   }
   return parse_result;
}

void yyerror(const char *s, ...)
{
   va_list ap;
   va_start(ap, s);

   fprintf(stderr, "%d: error: ", yylineno);
   vfprintf(stderr, s, ap);
   fprintf(stderr, "\n");; 
}

void emit(const char *s, ...)
{
   va_list ap;
   va_start(ap, s);

   char buf[256];
   vsprintf(buf, s, ap);
   parse_result += buf;
   parse_result += ";";
}
