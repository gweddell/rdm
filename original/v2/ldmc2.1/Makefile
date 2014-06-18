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
			gcc -w LDMParser.c -ll -o LDMParser
			rm flex.yy.c LDMGrammar.tab.c LDMGrammar.tab.h 
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
			rm CostProb.o FuncDep.o GenCCode.o LDMComp.o
			rm LDMCompLib.o LDMErrorProcs.o LDMParser LDMPassFive.o
			rm LDMPassFour.o LDMPassOne.o LDMPassThree.o LDMSchemaAccess.o
			rm LDMSchemaMaint.o PDMParser PatMatch.o 
			rm RuleUse.o SelCond.o ldmc
