%{
	#include <math.h>
	#include <stdio.h>
	#include <stdlib.h>
	#include "cgen.h"
	#include "myparser.tab.h"

	extern int yylex(void);
	extern int lineNum;
%}

%union
{
	char* str;
}

%define parse.trace
%define parse.error verbose //enhanced error messages
%debug

%token <str> TK_EOF "end of file (EOF)"
%token <str> KW_BOOLEAN "keyword: boolean"
%token <str> KW_INTEGER "keyword: integer"
%token <str> KW_CHAR "keyword: character"
%token <str> KW_REAL "keyword: real"
%token <str> KW_TRUE "keyword: true"
%token <str> KW_FALSE "keyword: false"
%token <str> KW_STRING "keyword: string"
%token <str> KW_VOID "keyword: void"
%token <str> KW_WHILE "keyword: while"
%token <str> KW_DO "keyword: do"
%token <str> KW_BREAK "keyword: break"
%token <str> KW_CONTINUE "keyword: continue"
%token <str> KW_RETURN "keyword: return"
%token <str> KW_BEGIN "keyword: begin"
%token <str> KW_IF "keyword: if"
%token <str> KW_ELSE "keyword: else"
%token <str> KW_FOR "keyword: for"
%token <str> KW_END "keyword: end"
%token <str> KW_OR "keyword: or"
%token <str> KW_NOT "keyword: not"
%token <str> KW_AND "keyword: and"
%token <str> KW_MOD "keyword: mod"
%token <str> KW_STATIC "keyword: static"
%token <str> TK_ID "identifier"
%token <str> TK_INT "integer"
%token <str> TK_REAL "real number"
%token <str> TK_ASSGN "operator: assignment"// :=
%token <str> TK_LESSEQ "comparator: less or equal" // <=
%token <str> TK_GREQ "comparator: greater or equal" // >=
%token <str> TK_NEQ "comparator: not equal" // !=
%token <str> TK_AND "operator: AND" // &&
%token <str> TK_OR "operator: OR" // ||
%token <str> TK_LINE_FEED "line feed" // \n
%token <str> TK_TAB "tab" // \t
%token <str> TK_RETURN "return" // \r
%token <str> TK_BACKSLASH "backslash" // \\ 
%token <str> TK_SINGLE_QUOTE "single quote" // \' 
%token <str> TK_DOUBLE_QUOTE "double quote" // \"
%token <str> TK_CONST_CHAR "constant character" // 'a'
%token <str> TK_STRING "string"

%start input

/*
	global declaration:
	the first declaration of the program, 
	it could be a variables declaration 
	or a function declaration
*/
%type <str> global_declaration 
%type <str> variables_declaration
%type <str> functions_declaration
%type <str> arguments_declaration
%type <str> data_type
%type <str>	static
%type <str> variables_list
%type <str> arguments
%type <str> array_dimensions
%type <str> body
%type <str> block
%type <str> statement
%type <str> if_statement
%type <str> while_loop
%type <str>	for_loop
%type <str> do_while_loop
%type <str> expression
%type <str>	arithmetic_expression

%right "simple_if" KW_ELSE
%right ',' //used in recursively created lists
%left KW_OR TK_OR
%left KW_AND TK_AND 
%left '<' '>' '=' TK_NEQ TK_LESSEQ TK_GREQ
%left '-' '+' 
%left '*' '/' KW_MOD 
%left "negative"

%%

input:
	global_declaration
{
	if (yyerror_count == 0) {
		printf("-------\nExpression evaluates to:\n-------\n" );
		puts(c_prologue);
		printf("%s\n", $1); 
	}
}
;

global_declaration:
/*
	FIRST FUNCTION DECLARATION (BELOW):
	we can't have any global variables declaration
	from now on, so the next thing that follows must 
	be only function declarations
*/
	data_type TK_ID '(' arguments_declaration ')' block functions_declaration { $$ = template("%s %s ( %s ) %s %s", $1, $2, $4, $6, $7); }
