%{
/*
 * Copyright (C) 1989, G. E. Weddell.
 */
#include "LDMGrammar.tab.h"
#include <stdio.h>
#include <ctype.h>
//extern char yytext[];
int LineNumber = 1;
char LineBuffer[200];
%}

%p 3000

D			[0-9]
L			[a-zA-Z_]
E			[Ee][+-]?{D}+

%%

\%.*\n			{ LineNumber++; }
\n			{ LineNumber++; strcpy(LineBuffer, ""); }
"all"			{ strcat(LineBuffer, yytext); return(ALL); }
"and"			{ strcat(LineBuffer, yytext); return(AND); }
"array"			{ strcat(LineBuffer, yytext); return(ARRAY); }
"as"			{ strcat(LineBuffer, yytext); return(AS); }
"asc"			{ strcat(LineBuffer, yytext); return(ASC); }
"binary"		{ strcat(LineBuffer, yytext); return(BINARY); }
"by"			{ strcat(LineBuffer, yytext); return(BY); }
"change"		{ strcat(LineBuffer, yytext); return(CHANGE); }
"class"			{ strcat(LineBuffer, yytext); return(CLASS); }
"constraints"		{ strcat(LineBuffer, yytext); return(CONSTRAINTS); }
"cover"			{ strcat(LineBuffer, yytext); return(COVER); }
"declare"		{ strcat(LineBuffer, yytext); return(DECLARE); }
"delete"		{ strcat(LineBuffer, yytext); return(DELETE); }
"desc"			{ strcat(LineBuffer, yytext); return(DESC); }
"determined"		{ strcat(LineBuffer, yytext); return(DETERMINED); }
"distributed"		{ strcat(LineBuffer, yytext); return(DISTRIBUTED); }
"dynamic"		{ strcat(LineBuffer, yytext); return(DYNAMIC); }
"exist"			{ strcat(LineBuffer, yytext); return(EXIST); }
"for"			{ strcat(LineBuffer, yytext); return(FOR); }
"frequency"		{ strcat(LineBuffer, yytext); return(FREQUENCY); }
"from"			{ strcat(LineBuffer, yytext); return(FROM); }
"given"			{ strcat(LineBuffer, yytext); return(GIVEN); }
"has"			{ strcat(LineBuffer, yytext); return(HAS); }
"implies"		{ strcat(LineBuffer, yytext); return(IMPLIES); }
"index"			{ strcat(LineBuffer, yytext); return(INDEX); }
"insert"		{ strcat(LineBuffer, yytext); return(INSERT); }
"Integer"		{ strcat(LineBuffer, yytext); return(INTCLASS); }
"isa"			{ strcat(LineBuffer, yytext); return(ISA); }
"list"			{ strcat(LineBuffer, yytext); return(LIST); }
"max"			{ strcat(LineBuffer, yytext); return(MAX); }
"maxlen"		{ strcat(LineBuffer, yytext); return(MAXLEN); }
"min"			{ strcat(LineBuffer, yytext); return(MIN); }
"mod"			{ strcat(LineBuffer, yytext); return(MOD); }
"not"			{ strcat(LineBuffer, yytext); return(NOT); }
"of"			{ strcat(LineBuffer, yytext); return(OF); }
"on"			{ strcat(LineBuffer, yytext); return(ON); }
"one"			{ strcat(LineBuffer, yytext); return(ONE); }
"or"			{ strcat(LineBuffer, yytext); return(OR); }
"order"			{ strcat(LineBuffer, yytext); return(ORDER); }
"ordered"		{ strcat(LineBuffer, yytext); return(ORDERED); }
"overlap"		{ strcat(LineBuffer, yytext); return(OVERLAP); }
"pointer"		{ strcat(LineBuffer, yytext); return(POINTER); }
"precomputed"		{ strcat(LineBuffer, yytext); return(PRECOMPUTED); }
"property"		{ strcat(LineBuffer, yytext); return(PROPERTY); }
"properties"		{ strcat(LineBuffer, yytext); return(PROPERTIES); }
"query"			{ strcat(LineBuffer, yytext); return(QUERY); }
"range"			{ strcat(LineBuffer, yytext); return(RANGE); }
"return"		{ strcat(LineBuffer, yytext); return(RETURN); }
"schema"		{ strcat(LineBuffer, yytext); return(SCHEMA); }
"select"		{ strcat(LineBuffer, yytext); return(SELECT); }
"selectivity"		{ strcat(LineBuffer, yytext); return(SELECTIVITY); }
"size"			{ strcat(LineBuffer, yytext); return(SIZE); }
"space"			{ strcat(LineBuffer, yytext); return(SPACE); }
"static"		{ strcat(LineBuffer, yytext); return(STATIC); }
"store"			{ strcat(LineBuffer, yytext); return(STORE); }
"storing"		{ strcat(LineBuffer, yytext); return(STORING); }
"String"		{ strcat(LineBuffer, yytext); return(STRCLASS); }
"time"			{ strcat(LineBuffer, yytext); return(TIME); }
"to"			{ strcat(LineBuffer, yytext); return(TO); }
"transaction"		{ strcat(LineBuffer, yytext); return(TRANSACTION); }
"tree"			{ strcat(LineBuffer, yytext); return(TREE); }
"type"			{ strcat(LineBuffer, yytext); return(TYPE); }
"unit"			{ strcat(LineBuffer, yytext); return(UNIT); }
"where"			{ strcat(LineBuffer, yytext); return(WHERE); }

