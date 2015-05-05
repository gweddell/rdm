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
#include <string.h>
#include <stdlib.h>
#define NameSize 50

int Error()
{
	fprintf(stderr, "isc IndexSpecFileName\n");
	exit(0);
}

int CSystem(char *Command)
{
	if (system(Command) != 0)
		exit(0);
}

int main(int argc, char *argv[])
{
	int Counter;
	char IndexSpecFileName[NameSize], Command[256];

	if (argc != 2)
		Error();
	strcpy(IndexSpecFileName, argv[1]);

	fprintf(stderr, "Index Spec Compiler - Version 2.1\n");
	fprintf(stderr, "--------------------------\n");
	fprintf(stderr, "checking syntax.\n");
	fprintf(stderr, "   %s\n", IndexSpecFileName);
	sprintf(Command, "./IndexSpecParser < %s > isc.internal.in",
		IndexSpecFileName);
	CSystem(Command);
	strcat(IndexSpecFileName, ".internal");
	CSystem("sbcl --noinform --load FixLispInput");
	sprintf(Command, "mv isc.internal.out %s", IndexSpecFileName);
	CSystem(Command);
	CSystem("rm isc.*");
}
