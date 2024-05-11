%{
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <math.h>
#include "symbolTable.h"
char error[100];

%}
%union {
    int num;
    char* strs;
}
%token <num> CAPACITY INTEGER
%token <strs> IDENTIFIER
%token <num> INPUT
%type <num> value
%type <strs> validIdentifier errorOperation
%token BEGINNING DOT BODY ADD MOVE TO END PRINT SEMICOLON STRING
%%

program: beginning declarations main end

FULLSTOP: DOT | {yyerror("Line end missing");}

beginning: BEGINNING FULLSTOP
    | BEGINNING error {yyerror("Expected '.' after BEGINNING");}
    | error BEGINNING FULLSTOP {yyerror("Expected BEGINNING at the start");}

end: END FULLSTOP
    | END error {yyerror("Expected '.' after END");}

declarations : declaration declarations 
        | declaration body 
        | body

body: BODY FULLSTOP
    | BODY error {yyerror("Expected '.' after BODY");}

declaration:  CAPACITY IDENTIFIER FULLSTOP {
    for (int i = 1; i < strlen($2)-1; i++){
        if ($2[i-1] == 'X' && $2[i] == 'X'){
            yyerror("Cannot have contigious X in variable declaration\n");
            return -1;
        }
    }
    addSymbol($2, $1);
}

main : operations FULLSTOP { /* actions */ }
            | main operations FULLSTOP { /* actions */ }
            | end

operations : add | move | input | print | errorOperation {
    char error[100];
    int temp = snprintf(error, 100, "Operation %s not correctly declared", $1);
    yyerror(error);
}

errorOperation: ADD | MOVE | PRINT | INPUT | TO

add : ADD value TO validIdentifier {
            printf("Adding value %d to variable %s\n", $2, $4);
            updateSymbolValue($4, getSymbolValue($4) + $2);
        }

move : MOVE value TO validIdentifier {
            printf("Moving value %d to variable %s\n", $2, $4);
            updateSymbolValue($4, $2);
        }

input : INPUT multipleIdentifiers {
            printf("Input to multiple identifiers\n");
        }

multipleIdentifiers: multipleIdentifiers SEMICOLON validIdentifier 
        | validIdentifier

value : validIdentifier { $$ = getSymbolValue($1); } 
        | INTEGER { $$ = $1; }

print : PRINT printables 

printables : validIdentifier SEMICOLON printables 
        | STRING SEMICOLON printables 
        | validIdentifier 
        | STRING  

validIdentifier : IDENTIFIER {
    if(symbolExists($1) == 1) {$$ = $1;} 
    else {char error [100]; 
    int temp = snprintf(error, 100, "Identifier %s not declared", $1);
    yyerror(error);
    }
}
%%

extern FILE *yyin;

int main(int argc, char *argv[]){
    yyparse();
    return 0;
}

void yyerror(const char *s)
{
    fprintf(stderr, "Syntax Error at line %d: %s\n", yylineno, s);
}