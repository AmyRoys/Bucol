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
2. Navigate to the project directory
```bash
cd Bucol
```
3. Build the project
```bash
bison -d bucol.y
flex bucol.l
gcc bucol.tab.c lex.yy.c -o bucol
```
4. Test a bucol program

To run through program line-by-line
```bash
.\bucol.exe
```
To run through the program all at once
```bash
Get-Content ValidProgram.bucol | .\bucol.exe
```

## How it Works

### Lexer 

The lexer, implemented in `bucol.l`, is responsible for tokenizing the input source code. It uses regular expressions to match patterns in the input and convert them into tokens that the parser can understand.

Here's a brief overview of how the lexer works:

- It ignores whitespace and newlines (`[ \t\n]`).
- It recognizes keywords and symbols of the Bucol language like "BEGINNING.", "END.", "BODY.", "MOVE", "ADD", "TO", "INPUT", "PRINT", ".", "?", "+", "=", and ";" and returns the corresponding tokens.
- It recognizes capacities (`X+`) and identifiers (`[a-zA-Z][a-zA-Z0-9-]*`). The matched text is duplicated using `strdup` and the pointer to the duplicated string is stored in `yylval.str`. The lexer then returns the `CAPACITY` or `IDENTIFIER` token.
- It recognizes strings (`\".*\"`). The matched text is duplicated using `strdup` and the pointer to the duplicated string is stored in `yylval.str`. The lexer then returns the `STRING` token.
- It recognizes integers (`[0-9]+`). The matched text is converted to an integer using `atoi` and the integer is stored in `yylval.num`. The lexer then returns the `INTEGER` token.
- If the lexer encounters an unknown character, it prints an error message.

The lexer uses the `noyywrap` option, which means it doesn't support multiple input files. If the lexer reaches the end of the input, it stops lexing.


### Parser

The parser, implemented in `bucol.y`, is responsible for analyzing the tokens produced by the lexer and building a parse tree based on the grammar of the Bucol programming language.

Here's a brief overview of how the parser works:

- The `program` rule is the start symbol. It expects a `BEGINNING` token, followed by a series of declarations, a `BODY` token, a series of statements, and an `END` token. If this pattern is matched, it prints "Program is correctly formed". If there's an error, it prints "Program is incorrectly formed".

- The `declarations` and `statements` rules are lists of `declaration` and `statement` rules, respectively. They can be empty or contain multiple declarations/statements.

- The `declaration` rule matches a `CAPACITY` token followed by an `IDENTIFIER` token and a `DOT` token. It prints the declared variable and its capacity.

- The `statement` rule matches different patterns corresponding to different statements in the Bucol language, such as print, input, move, and add. It prints the action performed.

- The `identifiers` rule matches a list of identifiers separated by semicolons. It prints each identifier.

- The `yyerror` function is called when there's a syntax error. It prints an error message.

- The `main` function calls `yyparse` to start parsing. If parsing is successful, it returns 0.