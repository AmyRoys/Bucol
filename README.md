# Bucol Programming Language Lexer and Parser

This project contains the lexer and parser for the Bucol programming language. It is implemented using Flex and Bison.

## Getting Started

These instructions will get you a copy of the project up and running on your local machine for development and testing purposes.

### Prerequisites

- Flex (The Fast Lexical Analyzer)
- Bison (The GNU parser generator)
- GCC

### Installing

1. Clone the repository
```bash
git clone https://github.com/AmyRoys/Bucol.git
```
2. Build the project
```bash
flex bucol.l
bison -d bucol.y
gcc -o bucol bucol.tab.c lex.yy.c symbolTable.c
```
4. Test a bucol program

To run through program line-by-line
```bash
.\bucol.exe
```
To run through the program all at once
```bash
Get-Content ValidProgram.bucol | .\bucol.exe

Get-Content InValidProgram.bucol | .\bucol.exe
```

## How it Works

### Lexer 

The lexer, implemented in `bucol.l`, is responsible for tokenizing the input source code. It uses regular expressions to match patterns in the input and convert them into tokens that the parser can understand.

- Keywords: `BEGINNING`, `BODY`, `ADD`, `MOVE`, `INPUT`, `TO`, `PRINT`, `END`
- Punctuation: `;`, `.`
- Strings: Any sequence of characters enclosed in double quotes
- Integers: Any sequence of one or more digits
- Capacity: The letter `X`, with the value being the length of the sequence of `X`s
- Identifiers: Any sequence of letters and digits, starting with a letter or a hyphen

The lexer uses the `noyywrap` option, which means it doesn't support multiple input files. If the lexer reaches the end of the input, it stops lexing.

It also uses the `caseless` option which tells the lexer to ignore case when matching patterns, which allows for the language to be case insensitive. 


### Parser

The parser, implemented in `bucol.y`, is responsible for analyzing the tokens produced by the lexer and building a parse tree based on the grammar of the Bucol programming language.

The parser also interacts with the symbol table. When a variable is declared, the parser adds it to the symbol table with its initial value. When a variable is used, the parser checks if it has been declared by looking it up in the symbol table.



### Symbol Table 

The symbol table is a hash table implemented in C, where the keys are the identifiers of the variables and the values are `Symbol` structures. Each `Symbol` structure contains the identifier of the variable, its current value, and its maximum length.

The symbol table provides the following functions:

- `hash(char *str)`: Computes the hash of a string.
- `lookupSymbol(char *identifier)`: Looks up a symbol in the symbol table.
- `addSymbol(char *identifier, int maxLen)`: Adds a symbol to the symbol table.
- `symbolExists(char *identifier)`: Checks if a symbol exists in the symbol table.
- `getSymbolValue(char* identifier)`: Gets the value of a symbol.
- `updateSymbolValue(char* identifier, int value)`: Updates the value of a symbol.

The symbol table is used by the parser to store and retrieve the values of variables.