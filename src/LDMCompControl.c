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
#include <stdlib.h>
#include <string.h>
#define NameSize 50
#define MaxPDMFile 20

char Result[NameSize];

int Error()
{
	fprintf(stderr, "ldmc [-o OutputFileName] LDMFileName\n");
	exit(0);
}

char *FixExtension(char *A, char *B)
{
	char Ext[NameSize];
	strcpy(Result, A);
	strcpy(Ext, ".");
	strcpy(Ext, B);
	if ((strlen(Result) < strlen(Ext)) ||
	    (strcmp(Result + strlen(Result) - strlen(Ext), Ext)))
		strcat(Result, Ext);
	return (Result);
}

int main(int argc, char *argv[])
{
	int Counter, End = 0;
	enum { Init, OptionO } State;
	char LDMFileName[NameSize], OutputFileName[NameSize], Command[256];

	if (argc == 1)
		Error();
	strcpy(LDMFileName, FixExtension(argv[argc - 1], "ldm"));
	for (Counter = 0; Counter <= (strlen(LDMFileName) - 5); Counter++)
		OutputFileName[Counter] = LDMFileName[Counter];
	OutputFileName[Counter] = '\0';
	strcat(OutputFileName, ".pdm");

	End = argc - 2;
	State = Init;

	for (Counter = 1; Counter <= End; Counter++) {
		if (strcmp(argv[Counter], "-o") == 0) {
			if (Counter + 1 != End)
				Error();
			State = OptionO;
		} else {
			if (argv[Counter][0] == '-')
				Error();
			if (State == Init)
				Error();
			strcpy(OutputFileName,
			       FixExtension(argv[Counter], "pdm"));
		}
	}

	fprintf(stderr, "LDM Compiler - Version 2.1\n");
	fprintf(stderr, "Copyright (C) 1989, G. E. Weddell\n");
	fprintf(stderr, "---------------------------------\n");
	fprintf(stderr, "checking syntax.\n");

	sprintf(Command, "./LDMParser < %s > ldmc.in", LDMFileName);
	if (system(Command) != 0)
		system("rm ldmc.*");
	if (system("sbcl --noinform --load LDMRun > ldmc.diag") != 0)
		system("rm ldmc.*");
	sprintf(Command, "mv ldmc.out %s", OutputFileName);
	system(Command);
	system("rm ldmc.*");
}
