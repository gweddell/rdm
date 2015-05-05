%{
/*
 * Copyright (C) 1989, G. E. Weddell.
 *
 * This file is part of RDM.
 *
 * RDM is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * RDM is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with RDM.  If not, see <http://www.gnu.org/licenses/>.
 */

#include "PDMGrammar.tab.h"
int LineNumber = 1;
char LineBuffer[200];
%}

%p 4000

digit			[0-9]
int			[+-]?{digit}+
E				[Ee][+-]?{digit}+
letter		[a-zA-Z]
blanktab		[ \t]
spaces		{blanktab}+

%%

\%.*\n					{ LineNumber++; }
{spaces}					{ strcat(LineBuffer, yytext); }
\n							{ LineNumber++; strcpy(LineBuffer, ""); }
"actions"				{ strcat(LineBuffer, yytext); return( ACTIONS ); }
"add"						{ strcat(LineBuffer, yytext); return( ADD ); }
"alloc"					{ strcat(LineBuffer, yytext); return( ALLOC ); }
"allocate"				{ strcat(LineBuffer, yytext); return( ALLOCATE ); }
"array"					{ strcat(LineBuffer, yytext); return( ARRAY ); }
"as"						{ strcat(LineBuffer, yytext); return( AS ); }
"AS"						{ strcat(LineBuffer, yytext); return( AS ); }
"asc"						{ strcat(LineBuffer, yytext); return( ASC ); }
"assign"					{ strcat(LineBuffer, yytext); return( ASSIGN ); }
"binary"					{ strcat(LineBuffer, yytext); return( BINARY ); }
"by"						{ strcat(LineBuffer, yytext); return( BY ); }
"class"					{ strcat(LineBuffer, yytext); return( CLASS ); }
"compliment"			{ strcat(LineBuffer, yytext); return( COMPLIMENT ); }
"copy"      			{ strcat(LineBuffer, yytext); return( COPY ); }
"create"					{ strcat(LineBuffer, yytext); return( CREATE ); }
"cut"						{ strcat(LineBuffer, yytext); return( CUT ); }
"declare"				{ strcat(LineBuffer, yytext); return( DECLARE ); }
"desc"					{ strcat(LineBuffer, yytext); return( DESC ); }
"destroy"				{ strcat(LineBuffer, yytext); return( DESTROY ); }
"direct"					{ strcat(LineBuffer, yytext); return( DIRECT ); }
"distributed"			{ strcat(LineBuffer, yytext); return( DISTRIBUTED ); }
"dynamic"				{ strcat(LineBuffer, yytext); return( DYNAMIC ); }
"each"					{ strcat(LineBuffer, yytext); return( EACH ); }
"else"					{ strcat(LineBuffer, yytext); return( ELSE ); }
"elseif"					{ strcat(LineBuffer, yytext); return( ELSEIF ); }
"end"						{ strcat(LineBuffer, yytext); return( END ); }
"endif"					{ strcat(LineBuffer, yytext); return( ENDIF ); }
"extension"				{ strcat(LineBuffer, yytext); return( EXTENSION ); } 
"fields"					{ strcat(LineBuffer, yytext); return( FIELDS ); }
"first"					{ strcat(LineBuffer, yytext); return( FIRST ); }
"for"						{ strcat(LineBuffer, yytext); return( FOR ); }
"free"					{ strcat(LineBuffer, yytext); return( FREE ); }
"frequency"				{ strcat(LineBuffer, yytext); return( FREQUENCY ); }
"from"					{ strcat(LineBuffer, yytext); return( FROM ); }
"given"					{ strcat(LineBuffer, yytext); return( GIVEN ); }
"id"						{ strcat(LineBuffer, yytext); return( LABELID ); }
"if"						{ strcat(LineBuffer, yytext); return( IF ); }
"in"						{ strcat(LineBuffer, yytext); return( IN ); }
"IN"						{ strcat(LineBuffer, yytext); return( IN ); }
"init"					{ strcat(LineBuffer, yytext); return( INIT ); }
"index"					{ strcat(LineBuffer, yytext); return( INDEX ); }
"indirect"				{ strcat(LineBuffer, yytext); return( INDIRECT ); }
"insert"					{ strcat(LineBuffer, yytext); return( INSERT ); }
"IS"						{ strcat(LineBuffer, yytext); return( IS ); }
"isa"						{ strcat(LineBuffer, yytext); return( ISA ); } 
"list"					{ strcat(LineBuffer, yytext); return( LIST ); }
"maxlen"					{ strcat(LineBuffer, yytext); return( MAXLEN ); }
"maximum"				{ strcat(LineBuffer, yytext); return( MAXIMUM ); }
"msc"						{ strcat(LineBuffer, yytext); return( MSC ); }
"mscsum"					{ strcat(LineBuffer, yytext); return( MSCSUM ); }
"nest"					{ strcat(LineBuffer, yytext); return( NEST ); }
"not"						{ strcat(LineBuffer, yytext); return( NOT ); }
"of"						{ strcat(LineBuffer, yytext); return( OF ); }
"offset"					{ strcat(LineBuffer, yytext); return( OFFSET ); }
"on"						{ strcat(LineBuffer, yytext); return( ON ); }
"one"						{ strcat(LineBuffer, yytext); return( ONE ); }
"ordered"				{ strcat(LineBuffer, yytext); return( ORDERED ); }
"overlap"				{ strcat(LineBuffer, yytext); return( OVERLAP ); }
"pointer"				{ strcat(LineBuffer, yytext); return( POINTER ); }
"properties"			{ strcat(LineBuffer, yytext); return( PROPERTIES ); } 
"property"				{ strcat(LineBuffer, yytext); return( PROPERTY ); }
"query"					{ strcat(LineBuffer, yytext); return( QUERY ); }
"range"					{ strcat(LineBuffer, yytext); return( RANGE ); }
"reference"				{ strcat(LineBuffer, yytext); return( REFERENCE ); } 
"remove"					{ strcat(LineBuffer, yytext); return( REMOVE ); } 
"return"					{ strcat(LineBuffer, yytext); return( RETURN ); } 
"schema"					{ strcat(LineBuffer, yytext); return( SCHEMA ); }
"select"					{ strcat(LineBuffer, yytext); return( SELECT ); }
"selectivity"			{ strcat(LineBuffer, yytext); return( SELECTIVITY ); }
"size"					{ strcat(LineBuffer, yytext); return( SIZE ); }
"space"					{ strcat(LineBuffer, yytext); return( SPACE ); }
"static"					{ strcat(LineBuffer, yytext); return( STATIC ); }
"store"					{ strcat(LineBuffer, yytext); return( STORE ); }
"storing"				{ strcat(LineBuffer, yytext); return( STORING ); }
"sub"						{ strcat(LineBuffer, yytext); return( SUB ); }
"then"					{ strcat(LineBuffer, yytext); return( THEN ); }
"time"					{ strcat(LineBuffer, yytext); return( TIME ); }
"to"						{ strcat(LineBuffer, yytext); return( TO ); }
"transaction"			{ strcat(LineBuffer, yytext); return( TRANSACTION ); }
"tree"					{ strcat(LineBuffer, yytext); return( TREE ); }
"type"					{ strcat(LineBuffer, yytext); return( TYPE ); }
"unit"					{ strcat(LineBuffer, yytext); return( UNIT ); }
"unoptimized"			{ strcat(LineBuffer, yytext); return( UNOPTIMIZED ); }
"verify"					{ strcat(LineBuffer, yytext); return( VERIFY ); }
"where"					{ strcat(LineBuffer, yytext); return( WHERE ); }
"with"					{ strcat(LineBuffer, yytext); return( WITH ); }
","						{ strcat(LineBuffer, yytext); return( COMMA ); }
";"						{ strcat(LineBuffer, yytext); return( SEMICOLON ); }
"."						{ strcat(LineBuffer, yytext); return( DOT ); }
"="						{ strcat(LineBuffer, yytext); return( EQ ); }
"<"						{ strcat(LineBuffer, yytext); return( LT ); }
">"						{ strcat(LineBuffer, yytext); return( GT ); }
"<="						{ strcat(LineBuffer, yytext); return( LE ); }
">="						{ strcat(LineBuffer, yytext); return( GE ); }
"<>"						{ strcat(LineBuffer, yytext); return( NE ); }
":="						{ strcat(LineBuffer, yytext); return( COLONEQ ); }
"+"						{ strcat(LineBuffer, yytext); return( PLUS ); }
"-"						{ strcat(LineBuffer, yytext); return( MINUS ); }
"*"						{ strcat(LineBuffer, yytext); return( TIMES ); }
"/"						{ strcat(LineBuffer, yytext); return( DIVIDE ); }
"%"						{ strcat(LineBuffer, yytext); return( MOD ); }
"("						{ strcat(LineBuffer, yytext); return( LEFTP ); }
")"						{ strcat(LineBuffer, yytext); return( RIGHTP ); }
{letter}({letter}|{digit}|_)*				{ strcat(LineBuffer, yytext); return( ID ); }
{int}						{ strcat(LineBuffer, yytext); return( INT ); }
{int}{E}					{ strcat(LineBuffer, yytext); return( REAL ); }
[+-]?{digit}*"."{digit}+({E})?			{ strcat(LineBuffer, yytext); return( REAL ); }
[+-]?{digit}+"."{digit}*({E})?			{ strcat(LineBuffer, yytext); return( REAL ); }
\"(\\.|[^\\"])*\"		{ strcat(LineBuffer, yytext); return( STRING ); }
.							{ strcat(LineBuffer, yytext); yyerror("Illegal character"); }
%% 
