#include "symbolTable.h"
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <math.h>

Symbol *symbolTable[TABLE_SIZE];
void yyerror(const char *s);

unsigned int hash(char *str) {
    unsigned int hash = 5381;
    int c;
    while ((c = *str++))
        hash = ((hash << 5) + hash) + c; 
    return hash % TABLE_SIZE;
}

Symbol *lookupSymbol(char *identifier) {
    unsigned int index = hash(identifier);
    return symbolTable[index];
}

void addSymbol(char *identifier, int maxLen) {
    Symbol *symbol = malloc(sizeof(Symbol));
    symbol->identifier = strdup(identifier);
    symbol->value = 0;
    symbol->maxLen = maxLen;
    unsigned int index = hash(identifier);
    symbolTable[index] = symbol;
    printf("Added symbol %s at index %u\n", identifier, index);  
}

int symbolExists(char *identifier) {
    unsigned int index = hash(identifier);
    Symbol *symbol = symbolTable[index];
    printf("Looking for symbol %s at index %u\n", identifier, index);
    return symbol != NULL;
}

int getSymbolValue(char* identifier) {
    unsigned int index = hash(identifier);
    Symbol *symbol = symbolTable[index];
    if (symbol == NULL) {
        return -1; 
    }
    return symbol->value;
}


int updateSymbolValue(char* identifier, int value) {
    char error[200];
    unsigned int index = hash(identifier);
    Symbol *symbol = symbolTable[index];
    if (symbol == NULL) {
        snprintf(error, 200, "Identifier %s not found\n", identifier);
        yyerror(error);
        return -1;
    }
    if(value >= pow(10, symbol->maxLen)){
        snprintf(error, 200, "Number too big %d for %s for max length %.2lf\n", value, identifier, pow(10, symbol->maxLen));
        yyerror(error);
        return -1;
    }
    symbol->value = value;
    return 0;
}
