sys: PDMComp.o  PDMCompLib.o IndexSpecParser 
sys: PDMGenCCode.o 
sys: PDMParser PatMatch.o RuleUse.o PosSlash
sys: PreSlash  pdmc 
sys: FixLispInput isc
FixLispInput: FixLispInput.l
	sbcl --noinform --eval "(compile-file \"FixLispInput.l\")" --eval "(quit)"
	mv FixLispInput.fasl FixLispInput
	chmod +x FixLispInput

PDMComp.o: PDMComp.l
	liszt -r PDMComp.l
PDMCompLib.o: PDMCompLib.l
	liszt PDMCompLib.l
IndexSpecParser: IndexSpecParser.c IndexSpecGrammar.y IndexSpecScanner.l
	bison -d IndexSpecGrammar.y
	flex IndexSpecScanner.l
	gcc -w IndexSpecParser.c -o IndexSpecParser
	rm -f lex.yy.c IndexSpecGrammar.tab.c IndexSpecGrammar.tab.h
PDMGenCCode.o: PDMGenCCode.l
	liszt PDMGenCCode.l
PDMParser: PDMParser.c PDMGrammar.y PDMScanner.l
	bison -d PDMGrammar.y
	flex PDMScanner.l
	gcc -w PDMParser.c -o PDMParser
	rm -f lex.yy.c PDMGrammar.tab.c PDMGrammar.tab.h 
PatMatch.o: PatMatch.l
	liszt PatMatch.l
RuleUse.o: RuleUse.l
	liszt RuleUse.l
PosSlash: PosSlash.l
	flex PosSlash.l
	gcc -w lex.yy.c -o PosSlash
	rm -f lex.yy.c 
PreSlash: PreSlash.l
	flex PreSlash.l
	gcc -w lex.yy.c -o PreSlash
	rm -f lex.yy.c 
pdmc: PDMCompControl.c
	gcc -o pdmc -g PDMCompControl.c
isc: IndexSpecCompControl.c
	gcc -o isc -g IndexSpecCompControl.c
clean:
	rm PDMComp.o PDMCompBody.o PDMCompLib.o PDMParser
	rm GenCCode.o
	rm PDMParser PatMatch.o PosSlash
	rm PreSlash RuleUse.o cdbc 
