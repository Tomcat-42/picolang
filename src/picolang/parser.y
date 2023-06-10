%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include <picolang/picolang.h>
%}

%union {
 int ival;
 char* sval;
 Node node;
}

%token<ival> NUMBER
%token<sval> ID
%token ADD_OP SUB_OP MUL_OP DIV_OP EQUAL LESS
%token LEFT_PAREN RIGHT_PAREN
%token IF THEN ELSE END REPEAT UNTIL READ WRITE
%token SEMICOLON ASSIGN

%type<node> assign_cmd factor
%type<node> exp simple_exp term rel_op add_op mul_op
%type<node> if_cmd repeat_cmd read_cmd write_cmd cmd_seq cmd program

%start program

%%

program:
  cmd_seq {
    printf("%s\n", $1.code);
    free($1.code);
  }
;

cmd_seq: cmd {
    $$ = $1;
}
 | cmd_seq SEMICOLON cmd {
    char* code = malloc(strlen($1.code) + strlen($3.code) + 2);
    sprintf(code, "%s%s", $1.code, $3.code);
    $$ = (Node) { code, createString("") };
    free($1.code);
    free($3.code);
 }
;

cmd: if_cmd
 | repeat_cmd
 | assign_cmd
 | read_cmd
 | write_cmd
;

if_cmd:
  IF exp THEN cmd_seq END {
    char *ifLabel = newLabel();
    char *endLabel = newLabel();

    char* code = malloc(strlen($2.label) + strlen($2.code) + strlen($4.code) + strlen(ifLabel) + strlen(endLabel) + 50);

    int offset = snprintf(code, strlen($2.label) + 3, "%s", $2.label);
    offset += snprintf(code + offset, strlen($2.code) + strlen(ifLabel) + 14, "if (%s) goto %s\n", $2.code, ifLabel);
    offset += snprintf(code + offset, strlen(endLabel) + 8, "goto %s\n", endLabel);
    offset += snprintf(code + offset, strlen(ifLabel) + 4, "%s:\n", ifLabel);
    offset += snprintf(code + offset, strlen($4.code) + 2, "%s", $4.code);
    snprintf(code + offset, strlen(endLabel) + 4, "%s:\n", endLabel);

    $$ = (Node) { code, createString("") };

    free($2.code);
    free($4.code);
  }
|
  IF exp THEN cmd_seq ELSE cmd_seq END {
    char *ifLabel = newLabel();
    char *elseLabel = newLabel();
    char *endLabel = newLabel();

    char* code = malloc(strlen($2.label) + strlen($2.code) + strlen($4.code) + strlen($6.code) + strlen(ifLabel) + strlen(elseLabel) + strlen(endLabel) + 100);

    int offset = snprintf(code, strlen($2.label) + 3, "%s", $2.label);
    offset += snprintf(code + offset, strlen($2.code) + strlen(ifLabel) + 14, "if (%s) goto %s\n", $2.code, ifLabel);
    offset += snprintf(code + offset, strlen(elseLabel) + 8, "goto %s\n", elseLabel);
    offset += snprintf(code + offset, strlen(ifLabel) + 4, "%s:\n", ifLabel);
    offset += snprintf(code + offset, strlen($4.code) + 2, "%s", $4.code);
    offset += snprintf(code + offset, strlen(endLabel) + 8, "goto %s\n", endLabel);
    offset += snprintf(code + offset, strlen(elseLabel) + 4, "%s:\n", elseLabel);
    offset += snprintf(code + offset, strlen($6.code) + 2, "%s\n", $6.code);
    snprintf(code + offset, strlen(endLabel) + 4, "%s:\n", endLabel);

    $$ = (Node) { code, createString("") };

    free($2.code);
    free($4.code);
    free($6.code);
  }
;

repeat_cmd: REPEAT cmd_seq UNTIL exp {
    char* startLabel = newLabel();
    char* endLabel = newLabel();

    trimEnd($2.code);
    trimEnd($4.code);

    char* code = malloc(strlen($2.code) + strlen($4.code) + strlen(startLabel) + strlen(endLabel) + 50);

    sprintf(code, "%s:\n%sif (%s) goto %s\ngoto %s\n%s:\n", startLabel, $2.code, $4.code, endLabel, startLabel, endLabel);
    $$ = (Node) { code, createString("") };

    free($2.code);
    free($4.code);
}
;

