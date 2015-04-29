#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <libgen.h>
#define NameSize 50
#define MaxPDMFile 20

char Result[NameSize];

int Error()
{
	fprintf(stderr, "pdmc PDMFileName\n");
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
	int Counter;
	char PDMFileName[NameSize],
	    OutputFileName[NameSize], DummyString[NameSize], Command[256];

	if (argc != 2)
		Error();
	strcpy(PDMFileName, FixExtension(argv[argc - 1], "pdm"));
	for (Counter = 0; Counter <= (strlen(PDMFileName) - 5); Counter++)
		OutputFileName[Counter] = PDMFileName[Counter];
	OutputFileName[Counter] = '\0';
	strcat(OutputFileName, ".h");

	fprintf(stderr, "PDM Compiler - Version 2.1\n");
	fprintf(stderr, "--------------------------\n");
	fprintf(stderr, "checking syntax.\n");

	fprintf(stderr, "   %s\n", PDMFileName);
	sprintf(Command, "./PDMParser < %s > pdmc.pdm.input", PDMFileName);
	CSystem(Command);

	CSystem("sbcl --noinform --load PDMRun");
	sprintf(Command, "indent pdmc.h.output -kr -o %s", OutputFileName);
	CSystem(Command);
	OutputFileName[Counter + 1] = 'c';
	sprintf(Command, "indent pdmc.c.output -kr -o %s", OutputFileName);
	CSystem(Command);
	CSystem("rm pdmc.*");
}
