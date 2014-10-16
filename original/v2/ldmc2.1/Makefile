sys: CostProb.o FuncDep.o LDMComp.o
sys: LDMCompLib.o LDMErrorProcs.o LDMParser LDMPassFive.o
sys: LDMPassFour.o LDMPassOne.o LDMPassThree.o LDMSchemaAccess.o
sys: LDMSchemaMaint.o PatMatch.o 
sys: RuleUse.o SelCond.o ldmc
CostProb.o: CostProb.l
			liszt CostProb.l
FuncDep.o: FuncDep.l
			liszt FuncDep.l
LDMComp.o: LDMComp.l
			liszt LDMComp.l
LDMCompLib.o: LDMCompLib.l
			liszt LDMCompLib.l
LDMErrorProcs.o: LDMErrorProcs.l
			liszt LDMErrorProcs.l
LDMParser: LDMParser.c LDMGrammar.y LDMScanner.l
			bison -d LDMGrammar.y
			flex LDMScanner.l
			gcc -w LDMParser.c -o LDMParser
			rm -f lex.yy.c LDMGrammar.tab.c LDMGrammar.tab.h 
LDMPassFive.o: LDMPassFive.l
			liszt LDMPassFive.l
LDMPassFour.o: LDMPassFour.l
			liszt LDMPassFour.l
LDMPassOne.o: LDMPassOne.l
			liszt LDMPassOne.l
LDMPassThree.o: LDMPassThree.l
			liszt LDMPassThree.l
LDMSchemaAccess.o: LDMSchemaAccess.l
			liszt LDMSchemaAccess.l
LDMSchemaMaint.o: LDMSchemaMaint.l
			liszt LDMSchemaMaint.l
PatMatch.o: PatMatch.l
			liszt PatMatch.l
RuleUse.o: RuleUse.l
			liszt RuleUse.l
SelCond.o: SelCond.l
			liszt SelCond.l
ldmc: LDMCompControl.c
			gcc -o ldmc LDMCompControl.c
clean:
			rm -f CostProb.o FuncDep.o GenCCode.o LDMComp.o
			rm -f LDMCompLib.o LDMErrorProcs.o LDMParser LDMPassFive.o
			rm -f LDMPassFour.o LDMPassOne.o LDMPassThree.o LDMSchemaAccess.o
			rm -f LDMSchemaMaint.o PDMParser PatMatch.o 
			rm -f RuleUse.o SelCond.o ldmc
