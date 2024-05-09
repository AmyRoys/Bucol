%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <math.h>

#define HASH_SIZE 100

typedef struct IdentifierList {
    char *identifier;
    struct IdentifierList *next;
} IdentifierList;

IdentifierList* create_identifier_list(char *identifier) {
    IdentifierList *id_list = malloc(sizeof(IdentifierList));
    id_list->identifier = identifier;
    id_list->next = NULL;
    return id_list;
}

void add_identifier(IdentifierList *id_list, char *identifier) {
    while (id_list->next) {
        id_list = id_list->next;
    }
    IdentifierList *new_id = create_identifier_list(identifier);
    id_list->next = new_id;
}

typedef struct Symbol {
    char *name;
    int capacity;
    int value; 
    struct Symbol *next;  
} Symbol;

Symbol *symbol_table[HASH_SIZE];

unsigned int hash(char *s) {
    unsigned int h = 0;
    for (; *s; s++) {
        h = *s + h * 31;
    }
    return h % HASH_SIZE;
}

Symbol* find_symbol(char *name) {
    Symbol *symbol = symbol_table[hash(name)];
    while (symbol) {
        if (strcmp(symbol->name, name) == 0) {
            return symbol;
        }
        symbol = symbol->next;
    }
    fprintf(stderr, "Error: variable %s not initialized\n", name);
    exit(1);
}

void add_symbol(char *name, char *capacity) {
    unsigned int index = hash(name);
    Symbol *symbol = malloc(sizeof(Symbol));
    symbol->name = strdup(name);
    symbol->capacity = atoi(capacity);  
    symbol->next = symbol_table[index];
    symbol_table[index] = symbol;
}

extern int yylex();
void yyerror(const char *s);

%}

%union {
    int num;
    char *str;
    struct IdentifierList *id_list;
}

%token <str> CAPACITY
%token <str> IDENTIFIER
%token <num> INTEGER
%token <str> STRING
%token BEGINNING END BODY MOVE ADD TO INPUT PRINT SEMICOLON DOT QUESTION_MARK PLUS EQUALS


%type <id_list> identifiers
%%

program: BEGINNING declarations BODY statements END { printf("Program is correctly formed\n"); }
       | error { printf("Program is incorrectly formed\n"); }
       ;

declarations: /* empty string */
            | declarations declaration
            ;

declaration: IDENTIFIER CAPACITY DOT { 
    printf("Declared variable %s with capacity %s\n", $2, $1); 
    add_symbol($2, $1);
    free($1); 
    free($2); 
}

statements: /* empty string */
          | statements statement
          ;

statement: PRINT STRING DOT { printf("Printed string: %s\n", $2); free($2); }
         | INPUT IDENTIFIER DOT { printf("Input to variable: %s\n", $2); free($2); }
         | ADD IDENTIFIER TO IDENTIFIER DOT { 
            printf("Added value to %s\n", $4); 
            Symbol *symbol1 = find_symbol($2);
            Symbol *symbol2 = find_symbol($4);
            if (log10(symbol1->value + symbol2->value) + 1 > symbol2->capacity) {
                fprintf(stderr, "Error: value exceeds variable's capacity\n");
                exit(1);
            }
            symbol2->value += symbol1->value;  
        }
         | PRINT identifiers DOT { 
            printf("Printed values\n"); 
            Symbol *symbol;
            struct IdentifierList *id_list = $2;
            while (id_list) {
                symbol = find_symbol(id_list->identifier);
                if (!symbol) {
                    fprintf(stderr, "Error: variable %s not initialized\n", id_list->identifier);
                    exit(1);
                }
                id_list = id_list->next;
            }
        }
         | MOVE INTEGER TO IDENTIFIER DOT { 
            printf("Moving value %d to variable: %s\n", $2, $4); 
            Symbol *symbol = find_symbol($4);
            if ($2 > symbol->capacity) {
                fprintf(stderr, "Error: value exceeds variable's capacity\n");
                exit(1);
            }
            symbol->value = $2;  // store the value in the symbol
        }

identifiers: IDENTIFIER { $$ = create_identifier_list($1); }
           | identifiers SEMICOLON STRING { add_identifier($1, $3); }
           | identifiers SEMICOLON IDENTIFIER { add_identifier($1, $3); }
           ;
%%

void yyerror(const char *s) {
    fprintf(stderr, "Error: %s\n", s);
}

int main() {
    yyparse();
    return 0;
}