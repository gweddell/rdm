/*
 * Main control for the LDM compiler.  NOTE - Installation is likely
 * to require changing line 72 in which an absolute file name is
 * is "hard-wired".
 * Copyright (C) 1989, G. E. Weddell.
 */

#include <stdio.h>
#include <string.h>
#define NameSize 50
#define MaxPDMFile 20

int  Error();
char Result[NameSize], *FixExtension();

Error()
{
	fprintf( stderr, "ldmc [-o OutputFileName] LDMFileName\n");
	exit(0);
}

char *FixExtension(A, B)
char *A, *B;
{  	
	char Ext[NameSize];
	strcpy(Result, A);
	strcat(Ext, B);
	if ((strlen(Result) < strlen(Ext)) ||
		 (strcmp(Result + strlen(Result) - strlen(Ext), Ext)))
		strcat(Result, Ext);
	return(Result);
}

main (argc, argv, envp) 
int  argc; 
char *argv[], *envp[];
{
	int   Counter, End = 0;
	enum  {Init, OptionO} State;
	char  LDMFileName[NameSize],
		OutputFileName[NameSize],
		Command[256];
	
	if (argc == 1) Error();
	strcpy (LDMFileName, FixExtension(argv[argc-1], ".ldm"));
	for (Counter = 0; Counter <= (strlen(LDMFileName) - 5); Counter++)
		OutputFileName[Counter] = LDMFileName[Counter];
	OutputFileName[Counter] = '\0';
	strcat(OutputFileName, ".pdm");
	
	End =  argc - 2;
	State = Init;

	for (Counter = 1; Counter <= End; Counter++)
		if (strcmp(argv[Counter], "-o") == 0) {
			if (Counter + 1 != End) Error();
			State =  OptionO;
		}
		else { 
			if (argv[Counter][0] == '-') Error();
			if (State == Init) Error();
			strcpy(OutputFileName, FixExtension(argv[Counter], ".pdm"));
		}
		
	fprintf(stderr, "LDM Compiler - Version 2.1\n");
	fprintf(stderr, "Copyright (C) 1989, G. E. Weddell\n");
	fprintf(stderr, "---------------------------------\n");
	fprintf(stderr, "checking syntax.\n");

  	sprintf(Command, "LDMParser < %s > ldmc.in", LDMFileName);
	if (system(Command) != 0) system("rm ldmc.*");
	if (system("lisp < /u2/gweddell/research/dbtool/version2.1/ldmc2.1/LDMRun > ldmc.diag")
				 != 0)
		system("rm ldmc.*");
	sprintf(Command, "mv ldmc.out %s", OutputFileName);
	system(Command);
	system("rm ldmc.*");
}
