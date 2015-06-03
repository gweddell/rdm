.PHONY: all clean

all: LDMParser LDMRun IndexSpecParser FixLispInput PDMParser PDMRun cdbc

LDMRun: PatMatch.cl RuleUse.cl LDMComp.cl CostProb.cl LDMCompLib.cl FuncDep.cl LDMErrorProcs.cl LDMSchemaAccess.cl SelCond.cl LDMSchemaMaint.cl LDMPassOne.cl LDMPassTwo.cl LDMPassThree.cl LDMPassFour.cl LDMPassFive.cl
	cat $^ > LDMRun.cl
	echo "(main)" >> LDMRun.cl
	sbcl --noinform --eval "(compile-file \"LDMRun.cl\")" --eval "(quit)"
	rm -f LDMRun.cl
	mv LDMRun.fasl LDMRun
	chmod +x LDMRun
	
LDMParser: LDMParser.c LDMGrammar.y LDMScanner.l
	bison -d LDMGrammar.y
	flex LDMScanner.l
	gcc -w LDMParser.c -o LDMParser
	rm -f lex.yy.c LDMGrammar.tab.c LDMGrammar.tab.h 

FixLispInput: FixLispInput.cl
	sbcl --noinform --eval "(compile-file \"FixLispInput.cl\")" --eval "(quit)"
	mv FixLispInput.fasl FixLispInput
	chmod +x FixLispInput

PDMRun: PatMatch.cl RuleUse.cl PDMComp.cl PDMCompLib.cl GenCCode.cl
	cat $^ > PDMRun.cl
	echo "(main)" >> PDMRun.cl
	sbcl --noinform --eval "(compile-file \"PDMRun.cl\")" --eval "(quit)"
	rm -f PDMRun.cl
	mv PDMRun.fasl PDMRun
	chmod +x PDMRun

IndexSpecParser: IndexSpecParser.c IndexSpecGrammar.y IndexSpecScanner.l
	bison -d IndexSpecGrammar.y
	flex IndexSpecScanner.l
	gcc -w IndexSpecParser.c -o IndexSpecParser
	rm -f lex.yy.c IndexSpecGrammar.tab.c IndexSpecGrammar.tab.h

PDMParser: PDMParser.c PDMGrammar.y PDMScanner.l
	bison -d PDMGrammar.y
	flex PDMScanner.l
	gcc -w PDMParser.c -o PDMParser
	rm -f lex.yy.c PDMGrammar.tab.c PDMGrammar.tab.h 

CDBRun: PatMatch.cl CDBComp.cl CDBCompLib.cl GenCCode.cl
	cat $^ > CDBRun.cl
	echo "(main)" >> CDBRun.cl
	sbcl --noinform --eval "(compile-file \"CDBRun.cl\")" --eval "(quit)"
	rm -f CDBRun.cl
	mv CDBRun.fasl CDBRun
	chmod +x CDBRun

CDBParser: CDBParser.c CDBGrammar.y CDBScanner.l
	bison -d CDBGrammar.y
	flex CDBScanner.l
	gcc -w CDBParser.c -o CDBParser
	rm lex.yy.c CDBGrammar.tab.c CDBGrammar.tab.h

cdbc: CDBCompControl.c PDMParser CDBParser CDBRun
	gcc -o cdbc -g CDBCompControl.c

clean:
	rm -f LDMRun LDMParser
	rm -f FixLispInput PDMRun IndexSpecParser PDMParser
	rm -f CDBRun CDBParser PDMParser PosSlash PreSlash cdbc
	rm -f lex.yy.c *.tab.c *.tab.h *.fasl
