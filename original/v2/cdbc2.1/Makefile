.PHONY: all clean

all: cdbc

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

PDMParser: PDMParser.c PDMGrammar.y PDMScanner.l
	bison -d PDMGrammar.y
	flex PDMScanner.l
	gcc -w PDMParser.c -o PDMParser
	rm lex.yy.c PDMGrammar.tab.c PDMGrammar.tab.h

PosSlash: PosSlash.l
	lex PosSlash.l
	cc -w lex.yy.c -ll -o PosSlash
	rm lex.yy.c

PreSlash: PreSlash.l
	lex PreSlash.l
	cc -w lex.yy.c -ll -o PreSlash
	rm lex.yy.c

cdbc: CDBCompControl.c PDMParser CDBParser CDBRun
	gcc -o cdbc -g CDBCompControl.c

clean:
	rm -f CDBRun CDBParser PDMParser PosSlash PreSlash cdbc lex.yy.c *.tab.c *.tab.h *.fasl
