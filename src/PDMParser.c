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

#include <stdio.h>
#include <ctype.h>
#include "lex.yy.c"
#include "PDMGrammar.tab.c"


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
