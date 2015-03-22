#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#define NameSize 50

int  Error(), CSystem();

Error()
{
	fprintf(stderr, "isc IndexSpecFileName\n");
	exit(0);
}

CSystem(Command)
char *Command;
{
	if (system(Command) != 0) exit(0);
}

main (argc, argv, envp) 
int  argc; 
char *argv[], *envp[];
{
   int   Counter;
	char  IndexSpecFileName[NameSize],
	      Command[256];
	
	if (argc != 2) Error();
	strcpy (IndexSpecFileName, argv[1]);

	fprintf(stderr, "Index Spec Compiler - Version 2.1\n");
	fprintf(stderr,"--------------------------\n");
	fprintf(stderr,"checking syntax.\n");
	fprintf(stderr,"   %s\n", IndexSpecFileName);
	sprintf(Command, "./IndexSpecParser < %s > isc.internal.in", IndexSpecFileName);
	CSystem(Command);
	strcat(IndexSpecFileName, ".internal");
	CSystem("./FixLispInput");
	sprintf(Command, "mv isc.internal.out %s", IndexSpecFileName);
	CSystem(Command);
	CSystem("rm isc.*");
}
