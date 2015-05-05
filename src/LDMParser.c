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
