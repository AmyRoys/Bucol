%{
    #include "bucol.tab.h"
    #include <string.h>
%}

%option yylineno
%option noyywrap
%option caseless

%%

[\t ]+ ;
"BEGINNING" {return(BEGINNING);}
"BODY" {return(BODY);}
"ADD" {return(ADD);}
"MOVE" {return(MOVE);}
"INPUT" {return(INPUT);}
"TO" {return(TO);}
"PRINT" {return(PRINT);}
"END" {return(END);}
";" {return(SEMICOLON);}
"." {return(DOT);}
\"[^\n\r]*\" {return(STRING);}
[0-9]+ {yylval.num = atoi(yytext); return(INTEGER);}
[X]+ {yylval.num=yyleng ;return(CAPACITY); }
[a-zA-Z-][A-Za-z0-9-]* {yylval.strs = strdup(yytext); return(IDENTIFIER); }
. {}
%%