{L}({L}|{D})*		{ strcat(LineBuffer, yytext); return(IDENTIFIER); }

{D}+			{ strcat(LineBuffer, yytext); return(INTEGER); }
{D}+{E}			{ strcat(LineBuffer, yytext); return(REAL); }
{D}*"."{D}+({E})?	{ strcat(LineBuffer, yytext); return(REAL); }
{D}+"."{D}*({E})?	{ strcat(LineBuffer, yytext); return(REAL); }

\"(\\.|[^\\"])*\"	{ strcat(LineBuffer, yytext); return(STRING); }

":="			{ strcat(LineBuffer, yytext); return(ASSIGN); }
"<="			{ strcat(LineBuffer, yytext); return(LE); }
">="			{ strcat(LineBuffer, yytext); return(GE); }
"<>"			{ strcat(LineBuffer, yytext); return(NE); }
";"			{ strcat(LineBuffer, yytext); return(';'); }
"{"			{ strcat(LineBuffer, yytext); return('{'); }
"}"			{ strcat(LineBuffer, yytext); return('}'); }
","			{ strcat(LineBuffer, yytext); return(','); }
"="			{ strcat(LineBuffer, yytext); return('='); }
"("			{ strcat(LineBuffer, yytext); return('('); }
")"			{ strcat(LineBuffer, yytext); return(')'); }
"["			{ strcat(LineBuffer, yytext); return('['); }
"]"			{ strcat(LineBuffer, yytext); return(']'); }
"."			{ strcat(LineBuffer, yytext); return('.'); }
"-"			{ strcat(LineBuffer, yytext); return('-'); }
"+"			{ strcat(LineBuffer, yytext); return('+'); }
"*"			{ strcat(LineBuffer, yytext); return('*'); }
"/"			{ strcat(LineBuffer, yytext); return('/'); }
"<"			{ strcat(LineBuffer, yytext); return('<'); }
">"			{ strcat(LineBuffer, yytext); return('>'); }

" "			{ strcat(LineBuffer, yytext); }
"\r"			{ strcat(LineBuffer, yytext); }
.			{ strcat(LineBuffer, yytext);
			  yyerror("illegal character"); }
%%

yyerror(s)
char *s;
{
   int i;
   char c;
   fprintf( stderr, "\n%s", LineBuffer );
   c = input();
   while ( c != '\n'  &&  c != 0 ) {
      putc(c, stderr);
      c = input();
   }
   putc('\n', stderr);
   for (i=1; i <= strlen( LineBuffer ) - strlen( yytext ); i++)
      putc(' ', stderr);
   for (i=1; i <= strlen( yytext ); i++)
      putc('^', stderr);
   putc('\n', stderr);
   fprintf ( stderr, "** error: %s found in line %d.\n\n", s, LineNumber );
}

yywrap()
{
   return(1);
}
