#pragma once

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define YY_DECL int yylex()

extern int yylex();
extern int yyparse();
extern int fileno(FILE* file);
extern FILE* yyin;
void yyerror(const char* s);

typedef struct {
    char* code;
    char* label;
} Node;

char* newLabel();
char* newTempReg();
char* createString(const char* src);
void trimEnd(char *str);
