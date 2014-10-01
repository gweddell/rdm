%%
"xx"						{ printf("%s", "xx1"); }
\\							{ printf("%s", "xx2"); }
\\\"						{ printf("%s", "xx3"); }
.							{ printf("%s", yytext); }
%% 
