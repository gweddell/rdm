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
#define MaxPDMFile 20

char Result[NameSize];

int Error()
{
	fprintf(stderr,
		"cdbc [-f {PDMFileName}+] [-o OutputFileName] CDBFileName\n");
	exit(0);
}

int CSystem(char *Command)
{
	if (system(Command) != 0)
		exit(0);
}

char *FixExtension(char *A, char *B)
{
	char Ext[NameSize];
	strcpy(Result, A);
	strcpy(Ext, ".");
	strcat(Ext, B);
	if ((strlen(Result) < strlen(Ext)) ||
	    (strcmp(Result + strlen(Result) - strlen(Ext), Ext)))
		strcat(Result, Ext);
	return (Result);
}

int main(int argc, char *argv[])
{
	int Counter, End, NumPDMFile = 0;
	enum { Init, OptionF, OptionO } State;
	char File[NameSize],
	    PDMFileName[MaxPDMFile][NameSize],
	    CDBFileName[NameSize],
	    OutputFileName[NameSize], DummyString[NameSize], Command[256];

	if (argc == 1)
		Error();
	strcpy(CDBFileName, FixExtension(argv[argc - 1], "cdb"));
	for (Counter = 0; Counter <= (strlen(CDBFileName) - 5); Counter++)
		File[Counter] = CDBFileName[Counter];
	File[Counter] = '\0';
	strcpy(OutputFileName, File);
	strcat(OutputFileName, ".c");
	strcpy(PDMFileName[0], File);
	strcat(PDMFileName[0], ".pdm");

	End = argc - 2;
	State = Init;

	for (Counter = 1; Counter <= End; Counter++) {
		if (strcmp(argv[Counter], "-f") == 0) {
			if (State != Init)
				Error();
			State = OptionF;
		} else if (strcmp(argv[Counter], "-o") == 0) {
			if (Counter + 1 != End)
				Error();
			State = OptionO;
		} else {
			if (argv[Counter][0] == '-')
				Error();
			if (State == Init)
				Error();
			if (State == OptionF) {
				NumPDMFile++;
				strcpy(PDMFileName[NumPDMFile],
				       FixExtension(argv[Counter], "pdm"));
			} else
				strcpy(OutputFileName,
				       FixExtension(argv[Counter], "c"));
		}
	}

	fprintf(stderr, "CDB Compiler - Version 2.1\n");
	fprintf(stderr, "--------------------------\n");
	fprintf(stderr, "checking syntax.\n");

	sprintf(Command, "echo %d > cdbc.pdm.number", NumPDMFile);
	CSystem(Command);
	if (NumPDMFile == 0) {
		fprintf(stderr, "   %s\n", PDMFileName[0]);
		sprintf(Command, "./PDMParser < %s > cdbc.pdm.input0",
			PDMFileName[0]);
		CSystem(Command);
	} else {
		for (Counter = 1; Counter <= NumPDMFile; Counter++) {
			fprintf(stderr, "   %s\n", PDMFileName[Counter]);
			sprintf(Command, "./PDMParser < %s > cdbc.pdm.input%d",
				PDMFileName[Counter], Counter);
			CSystem(Command);
		}
	}

	fprintf(stderr, "   %s\n", CDBFileName);
	sprintf(Command, "./CDBParser < %s > cdbc.cdb.input", CDBFileName);
	CSystem(Command);
	CSystem("sbcl --noinform --load CDBRun");
	sprintf(Command, "indent cdbc.output -kr -o %s", OutputFileName);
	CSystem(Command);
	CSystem("rm cdbc.pdm.*");
	CSystem("rm cdbc.cdb.*");
	CSystem("rm cdbc.output");
}
