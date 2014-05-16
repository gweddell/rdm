/*
 * Copyright (C) 1989, G. E. Weddell.
 */
#include <stdio.h>
#include <ctype.h>
#include "lex.yy.c"
#include "y.tab.c"

preprocessor()
{
	char c, text[200];
	int counter = 0;

loop1:
	while ((c = input()) != '"' && c != '\n') {
		text[counter] = c;
		counter++;
	}
      
	if (c == '"') {
      text[counter] = 'x';
		counter++;
      text[counter] = 'x';
		counter++;
		text[counter] = '4';
		counter++;
		goto loop1;
	}
   
	LineNumber++;
	text[counter] = '\0';
	strcpy(yytext, text);
}

comment()
{
	char  c, c1;
	int   Num = 0;

loop:
	while ((c = input()) != '*' && c != 0 && c != '\n');

	if (c == '\n') {
		Num++;
		goto loop;
	}

	if (c == 0) 
	  goto exit;

	if ((c1 = input()) != '/') {
		unput(c1);
		goto loop;
	}
	else
		LineNumber += Num;

exit:;
}

int check_type()
{
/* 
* pseudo code --- this is what it should check 
*
*	if (yytext == type_name)
*		return(TYPE_NAME);
*
*	return(IDENTIFIER);
*/

/*
*	it actually will only return IDENTIFIER
*/
	return(IDENTIFIER);
}


main()
{
   int yyparse(), Result;
   strcpy( LineBuffer, "" );
   printf( "(" );
   Result = yyparse(); 
   if ( Result )
      printf( "**error**" );
   printf( ")" );
   return( Result );
}


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
		if (LineBuffer[i-1] == '\t') putc('\t', stderr);
      else putc(' ', stderr);
   for (i=1; i <= strlen( yytext ); i++)
      putc('^', stderr);
   putc('\n', stderr);
   fprintf ( stderr, "** error: %s found in line %d of CDB source file.\n\n", s, LineNumber );
}


yywrap()
{
   return(1);
}
