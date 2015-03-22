.PHONY: all clean

all: ldmc pdmc isc cdbc

LDMRun: PatMatch.l RuleUse.l LDMComp.l CostProb.l LDMCompLib.l FuncDep.l LDMErrorProcs.l LDMSchemaAccess.l SelCond.l LDMSchemaMaint.l LDMPassOne.l LDMPassTwo.l LDMPassThree.l LDMPassFour.l LDMPassFive.l
	cat PatMatch.l RuleUse.l LDMComp.l CostProb.l LDMCompLib.l FuncDep.l LDMErrorProcs.l LDMSchemaAccess.l SelCond.l LDMSchemaMaint.l LDMPassOne.l LDMPassTwo.l LDMPassThree.l LDMPassFour.l LDMPassFive.l > LDMRun.l
	echo "(main)" >> LDMRun.l
	sbcl --noinform --eval "(compile-file \"LDMRun.l\")" --eval "(quit)"
	rm -f LDMRun.l
	mv LDMRun.fasl LDMRun
	chmod +x LDMRun
	
LDMParser: LDMParser.c LDMGrammar.y LDMScanner.l
	bison -d LDMGrammar.y
	flex LDMScanner.l
	gcc -w LDMParser.c -o LDMParser
	rm -f lex.yy.c LDMGrammar.tab.c LDMGrammar.tab.h 

ldmc: LDMCompControl.c LDMParser LDMRun
	gcc -o ldmc LDMCompControl.c

FixLispInput: FixLispInput.l
	sbcl --noinform --eval "(compile-file \"FixLispInput.l\")" --eval "(quit)"
	mv FixLispInput.fasl FixLispInput
	chmod +x FixLispInput

PDMRun: PatMatch.l RuleUse.l PDMComp.l PDMCompLib.l GenCCode.l
	cat PatMatch.l RuleUse.l PDMComp.l PDMCompLib.l GenCCode.l > PDMRun.l
	echo "(main)" >> PDMRun.l
	sbcl --noinform --eval "(compile-file \"PDMRun.l\")" --eval "(quit)"
	rm -f PDMRun.l
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

pdmc: PDMCompControl.c PDMParser PDMRun
	gcc -o pdmc -g PDMCompControl.c

isc: IndexSpecCompControl.c IndexSpecParser FixLispInput
	gcc -o isc -g IndexSpecCompControl.c


CDBRun: PatMatch.l CDBComp.l CDBCompLib.l GenCCode.l
	cat PatMatch.l CDBComp.l CDBCompLib.l GenCCode.l > CDBRun.l
	echo "(main)" >> CDBRun.l
	sbcl --noinform --eval "(compile-file \"CDBRun.l\")" --eval "(quit)"
	rm -f CDBRun.l
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
	rm -f ldmc LDMRun LDMParser
	rm -f FixLispInput PDMRun IndexSpecParser PDMParser pdmc isc
	rm -f CDBRun CDBParser PDMParser PosSlash PreSlash cdbc
	rm -f lex.yy.c *.tab.c *.tab.h *.fasl
