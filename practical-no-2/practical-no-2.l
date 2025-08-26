%{
#include <stdio.h>
#include <string.h>
#include <ctype.h>
#include <stdlib.h>

#define MAX 100

typedef struct {
    char name[50];
    char datatype[20];
    char scope[10];  // global or main
    int size;        // memory usage
} Symbol;

Symbol table[MAX];
int symbolCount = 0;

const char* keywords[] = {
    "int", "float", "char", "double", "long", "short", "unsigned", "signed",
    "void", "if", "else", "while", "for", "do", "return", "switch", "case",
    "default", "break", "continue", "sizeof", "struct", "union", "typedef",
    "static", "enum", "goto", "const", "volatile", "register", "extern", "auto", "main"
};
int keywordCount = sizeof(keywords) / sizeof(keywords[0]);

char currentScope[10] = "global";
char currentDatatype[20] = "";
int inDeclaration = 0; // Flag for declaration state

int getSize(const char* dtype) {
    if (strcmp(dtype, "int") == 0) return 4;
    if (strcmp(dtype, "float") == 0) return 4;
    if (strcmp(dtype, "double") == 0) return 8;
    if (strcmp(dtype, "char") == 0) return 1;
    if (strcmp(dtype, "void") == 0) return 0;
    return 0;
}

// Return 1 if keyword, 0 otherwise
int isKeyword(const char* word) {
    for (int i = 0; i < keywordCount; i++) {
        if (strcmp(word, keywords[i]) == 0) return 1;
    }
    return 0;
}

int isDuplicate(const char* name, const char* scope) {
    for (int i = 0; i < symbolCount; i++) {
        if (strcmp(table[i].name, name) == 0 && strcmp(table[i].scope, scope) == 0) {
            return 1;
        }
    }
    return 0;
}

void addSymbol(const char* name, const char* dtype, const char* scope) {
    if (isKeyword(name)) {
        printf("Error: '%s' is a keyword and cannot be used as an identifier\n", name);
        return;
    }
    if (isDuplicate(name, scope)) {
        printf("Error: Multiple declaration of identifier '%s' in scope '%s'\n", name, scope);
        return;
    }

    strcpy(table[symbolCount].name, name);
    strcpy(table[symbolCount].datatype, dtype);
    strcpy(table[symbolCount].scope, scope);
    table[symbolCount].size = getSize(dtype);
    symbolCount++;
}

void displaySymbolTable() {
    printf("\nSymbol Table:\n");
    printf("%-15s %-10s %-10s %-10s\n", "Identifier", "Datatype", "Scope", "Size");
    printf("----------------------------------------------------------\n");
    for (int i = 0; i < symbolCount; i++) {
        printf("%-15s %-10s %-10s %-10d\n",
               table[i].name,
               table[i].datatype,
               table[i].scope,
               table[i].size);
    }
}
%}

%option noyywrap

ID      [a-zA-Z_][a-zA-Z0-9_]*
TYPE    int|float|double|char|void
WS      [ \t\r\n]+

%%

"end"               { displaySymbolTable(); exit(0); }
{TYPE}              { strcpy(currentDatatype, yytext); inDeclaration = 1; }
{ID}                { 
                      if (inDeclaration) {
                          addSymbol(yytext, currentDatatype, currentScope);
                      }
                      else if (strcmp(yytext, "main") == 0 && strcmp(currentScope, "global") == 0) {
                          strcpy(currentScope, "main");
                      }
                    }
";"                 { inDeclaration = 0; currentDatatype[0] = '\0'; }
"}"                 { 
                      if (strcmp(currentScope, "main") == 0) {
                          strcpy(currentScope, "global");
                      }
                      inDeclaration = 0;
                      currentDatatype[0] = '\0';
                    }
","                 { /* Ignore commas in declarations */ }
{WS}                { /* ignore whitespace */ }
[(){}=]             { /* ignore brackets, parentheses, commas, semicolons, equals */ }
.                   { /* ignore any other character */ }

%%

int main() {
    printf("Enter code lines (type 'end' to finish):\n");
    yylex();
    return 0;
}