/*
	GLOBAL VARIABLES DECLARATION (BELOW): 
	when done check if there is another variables 
	declaration or the first function declaration
*/
|	data_type TK_ID array_dimensions ';' global_declaration { $$ = template("%s %s %s;\n %s", $1, $2, $3, $5); }
|	data_type TK_ID array_dimensions TK_ASSGN expression ';'  global_declaration
{ $$ = template("%s %s %s = %s;\n %s", $1, $2, $3, $5, $7); }
|	data_type TK_ID array_dimensions ',' variables_list ';' global_declaration
{ $$ = template("%s %s %s, %s;\n %s", $1, $2, $3, $5, $7); }
|	data_type TK_ID array_dimensions TK_ASSGN expression ',' variables_list ';'  global_declaration
{ $$ = template("%s %s %s = %s, %s;\n %s", $1, $2, $3, $5, $7, $9); }
;

variables_declaration:
	data_type variables_list ';' { $$ = template("%s %s;\n", $1, $2); }
;

variables_list:
	TK_ID array_dimensions { $$ = template("%s %s", $1, $2); }
|	TK_ID array_dimensions TK_ASSGN expression { $$ = template("%s %s = %s", $1, $2, $4); }
|	variables_list ',' variables_list { $$ = template("%s, %s", $1, $3); }
;

functions_declaration:
	%empty { $$ = template(""); }
|	functions_declaration data_type TK_ID '(' arguments_declaration ')' block { $$ = template("%s %s %s ( %s ) %s", $1, $2, $3, $5, $7); }
;

data_type:
	static KW_INTEGER { $$ = template("%s int", $1); }
|	static KW_BOOLEAN { $$ = template("%s bool", $1); }
|	static KW_CHAR { $$ = template("%s char", $1); }
|	static KW_REAL { $$ = template("%s double", $1); }
|	static KW_VOID { $$ = template("%s void", $1); }
|	static KW_STRING { $$ = template("%s char*", $1); }
;

static: 
	%empty { $$ = template(""); }
|	KW_STATIC { $$ = template("static"); }

arguments:
	expression { $$ = template("%s", $1); }
|	arguments ',' arguments { $$ = template("%s, %s", $1, $3); }
; 

arguments_declaration:
	%empty { $$ = template(""); }
|	data_type TK_ID array_dimensions { $$ = template("%s %s %s", $1, $2, $3); }
|	arguments_declaration ',' data_type TK_ID array_dimensions { $$ = template("%s, %s %s %s", $1, $3, $4, $5); }
;

array_dimensions:
	%empty { $$ = template(""); }
|	array_dimensions '[' arithmetic_expression ']' { $$ = template("%s [ %s ]", $1, $3); }
;

block:
	KW_BEGIN body KW_END { $$ = template("{\n%s}\n", $2); }
|	statement ';' { $$ = template("%s;\n", $1); }
|	if_statement { $$ = template("%s", $1); }
| 	while_loop { $$ = template("%s", $1); }
|	for_loop { $$ = template("%s", $1); }
|	do_while_loop { $$ = template("%s", $1); }
;

body:
	%empty { $$ = template(""); }
|	statement ';' body { $$ = template("%s;\n%s", $1, $3); }
|	variables_declaration body { $$ = template("%s %s", $1, $2); }
|	if_statement body { $$ = template("%s %s", $1, $2); }
|	while_loop body { $$ = template("%s %s", $1, $2); }
|	for_loop body { $$ = template("%s %s", $1, $2); }
|	do_while_loop body { $$ = template("%s %s", $1, $2); }
;

statement:
	%empty { $$ = template(""); }
|	TK_ID array_dimensions TK_ASSGN expression { $$ = template("%s %s = %s", $1, $2, $4); }
|	TK_ID '(' arguments ')' { $$ = template("%s ( %s )", $1, $3); }
|	TK_ID '(' ')' { $$ = template("%s ( )", $1); }  
|	KW_CONTINUE { $$ = template("%s", $1); }
|	KW_BREAK { $$ = template("%s", $1); }
|	KW_RETURN { $$ = template("%s", $1); }
|	KW_RETURN expression { $$ = template("%s %s", $1, $2); }
;

if_statement:
	KW_IF '(' expression ')' block { $$ = template("%s ( %s ) %s", $1, $3, $5); } %prec "simple_if"
