%{
/*
 * Copyright (C) 1989, G. E. Weddell.
 */
#include "CDBGrammar.tab.h"
int  LineNumber = 1;
char LineBuffer[2000];
%}


D         [0-9]
L         [a-zA-Z_]
H         [a-fA-F0-9]
E         [Ee][+-]?{D}+
FS         (f|F|l|L)
IS         (u|U|l|L)*
blanktab   [ \t]
spaces     {blanktab}+

%%
\n             { LineNumber++; strcpy(LineBuffer, ""); }
"/*"           { strcat(LineBuffer, yytext); comment(); }
"#"            { preprocessor(); return(PREPROCESSOR); }
{spaces}       { strcat(LineBuffer, yytext); }
"auto"         { strcat(LineBuffer, yytext); return(AUTO); }
"break"        { strcat(LineBuffer, yytext); return(BREAK); }
"case"         { strcat(LineBuffer, yytext); return(CASE); }
"char"         { strcat(LineBuffer, yytext); return(CHAR); }
"const"        { strcat(LineBuffer, yytext); return(CONST); }
"continue"     { strcat(LineBuffer, yytext); return(CONTINUE); }
"default"      { strcat(LineBuffer, yytext); return(DEFAULT); }
"do"           { strcat(LineBuffer, yytext); return(DO); }
"double"       { strcat(LineBuffer, yytext); return(DOUBLE); }
"else"         { strcat(LineBuffer, yytext); return(ELSE); }
"enum"         { strcat(LineBuffer, yytext); return(ENUM); }
"extern"       { strcat(LineBuffer, yytext); return(EXTERN); }
"float"        { strcat(LineBuffer, yytext); return(FLOAT); }
"for"          { strcat(LineBuffer, yytext); return(FOR); }
"goto"         { strcat(LineBuffer, yytext); return(GOTO); }
"if"           { strcat(LineBuffer, yytext); return(IF); }
"in"           { strcat(LineBuffer, yytext); return(IN); }
"int"          { strcat(LineBuffer, yytext); return(INT); }
"invoke"       { strcat(LineBuffer, yytext); return(INVOKE); }
"long"         { strcat(LineBuffer, yytext); return(LONG); }
"prop"         { strcat(LineBuffer, yytext); return(PROP); }
"register"     { strcat(LineBuffer, yytext); return(REGISTER); }
"return"       { strcat(LineBuffer, yytext); return(RETURN); }
"schema"       { strcat(LineBuffer, yytext); return(SCHEMA); }
"short"        { strcat(LineBuffer, yytext); return(SHORT); }
"signed"       { strcat(LineBuffer, yytext); return(SIGNED); }
"sizeof"       { strcat(LineBuffer, yytext); return(SIZEOF); }
"static"       { strcat(LineBuffer, yytext); return(STATIC); }
"struct"       { strcat(LineBuffer, yytext); return(STRUCT); }
"switch"       { strcat(LineBuffer, yytext); return(SWITCH); }
"typedef"      { strcat(LineBuffer, yytext); return(TYPEDEF); }
"union"        { strcat(LineBuffer, yytext); return(UNION); }
"unsigned"     { strcat(LineBuffer, yytext); return(UNSIGNED); }
"void"         { strcat(LineBuffer, yytext); return(VOID); }
"volatile"     { strcat(LineBuffer, yytext); return(VOLATILE); }
"while"        { strcat(LineBuffer, yytext); return(WHILE); }

{L}({L}|{D})*      { strcat(LineBuffer, yytext); return(check_type()); }

0[xX]{H}+{IS}?     { strcat(LineBuffer, yytext); return(CONSTANT); }
0{D}+{IS}?         { strcat(LineBuffer, yytext); return(CONSTANT); }
{D}+{IS}?          { strcat(LineBuffer, yytext); return(CONSTANT); }
'(\\.|[^\\'])+'    { strcat(LineBuffer, yytext); return(CONSTANT); }

