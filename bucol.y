%{
    #include <stdio.h>
    #include <string.h>
    #include <stdlib.h>
    #include <math.h>
    #include "symbolTable.h"

%}

%union {
    int num;
    char* strs;
}

%token <num> CAPACITY INTEGER
%token <strs> IDENTIFIER
%token <num> INPUT
%type <num> value
%type <strs> declaredIdentifier 
%token BEGINNING PRINT DOT MOVE TO END SEMICOLON BODY STRING ADD

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
            yyerror("Error: no contigious Xs in variables allowed\n");
            return -1;
        }
    }
    addSymbol($2, $1);
}

main : operations FULLSTOP { /* actions */ }
            | main operations FULLSTOP { /* actions */ }
            | end

operations : add | move | input | print | invalidOperations

invalidOperations: ADD | MOVE | PRINT | INPUT | TO

add : ADD value TO declaredIdentifier {
            printf("Adding value %d to variable %s\n", $2, $4);
            updateSymbolValue($4, getSymbolValue($4) + $2);
        }

move : MOVE value TO declaredIdentifier {
            printf("Moving value %d to variable %s\n", $2, $4);
            updateSymbolValue($4, $2);
        }

input : INPUT identifierList

identifierList: identifierList SEMICOLON declaredIdentifier 
        | declaredIdentifier

value : declaredIdentifier { $$ = getSymbolValue($1); } 
        | INTEGER { $$ = $1; }

print : PRINT outputSequence 

outputSequence : declaredIdentifier SEMICOLON outputSequence 
        | STRING SEMICOLON outputSequence
     
        | declaredIdentifier 
        | STRING  

declaredIdentifier : IDENTIFIER {
    if(symbolExists($1) == 1) {
        $$ = $1;
    } else {
        char error[100];
        int temp = snprintf(error, 100, "Identifier %s has not been declared", $1);
        yyerror(error);
    }
}
%%