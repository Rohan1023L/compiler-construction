%{
#include <stdio.h>
#include <stdlib.h>

void E();
void E_prime();
void T();
void T_prime();
void F();

int yylex();
void yyerror(const char *s);
int lookahead;

%}

%%
[a-z]        return 'i';    
[+]          return '+';     
[*]          return '*';    
[ \t\n]      ;              
.            return yytext[0];
%%

void yyerror(const char *s)
{
    printf("Syntax Error: %s\n", s);
    exit(1);
}

// E → T E'
void E() {
    T();
    E_prime();
}

// E'→ + T E' | ε
void E_prime() {
    if (lookahead == '+') {
        lookahead = yylex();
        T();
        E_prime();
    }
    // else ε
}

// T → F T'
void T() {
    F();
    T_prime();
}

// T'→ * F T' | ε
void T_prime() {
    if (lookahead == '*') {
        lookahead = yylex();
        F();
        T_prime();
    }
    // else ε
}

// F → i
void F() {
    if (lookahead == 'i') {
        lookahead = yylex();
    } else {
        yyerror("Unexpected symbol in F()");
    }
}

int main() {
    printf("Enter expression: ");
    lookahead = yylex();

    E();

    if (lookahead == 0) {
        printf("String Accepted\n");
    } else {
        yyerror("Extra symbols at the end");
    }
    return 0;
}
