#ifndef SYMBOL_TABLE_H
#define SYMBOL_TABLE_H

#include <stdlib.h>

typedef struct Symbol {
    char *identifier;
    int value;
    int maxLen;
} Symbol;

extern int yylex();
extern int yylineno;
void yyerror(const char *s);

#define TABLE_SIZE 1000
extern Symbol *symbolTable[TABLE_SIZE];

unsigned int hash(char *str);
Symbol *lookupSymbol(char *identifier);
void addSymbol(char *identifier, int maxLen);
int symbolExists(char *identifier); 
int getSymbolValue(char* identifier); 
int updateSymbolValue(char* identifier, int value); 


#endif // SYMBOL_TABLE_H