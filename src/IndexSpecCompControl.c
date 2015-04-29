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
