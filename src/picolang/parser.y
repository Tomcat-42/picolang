%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

extern int yylex();
extern int yyparse();
extern FILE* yyin;

void yyerror(const char* s);
%}

%union {
 int ival;
 char* sval;
}

%token<ival> NUMBER
%token<sval> ID
%token ADD_OP SUB_OP MUL_OP DIV_OP EQUAL LESS
%token LEFT_PAREN RIGHT_PAREN
%token IF THEN ELSE END REPEAT UNTIL READ WRITE
%token SEMICOLON ASSIGN

%start program

%%

program:
 cmd_seq
;

cmd_seq: cmd
 | cmd_seq SEMICOLON cmd { printf("Executing a command.\n"); }
;

cmd: if_cmd
 | repeat_cmd
 | assign_cmd
 | read_cmd
 | write_cmd
;

if_cmd: IF exp THEN cmd_seq END { printf("Executing an IF command.\n"); }
 | IF exp THEN cmd_seq ELSE cmd_seq END { printf("Executing an IF/ELSE command.\n"); }
;

repeat_cmd: REPEAT cmd_seq UNTIL exp { printf("Executing a REPEAT command.\n"); }
;

assign_cmd: ID ASSIGN exp { printf("Executing an ASSIGN command.\n"); }
;

read_cmd: READ ID { printf("Executing a READ command.\n"); }
;

write_cmd: WRITE exp { printf("Executing a WRITE command.\n"); }
;

exp: simple_exp
 | simple_exp rel_op simple_exp { printf("Executing a relational expression.\n"); }
;

rel_op:
 EQUAL { printf("Relational operator EQUAL.\n"); }
 | LESS { printf("Relational operator LESS.\n"); }
;

simple_exp: term
 | simple_exp add_op term { printf("Executing a simple expression with an add operation.\n"); }
;

add_op:
 ADD_OP { printf("Add operator ADD.\n"); }
 | SUB_OP { printf("Add operator SUB.\n"); }
;

term: factor
 | term mul_op factor { printf("Executing a term with a multiply operation.\n"); }
;

mul_op:
 MUL_OP { printf("Multiply operator MUL.\n"); }
 | DIV_OP { printf("Multiply operator DIV.\n"); }
;

factor: NUMBER { printf("Reading a number.\n"); }
 | ID { printf("Reading an identifier.\n"); }
 | LEFT_PAREN exp RIGHT_PAREN { printf("Executing a parenthesized expression.\n"); }
;

%%

int main() {
 yyin = stdin;

 do {
  yyparse();
 } while (!feof(yyin));

 return 0;
}

void yyerror(const char* s) {
 fprintf(stderr, "Parse error: %s\n", s);
 exit(1);
}
