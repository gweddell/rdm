/*
 * Copyright (C) 1989, G. E. Weddell.
 */

#include <stdio.h>
#include "lex.yy.c"
#include "LDMGrammar.tab.c"

main()
{
   int Result;
   strcpy( LineBuffer, "" );
   printf( "(" );
   Result = yyparse(); 
   if ( Result )
      printf( "**error**" );
   else
      fprintf( stderr, "checking semantics.\n");
   printf( ")" );
   return( Result );
}
