%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

extern int yylex();
void yyerror(const char *s);
%}

%union {
    int num;
    char *str;
}

%token <str> CAPACITY
%token <str> IDENTIFIER
%token <num> INTEGER
%token <str> STRING
%token BEGINNING END BODY MOVE ADD TO INPUT PRINT SEMICOLON DOT QUESTION_MARK PLUS EQUALS

%%

program: BEGINNING declarations BODY statements END { printf("Program is correctly formed\n"); }
       | error { printf("Program is incorrectly formed\n"); }
       ;

declarations: /* empty string */
            | declarations declaration
            ;

declaration: CAPACITY IDENTIFIER DOT { printf("Declared variable %s with capacity %s\n", $2, $1); free($1); free($2); }
            ;

statements: /* empty string */
          | statements statement
          ;

statement: PRINT STRING DOT { printf("Printed string: %s\n", $2); free($2); }
         | INPUT IDENTIFIER DOT { printf("Input to variable: %s\n", $2); free($2); }
         | MOVE INTEGER TO IDENTIFIER DOT { printf("Moved value to %s\n", $4); free($4); }
         | ADD IDENTIFIER TO IDENTIFIER DOT { printf("Added value to %s\n", $4); free($4); }
         | PRINT identifiers DOT { printf("Printed values\n"); }

// value: INTEGER { printf("Value is %d\n", $1); }
//      | IDENTIFIER { printf("Value is %s\n", $1); free($1); }
//      ;

identifiers: IDENTIFIER { printf("Identifier is %s\n", $1); free($1); }
           | identifiers SEMICOLON STRING { printf("String is %s\n", $3); free($3); }
           | identifiers SEMICOLON IDENTIFIER { printf("Identifier is %s\n", $3); free($3); }
           ;

// outputs: output { printf("Output is %s\n", $1); free($1); }
//        | outputs SEMICOLON output { printf("Output is %s\n", $3); free($3); }
//        ;

// output: STRING
//       | IDENTIFIER
//       ;

%%

void yyerror(const char *s) {
    fprintf(stderr, "Error: %s\n", s);
}

int main() {
    yyparse();
    return 0;
}