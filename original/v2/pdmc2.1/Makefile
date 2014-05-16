sys: PDMComp.o  PDMCompLib.o IndexSpecParser 
sys: PDMGenCCode.o 
sys: PDMParser PatMatch.o RuleUse.o PosSlash
sys: PreSlash  pdmc 
sys: FixLispInput.o isc
FixLispInput.o: FixLispInput.l
		  liszt -r FixLispInput.l
PDMComp.o: PDMComp.l
			liszt -r PDMComp.l
PDMCompLib.o: PDMCompLib.l
			liszt PDMCompLib.l
IndexSpecParser: IndexSpecParser.c IndexSpecGrammar.y IndexSpecScanner.l
			yacc -d IndexSpecGrammar.y
			lex IndexSpecScanner.l
			cc -w IndexSpecParser.c -ll -o IndexSpecParser
			rm lex.yy.c y.tab.c y.tab.h 
PDMGenCCode.o: PDMGenCCode.l
			liszt PDMGenCCode.l
PDMParser: PDMParser.c PDMGrammar.y PDMScanner.l
			yacc -d PDMGrammar.y
			lex PDMScanner.l
			cc -w PDMParser.c -ll -o PDMParser
			rm lex.yy.c y.tab.c y.tab.h 
PatMatch.o: PatMatch.l
			liszt PatMatch.l
RuleUse.o: RuleUse.l
			liszt RuleUse.l
PosSlash: PosSlash.l
			lex PosSlash.l
			cc -w lex.yy.c -ll -o PosSlash
			rm lex.yy.c 
PreSlash: PreSlash.l
			lex PreSlash.l
			cc -w lex.yy.c -ll -o PreSlash
			rm lex.yy.c 
pdmc: PDMCompControl.c
			cc -o pdmc -g PDMCompControl.c
isc: IndexSpecCompControl.c
			cc -o isc -g IndexSpecCompControl.c
clean:
			rm PDMComp.o PDMCompBody.o PDMCompLib.o PDMParser
			rm GenCCode.o
			rm PDMParser PatMatch.o PosSlash
			rm PreSlash RuleUse.o cdbc 
