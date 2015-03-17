.PHONY: all clean

all: ldmc

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

clean:
	rm -f ldmc LDMRun LDMParser *.fasl lex.yy.c *.tab.c *.tab.h
