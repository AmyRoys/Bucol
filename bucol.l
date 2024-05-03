%{
#include "bucol.tab.h"
#include <string.h>
%}

%option noyywrap

%%

[ \t\n] { /* ignore whitespace and newlines */ }
"BEGINNING." { return BEGINNING; }
"END." { return END; }
"BODY." { return BODY; } 
"MOVE" { return MOVE; }
"ADD" { return ADD; }
"TO" { return TO; }
"INPUT" { return INPUT; }
"PRINT" { return PRINT; }
"." { return DOT; }
"?" { return QUESTION_MARK; }
"+" { return PLUS; }
"=" {return EQUALS;}
X+ { yylval.str = strdup(yytext); return CAPACITY; }
[a-zA-Z][a-zA-Z0-9-]* { yylval.str = strdup(yytext); return IDENTIFIER; }
\".*\" { yylval.str = strdup(yytext); return STRING; }
[0-9]+ { yylval.num = atoi(yytext); return INTEGER; }
";" { return SEMICOLON; }
. { printf("Unknown character: %s\n", yytext); }

%%