|	KW_IF '(' expression ')' block KW_ELSE block { $$ = template("%s ( %s ) %s %s %s", $1, $3, $5, $6, $7); }
;

while_loop:
	KW_WHILE '(' expression ')' block { $$ = template("%s ( %s ) %s", $1, $3, $5); }
;

for_loop:
	KW_FOR '(' statement ';' expression ';' statement ')' block
	{ $$ = template("%s ( %s; %s; %s ) %s", $1, $3, $5, $7, $9); }
|	KW_FOR '(' statement ';' ';' statement ')' block
	{ $$ = template("%s ( %s; ; %s ) %s", $1, $3, $6, $8); }
;

do_while_loop:
	KW_DO block KW_WHILE '(' expression ')' ';' { $$ = template("%s %s %s ( %s );", $1, $2, $3, $5); }
	
expression:
	TK_ID array_dimensions { $$ = template("%s", $1); }
|	KW_NOT TK_ID array_dimensions { $$ = template("!%s %s", $2, $3); }
|	TK_ID '(' arguments ')' { $$ = template("%s ( %s )", $1, $3); } 
|	TK_ID '(' ')' { $$ = template("%s ( )", $1); } 
|	TK_INT { $$ = template("%s", $1); }
| 	TK_REAL { $$ = template("%s", $1); }
|	TK_STRING { $$ = template("%s", $1); }
|	TK_CONST_CHAR { $$ = template("%s", $1); }
|	KW_TRUE { $$ = template("%s", $1); }
|	KW_FALSE { $$ = template("%s", $1); }
|	'-' expression { $$ = template("-%s", $2); } %prec "negative"
| 	'(' expression ')' { $$ = template("(%s)", $2); }
| 	expression '+' expression { $$ = template("%s + %s", $1, $3); }
| 	expression '-' expression { $$ = template("%s - %s", $1, $3); }
| 	expression '*' expression { $$ = template("%s * %s", $1, $3); }
|	expression KW_MOD expression { $$ = template("%s %% %s", $1, $3); }
| 	expression '/' expression { $$ = template("%s / %s", $1, $3); }
|	expression '<' expression { $$ = template("%s < %s", $1, $3); }
|	expression '>' expression { $$ = template("%s > %s", $1, $3); }
|	expression '=' expression { $$ = template("%s == %s", $1, $3); }
|	expression TK_NEQ expression { $$ = template("%s != %s", $1, $3); }
|	expression TK_LESSEQ expression { $$ = template("%s <= %s", $1, $3); }
|	expression TK_GREQ expression { $$ = template("%s >= %s", $1, $3); }
|	expression KW_AND expression { $$ = template("%s AND %s", $1, $3); }
|	expression KW_OR expression { $$ = template("%s OR %s", $1, $3); }
|	expression TK_AND expression { $$ = template("%s && %s", $1, $3); }
|	expression TK_OR expression { $$ = template("%s || %s", $1, $3); }
;

arithmetic_expression:
	TK_ID array_dimensions { $$ = template("%s", $1); }
|	TK_ID '(' arguments ')' { $$ = template("%s ( %s )", $1, $3); } 
|	TK_ID '(' ')' { $$ = template("%s ( )", $1); } 
|	TK_INT { $$ = template("%s", $1); }
| 	TK_REAL { $$ = template("%s", $1); }
|	'-' arithmetic_expression { $$ = template("-%s", $2); } %prec "negative"
|	'(' arithmetic_expression ')' { $$ = template("(%s)", $2); }
| 	arithmetic_expression '+' arithmetic_expression { $$ = template("%s + %s", $1, $3); }
| 	arithmetic_expression '-' arithmetic_expression { $$ = template("%s - %s", $1, $3); }
| 	arithmetic_expression '*' arithmetic_expression { $$ = template("%s * %s", $1, $3); }
| 	arithmetic_expression '/' arithmetic_expression { $$ = template("%s / %s", $1, $3); }
|	arithmetic_expression KW_MOD arithmetic_expression { $$ = template("%s %% %s", $1, $3); }
;

%%
int main () {
	if ( yyparse() == 0 )
		printf("-------\nACCEPTED as syntactically correct!\n-------\n");
	else printf("\n");
}
