#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <picolang/picolang.h>

int reg = 0;
int label = 0;

void yyerror(const char* s) {
    fprintf(stderr, "Parse error: %s\n", s);
    exit(1);
}

char* newLabel() {
    char* str = (char*)malloc(sizeof(char) * (2 + snprintf(NULL, 0, "%d", label)));
    sprintf(str, "L%d", label++);
    return str;
}

char* newTempReg() {
    char* str = (char*)malloc(sizeof(char) * (2 + snprintf(NULL, 0, "%d", reg)));
    sprintf(str, "T%d", reg++);
    return str;
}

char* createString(const char* src) {
    if (src == NULL) {
        return NULL;
    }

    char* newStr = malloc(strlen(src) + 1);

    if (newStr == NULL) {
        fprintf(stderr, "Memory allocation failed.\n");
        exit(EXIT_FAILURE);
    }

    strcpy(newStr, src);
    return newStr;
}

void trimEnd(char *str) {
    int len = strlen(str);
    if (len > 0 && str[len-1] == '\n') {
        str[len-1] = '\0';
    }
}