assign_cmd: ID ASSIGN exp {
    trimEnd($3.code);
    char* code = malloc(strlen($1) + strlen($3.code) + 5);
    //char* label = createString($1);
    sprintf(code, "%s%s = %s\n", $3.label, $1, $3.code);
    $$ = (Node) { code, createString("") };
    free($3.code);
}
;

read_cmd: READ ID {
    char* code = malloc(strlen($2) + 15);
    sprintf(code, "%s = READ()\n", $2);
    $$ = (Node) { code, createString("") };
}
;

write_cmd: WRITE exp {
    trimEnd($2.code);
    char* code = malloc(strlen($2.code) + 10);
    sprintf(code, "%sWRITE(%s)", $2.label, $2.code);
    $$ = (Node) { code, createString("") };
    free($2.code);
}
;

simple_exp: term {
    $$ = $1;
}
 | simple_exp add_op term {
    char* temp = newTempReg();
    char *label = malloc(strlen(temp) + strlen($1.code) + 20);
    char* code = malloc(strlen(temp) + strlen($2.code) + strlen($3.code) + 20);

    trimEnd($1.label);
    trimEnd($1.code);
    trimEnd($2.code);
    trimEnd($3.code);

    snprintf(label, strlen(temp) + strlen($1.code) + 20, "%s%s = %s\n",$1.label, temp, $1.code);
    snprintf(code, strlen(temp) + strlen($2.code) + strlen($3.code) + 20, "%s %s %s", temp, $2.code, $3.code);

    $$ = (Node) { code, label };

    free($1.code);
    free($2.code);
    free($3.code);
 }
;

exp: simple_exp {
    $$ = $1;
}
 | simple_exp rel_op simple_exp {
    char* temp = newTempReg();
    char* label = malloc(strlen(temp) + strlen($1.code) + 20);
    char* code = malloc(strlen(temp) + strlen($2.code) + strlen($3.code) + 20);

    trimEnd($1.label);
    trimEnd($1.code);
    trimEnd($2.code);
    trimEnd($3.code);

    snprintf(label, strlen(temp) + strlen($1.code) + 20, "%s%s = %s\n",$1.label, temp, $1.code);
    snprintf(code, strlen(temp) + strlen($2.code) + strlen($3.code) + 20, "%s %s %s", temp, $2.code, $3.code);

    $$ = (Node) { code, label };

    free($1.code);
    free($2.code);
    free($3.code);
 }
;

term: factor {
    $$ = $1;
}
 | term mul_op factor {
    char* temp = newTempReg();
    char *label = malloc(strlen(temp) + strlen($1.code) + 20);
    char* code = malloc(strlen(temp) + strlen($2.code) + strlen($3.code) + 20);

    trimEnd($1.label);
    trimEnd($1.code);
    trimEnd($2.code);
    trimEnd($3.code);

    snprintf(label, strlen(temp) + strlen($1.code) + 20, "%s%s = %s\n",$1.label, temp, $1.code);
    snprintf(code, strlen(temp) + strlen($2.code) + strlen($3.code) + 20, "%s %s %s\n", temp, $2.code, $3.code);

    $$ = (Node) { code, label };

    free($1.code);
    free($2.code);
    free($3.code);
 }
;

factor: NUMBER {
    char* str = (char*)malloc(sizeof(char) * 20);
    sprintf(str, "%d", $1);
    $$ = (Node){ str, createString("") };
}
 | ID {
    $$ = (Node){ createString($1), createString("") };
 }
 | LEFT_PAREN exp RIGHT_PAREN {
    $$ = $2;
 }
;


rel_op:
 EQUAL { $$ = (Node) { createString("="), createString("") }; }
 | LESS { $$ = (Node) { createString("<"), createString("") }; }
;

add_op:
 ADD_OP { $$ = (Node) { createString("+"), createString("") }; }
 | SUB_OP { $$ = (Node) { createString("-"), createString("") }; }
;

mul_op:
 MUL_OP { $$ = (Node) { createString("*"), createString("") }; }
 | DIV_OP { $$ = (Node) { createString("/"), createString("") }; }
;

%%
