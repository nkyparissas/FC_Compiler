%{	
	#include <math.h>
	#include <stdio.h>
	#include <stdlib.h>
	#include "cgen.h"
	#include "myparser.tab.h"
	
	int lineNum = 1;
	extern char* yytext;
%}

ID				[a-zA-Z_][0-9a-zA-Z_]*
POSITIVE_INT	[0]|[1-9][0-9]*
POSITIVE_REAL	{POSITIVE_INT}"."[0-9]*([eE][+-]?{POSITIVE_INT})?
ESCAPE_SEQ		\\n|\\t|\\r|\\\\|\\\'|\\\"
CONSTANT_CHAR	\'({ESCAPE_SEQ}|[^\\^\'^\"])\'
STRING			\"({ESCAPE_SEQ}|[^\n])*\"

%%

static		{ printf("Line %d, keyword: static \n", lineNum); yylval.str = strdup(yytext); return KW_STATIC; }
boolean		{ printf("Line %d, keyword: boolean \n", lineNum); yylval.str = strdup(yytext); return KW_BOOLEAN; }
integer		{ printf("Line %d, keyword: integer \n", lineNum); yylval.str = strdup(yytext); return KW_INTEGER; }
character	{ printf("Line %d, keyword: char \n", lineNum); yylval.str = strdup(yytext); return KW_CHAR; }
real		{ printf("Line %d, keyword: real \n", lineNum); yylval.str = strdup(yytext); return KW_REAL; }
true		{ printf("Line %d, keyword: true \n", lineNum); yylval.str = strdup(yytext); return KW_TRUE; }
false		{ printf("Line %d, keyword: false \n", lineNum); yylval.str = strdup(yytext); return KW_FALSE; }
string		{ printf("Line %d, keyword: string \n", lineNum); yylval.str = strdup(yytext); return KW_STRING; }
void		{ printf("Line %d, keyword: void \n", lineNum); yylval.str = strdup(yytext); return KW_VOID; }
while		{ printf("Line %d, keyword: while \n", lineNum); yylval.str = strdup(yytext); return KW_WHILE; }
do			{ printf("Line %d, keyword: do \n", lineNum); yylval.str = strdup(yytext); return KW_DO; }
break		{ printf("Line %d, keyword: break \n", lineNum); yylval.str = strdup(yytext); return KW_BREAK; }
continue	{ printf("Line %d, keyword: continue \n", lineNum); yylval.str = strdup(yytext); return KW_CONTINUE; }
return		{ printf("Line %d, keyword: return \n", lineNum); yylval.str = strdup(yytext); return KW_RETURN; }
begin		{ printf("Line %d, keyword: begin \n", lineNum); yylval.str = strdup(yytext); return KW_BEGIN; }
if			{ printf("Line %d, keyword: if \n", lineNum); yylval.str = strdup(yytext); return KW_IF; }
else		{ printf("Line %d, keyword: else \n", lineNum); yylval.str = strdup(yytext); return KW_ELSE; }
for			{ printf("Line %d, keyword: for \n", lineNum); yylval.str = strdup(yytext); return KW_FOR; }
end			{ printf("Line %d, keyword: end \n", lineNum); yylval.str = strdup(yytext); return KW_END; }
or			{ printf("Line %d, keyword: or \n", lineNum); yylval.str = strdup(yytext); return KW_OR; }
not			{ printf("Line %d, keyword: not \n", lineNum); yylval.str = strdup(yytext); return KW_NOT; }
and			{ printf("Line %d, keyword: and \n", lineNum); yylval.str = strdup(yytext); return KW_AND; }
mod			{ printf("Line %d, keyword: mod \n", lineNum); yylval.str = strdup(yytext); return KW_MOD; }
 
{ID}			{ printf("Line %d, identifier \n", lineNum); yylval.str = strdup(yytext); return TK_ID; }
{POSITIVE_INT}	{ printf("Line %d, positive integer \n", lineNum); yylval.str = strdup(yytext); return TK_INT; }
{POSITIVE_REAL}	{ printf("Line %d, positive real number \n", lineNum); yylval.str = strdup(yytext); return TK_REAL; }
{CONSTANT_CHAR}	{ printf("Line %d, constant character \n", lineNum); yylval.str = strdup(yytext); return TK_CONST_CHAR; }
{STRING}		{ printf("Line %d, string \n", lineNum); yylval.str = strdup(yytext); return TK_STRING; }

