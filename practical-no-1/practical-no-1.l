%{
#include <stdio.h>
#include <stdlib.h>
%}

%option noyywrap

DIGIT [0-9]
ID [a-zA-Z_][a-zA-Z0-9_]*
KEYWORD "auto"|"break"|"case"|"char"|"const"|"continue"|"default"|"do"|"double"|"else"|"enum"|"extern"|"float"|"for"|"goto"|"if"|"inline"|"int"|"long"|"register"|"restrict"|"return"|"short"|"signed"|"sizeof"|"static"|"struct"|"switch"|"typedef"|"union"|"unsigned"|"void"|"volatile"|"while"|"_Bool"|"_Complex"|"_Imaginary"
ARITH_OP "+"|"-"|"*"|"/"|"%"
REL_OP "=="|"!="|"<="|">="|"<"|">"
LOGIC_OP "&&"|"||"|"!"
ASSIGN_OP "="|"+="|"-="|"*="|"/="|"%="
INCDEC_OP "++"|"--"
FLOAT_LIT "[0-9]+\\.[0-9]+"
CHAR_LIT "'(\\\\.|.)'"
STRING_LIT "\"[^\"]*\""

/* Punctuation */
PUNCTUATION ";"|","|"."|"("|")"|"{"|"}"|"["|"]"|":"|"?"

/* Special Symbols */
SPECIAL_SYMBOL "@"|"#"|"$"|"%"|"&"|"_"|"~"|"^"



/* Whitespace */
WHITESPACE [ \t\r\n]+

%%

{WHITESPACE}        { printf("Whitespace detected: \"%s\"\n", yytext); }

{KEYWORD}           { printf("Keyword: %s\n", yytext); }

{ID}                { printf("Identifier: %s\n", yytext); }

{ARITH_OP}          { printf("Arithmetic Operator: %s\n", yytext); }
{REL_OP}            { printf("Relational Operator: %s\n", yytext); }
{LOGIC_OP}          { printf("Logical Operator: %s\n", yytext); }
{ASSIGN_OP}         { printf("Assignment Operator: %s\n", yytext); }
{INCDEC_OP}         { printf("Increment/Decrement Operator: %s\n", yytext); }
{DIGIT}           { printf("Integer Literal: %s\n", yytext); }
{FLOAT_LIT}         { printf("Float Literal: %s\n", yytext); }
{CHAR_LIT}          { printf("Character Literal: %s\n", yytext); }
{STRING_LIT}        { printf("String Literal: %s\n", yytext); }
{PUNCTUATION}       { printf("Punctuation: %s\n", yytext); }
{SPECIAL_SYMBOL}    { printf("Special Symbol: %s\n", yytext); }

.                   { printf("Invalid character: %s\n", yytext); }

%%

int main() {
    printf("Enter source code:\n");
    yylex();
    return 0;
}
