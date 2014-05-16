%%
"xx1"						{ printf("%s", "xx"); }
"xx2"						{ printf("%s", "\\"); }
"xx3"						{ printf("%s", "\\\""); }
"xx4"						{ printf("%s", "\""); }
.							{ printf("%s", yytext); }
%% 
