%option noyywrap

%{
#include <stdio.h>
#define YY_DECL int yylex()
#include "parser.tab.h"
%}

%%

[ \t\n] ; // ignore all whitespace and newline characters
[0-9]+ {yylval.ival = atoi(yytext); /* printf("Token: NUMBER, Value: %s\n", yytext); */ return NUMBER;}
"IF" { /* printf("Token: IF\n"); */ return IF;}
"THEN" { /* printf("Token: THEN\n"); */ return THEN;}
"ELSE" { /* printf("Token: ELSE\n"); */ return ELSE;}
"END" { /* printf("Token: END\n"); */ return END;}
"REPEAT" { /* printf("Token: REPEAT\n"); */ return REPEAT;}
"UNTIL" { /* printf("Token: UNTIL\n"); */ return UNTIL;}
"READ" { /* printf("Token: READ\n"); */ return READ;}
"WRITE" { /* printf("Token: WRITE\n"); */ return WRITE;}
[a-zA-Z][a-zA-Z0-9]* {
    yylval.sval = strdup(yytext);
    /* printf("Token: ID, Value: %s\n", yytext); */
    return ID;
}
"+" { /* printf("Token: ADD_OP\n"); */ return ADD_OP;}
"-" { /* printf("Token: SUB_OP\n"); */ return SUB_OP;}
"*" { /* printf("Token: MUL_OP\n"); */ return MUL_OP;}
"/" { /* printf("Token: DIV_OP\n"); */ return DIV_OP;}
"=" { /* printf("Token: EQUAL\n"); */ return EQUAL;}
"<" { /* printf("Token: LESS\n"); */ return LESS;}
"(" { /* printf("Token: LEFT_PAREN\n"); */ return LEFT_PAREN;}
")" { /* printf("Token: RIGHT_PAREN\n"); */ return RIGHT_PAREN;}
";" { /* printf("Token: SEMICOLON\n"); */ return SEMICOLON;}
":=" { /* printf("Token: ASSIGN\n"); */ return ASSIGN;}
%%
