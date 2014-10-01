/*
 * Copyright (C) 1989, G. E. Weddell.
 */
#include <stdio.h>
#include <ctype.h>
#include "lex.yy.c"
#include "y.tab.c"


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
   fprintf ( stderr, "** error: %s found in line %d of PDM source file.\n\n", s, LineNumber );
}

yywrap()
{
   return(1);
}
