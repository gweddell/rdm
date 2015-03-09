sys: CDBComp.o CDBCompLib.o CDBParser cdbc
sys: GenCCode.o 
sys: PDMParser PatMatch.o 
sys: PreSlash  PosSlash 
CDBComp.o: CDBComp.l
			liszt -r CDBComp.l
CDBCompLib.o: CDBCompLib.l
			liszt CDBCompLib.l
CDBParser: CDBParser.c CDBGrammar.y CDBScanner.l
			bison -d CDBGrammar.y
			flex CDBScanner.l
			gcc -w CDBParser.c -o CDBParser
			rm lex.yy.c CDBGrammar.tab.c CDBGrammar.tab.h
GenCCode.o: GenCCode.l
			liszt GenCCode.l
PDMParser: PDMParser.c PDMGrammar.y PDMScanner.l
			bison -d PDMGrammar.y
			flex PDMScanner.l
			gcc -w PDMParser.c -o PDMParser
			rm lex.yy.c PDMGrammar.tab.c PDMGrammar.tab.h
PatMatch.o: PatMatch.l
			liszt PatMatch.l
PosSlash: PosSlash.l
			lex PosSlash.l
			cc -w lex.yy.c -ll -o PosSlash
			rm lex.yy.c 
PreSlash: PreSlash.l
			lex PreSlash.l
			cc -w lex.yy.c -ll -o PreSlash
			rm lex.yy.c 
cdbc: CDBCompControl.c
			gcc -o cdbc -g CDBCompControl.c
clean:
			rm CDBComp.o  CDBCompLib.o CDBParser
			rm GenCCode.o
			rm PDMParser PatMatch.o PosSlash
			rm PreSlash  cdbc 
