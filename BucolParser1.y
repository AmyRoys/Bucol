%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

extern int yylex();
void yyerror(const char *s) {
    fprintf(stderr, "Error: %s\n", s);
}

typedef struct{
    char* identifier; 
    int value; 
}Symbol; 

Symbol* symbolTable = NULL; 
int symbol_table_size = 0;

void add_symbol(char* identifier, int value){
    symbolTable = realloc(symbolTable, (symbol_table_size + 1) * sizeof(Symbol));
    symbolTable[symbol_table_size].identifier = strdup(identifier);
    symbolTable[symbol_table_size].value = value; 
    symbol_table_size++;
}

int get_symbol_value(char* identifier){
    for(int i =0; i < symbol_table_size; i++){
        if(strcmp(symbolTable[i].identifier, identifier) == 0){
            return symbolTable[i].value; 
        }
    }
    printf("Error: symbol %s not found\n", identifier);
    exit(1); 
}
%}

%union {
    int num;
    char *str;
}

%token <str> CAPACITY
%token <str> IDENTIFIER
%token <num> INTEGER
%token <str> STRING
%token BEGINNING END BODY MOVE ADD TO INPUT PRINT SEMICOLON DOT QUESTION_MARK PLUS EQUALS NEWLINE

%%

program: BEGINNING declarations BODY statements END { printf("Program is correctly formed\n"); }
       | error { printf("Program is incorrectly formed\n"); }
       ;

declarations: /* empty string */
            | declarations declaration
            ;

declaration: CAPACITY IDENTIFIER INTEGER DOT { printf("Declared variable %s with capacity %d\n", $2, $3); free($2); }
            ;

statements: /* empty string */
          | statements statement NEWLINE
          ;

statement: BEGINNING DOT { printf("Beginning\n"); }
         | CAPACITY IDENTIFIER DOT { printf("Declared variable %s\n", $2); free($2); }
         | BODY DOT { printf("Body\n"); }
         | INPUT IDENTIFIER DOT { printf("Input to variable: %s\n", $2); fflush(stdin); int value; scanf("%d", &value); add_symbol($2, value); free($2); }
         | MOVE INTEGER TO IDENTIFIER DOT { printf("Moved value to %s\n", $4); free($4); }
         | ADD IDENTIFIER TO IDENTIFIER DOT { printf("Added value to %s\n", $4); free($4); }
         | print_statement
         | END DOT { printf("End\n"); }
         ;

print_statement: PRINT print_items DOT { printf("Printed items\n"); }
               ;

print_items: print_item
           | print_items print_item
           ;

print_item: STRING { printf("Printed string: %s\n", $1); free($1); }
          | IDENTIFIER { printf("Printed variable: %s\n", $1); free($1); }
          | PLUS { printf("Printed plus\n"); }
          | EQUALS { printf("Printed equals\n"); }
          | QUESTION_MARK { printf("Printed question mark\n"); }
          ;
          ;
%%

int main(void) {
    yyparse();
    return 0;
}