{D}+{E}{FS}?             { strcat(LineBuffer, yytext); return(CONSTANT); }
{D}*"."{D}+({E})?{FS}?   { strcat(LineBuffer, yytext); return(CONSTANT); }
{D}+"."{D}*({E})?{FS}?   { strcat(LineBuffer, yytext); return(CONSTANT); }

\"(\\.|[^\\"])*\"        { strcat(LineBuffer, yytext); return(STRING_LITERAL); }

">>="        { strcat(LineBuffer, yytext); return(RIGHT_ASSIGN); }
"<<="        { strcat(LineBuffer, yytext); return(LEFT_ASSIGN); }
"+="         { strcat(LineBuffer, yytext); return(ADD_ASSIGN); }
"-="         { strcat(LineBuffer, yytext); return(SUB_ASSIGN); }
"*="         { strcat(LineBuffer, yytext); return(MUL_ASSIGN); }
"/="         { strcat(LineBuffer, yytext); return(DIV_ASSIGN); }
"%="         { strcat(LineBuffer, yytext); return(MOD_ASSIGN); }
"&="         { strcat(LineBuffer, yytext); return(AND_ASSIGN); }
"^="         { strcat(LineBuffer, yytext); return(XOR_ASSIGN); }
"|="         { strcat(LineBuffer, yytext); return(OR_ASSIGN); }
">>"         { strcat(LineBuffer, yytext); return(RIGHT_OP); }
"<<"         { strcat(LineBuffer, yytext); return(LEFT_OP); }
"++"         { strcat(LineBuffer, yytext); return(INC_OP); }
"--"         { strcat(LineBuffer, yytext); return(DEC_OP); }
"->"         { strcat(LineBuffer, yytext); return(PTR_OP); }
"&&"         { strcat(LineBuffer, yytext); return(AND_OP); }
"||"         { strcat(LineBuffer, yytext); return(OR_OP); }
"<="         { strcat(LineBuffer, yytext); return(LE_OP); }
">="         { strcat(LineBuffer, yytext); return(GE_OP); }
"=="         { strcat(LineBuffer, yytext); return(EQ_OP); }
"!="         { strcat(LineBuffer, yytext); return(NE_OP); }
";"          { strcat(LineBuffer, yytext); return(';'); }
"{"          { strcat(LineBuffer, yytext); return('{'); }
"}"          { strcat(LineBuffer, yytext); return('}'); }
","          { strcat(LineBuffer, yytext); return(','); }
":"          { strcat(LineBuffer, yytext); return(':'); }
"="          { strcat(LineBuffer, yytext); return('='); }
"("          { strcat(LineBuffer, yytext); return('('); }
")"          { strcat(LineBuffer, yytext); return(')'); }
"["          { strcat(LineBuffer, yytext); return('['); }
"]"          { strcat(LineBuffer, yytext); return(']'); }
"."          { strcat(LineBuffer, yytext); return('.'); }
"&"          { strcat(LineBuffer, yytext); return('&'); }
"!"          { strcat(LineBuffer, yytext); return('!'); }
"~"          { strcat(LineBuffer, yytext); return('~'); }
"-"          { strcat(LineBuffer, yytext); return('-'); }
"+"          { strcat(LineBuffer, yytext); return('+'); }
"*"          { strcat(LineBuffer, yytext); return('*'); }
"/"          { strcat(LineBuffer, yytext); return('/'); }
"%"          { strcat(LineBuffer, yytext); return('%'); }
"<"          { strcat(LineBuffer, yytext); return('<'); }
">"          { strcat(LineBuffer, yytext); return('>'); }
"^"          { strcat(LineBuffer, yytext); return('^'); }
"|"          { strcat(LineBuffer, yytext); return('|'); }
"?"          { strcat(LineBuffer, yytext); return('?'); }
"@"          { strcat(LineBuffer, yytext); return('@'); }
.            { strcat(LineBuffer, yytext); yyerror ("Illegal character"); }

%%
