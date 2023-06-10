#include <stdio.h>
#include <stdlib.h>

#include <picolang/picolang.h>

int main() {
    yyin = stdin;

    do {
        yyparse();
    } while (!feof(yyin));

    return 0;
}