"+"		{ printf("Line %d, %s \n", lineNum, yytext); yylval.str = strdup(yytext); return '+'; }
"-"		{ printf("Line %d, %s \n", lineNum, yytext); yylval.str = strdup(yytext); return '-'; }
"*"		{ printf("Line %d, %s \n", lineNum, yytext); yylval.str = strdup(yytext); return '*'; }
"/"		{ printf("Line %d, %s \n", lineNum, yytext); yylval.str = strdup(yytext); return '/'; }
"("		{ printf("Line %d, %s \n", lineNum, yytext); yylval.str = strdup(yytext); return '('; }
")"		{ printf("Line %d, %s \n", lineNum, yytext); yylval.str = strdup(yytext); return ')'; }
"["		{ printf("Line %d, %s \n", lineNum, yytext); yylval.str = strdup(yytext); return '['; }
"]"		{ printf("Line %d, %s \n", lineNum, yytext); yylval.str = strdup(yytext); return ']'; }
"&&"	{ printf("Line %d, %s \n", lineNum, yytext); yylval.str = strdup(yytext); return TK_AND; }
"||"	{ printf("Line %d, %s \n", lineNum, yytext); yylval.str = strdup(yytext); return TK_OR; }
"!"		{ printf("Line %d, %s \n", lineNum, yytext); yylval.str = strdup(yytext); return '!'; }
"<"		{ printf("Line %d, %s \n", lineNum, yytext); yylval.str = strdup(yytext); return '<'; }
">"		{ printf("Line %d, %s \n", lineNum, yytext); yylval.str = strdup(yytext); return '>'; }
"="		{ printf("Line %d, %s \n", lineNum, yytext); yylval.str = strdup(yytext); return '='; }
"<="	{ printf("Line %d, %s \n", lineNum, yytext); yylval.str = strdup(yytext); return TK_LESSEQ; }
">="	{ printf("Line %d, %s \n", lineNum, yytext); yylval.str = strdup(yytext); return TK_GREQ; }
"!="	{ printf("Line %d, %s \n", lineNum, yytext); yylval.str = strdup(yytext); return TK_NEQ; }
":="	{ printf("Line %d, assignment \n", lineNum);  yylval.str = strdup(yytext); return TK_ASSGN; }
";"		{ printf("Line %d, %s \n", lineNum, yytext); yylval.str = strdup(yytext); return ';'; }
","		{ printf("Line %d, %s \n", lineNum, yytext); yylval.str = strdup(yytext); return ','; }
\\n		{ printf("Line %d, line Feed \n", lineNum); yylval.str = strdup(yytext); return TK_LINE_FEED; }
\\t		{ printf("Line %d, tab \n", lineNum); yylval.str = strdup(yytext); return TK_TAB; }
\\r		{ printf("Line %d, return \n", lineNum); yylval.str = strdup(yytext); return TK_RETURN; }
\\\\	{ printf("Line %d, backslash \n", lineNum); yylval.str = strdup(yytext); return TK_BACKSLASH; }
\\\'	{ printf("Line %d, single quote \n", lineNum); yylval.str = strdup(yytext); return TK_SINGLE_QUOTE; }
\\\"	{ printf("Line %d, double quote \n", lineNum); yylval.str = strdup(yytext); return TK_DOUBLE_QUOTE; }

"//"[^\n]*			{ printf("Line %d, line comment: %s\n", lineNum, yytext); }
"/*"(.*[\n]*)*"*/"	{ printf("Line %d, block comment: %s\n", lineNum, yytext); char *tmp = yytext; while(tmp = strstr(tmp, "\n")){ lineNum++; tmp++; } }

[ \r\t]+	{ /* eat whitespace */ }
\n			{ ++lineNum; }

.			{ printf("Line %d, Lexical ERROR: Unrecognized literal %s\n", lineNum, yytext); }

%%
