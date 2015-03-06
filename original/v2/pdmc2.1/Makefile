.PHONY: all clean

all: pdmc isc

FixLispInput: FixLispInput.l
	sbcl --noinform --eval "(compile-file \"FixLispInput.l\")" --eval "(quit)"
	mv FixLispInput.fasl FixLispInput
	chmod +x FixLispInput

PDMRun: PatMatch.l PDMCompLib.l PDMGenCCode.l RuleUse.l
	cat PatMatch.l PDMCompLib.l PDMGenCCode.l RuleUse.l > PDMRun.l
	echo "(Compile)" >> PDMRun.l
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

clean:
	rm -f FixLispInput PDMRun IndexSpecParser PDMParser pdmc isc lex.yy.c *.tab.c *.tab.h *.fasl
