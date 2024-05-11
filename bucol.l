%{
#include "bucol.tab.h"
#include <string.h>
%}

%option noyywrap
%option yylineno
%option caseless

%%

[ \t\n] ;
"BEGINNING" { return BEGINNING; }
"END" { return END; }
"BODY" { return BODY; } 
"MOVE" { return MOVE; }
"ADD" { return ADD; }
"TO" { return TO; }
"INPUT" { return INPUT; }
"PRINT" { return PRINT; }
"." { return DOT; }
"?" { return QUESTION_MARK; }
"+" { return PLUS; }
"=" {return EQUALS;}
";" { return SEMICOLON; }
[X]+ {yylval.ints =yyleng ; return CAPACITY; }
[a-zA-Z-][A-Za-z0-9-]* {yylval.strs = strdup(yytext); return(IDENTIFIER); }
\"[^\"]*\" {
    yylval = strdup(yytext + 1, strlen(yytext) - 2);
    return STRING;
}
[0-9]+ { yylval.ints = atoi(yytext); return INTEGER; }
. { printf("Unknown character: %s\n", yytext); }

%%