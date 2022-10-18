%{
/****************************************************************************
expr.y
ParserWizard generated YACC file.

Date: 2005年8月22日
****************************************************************************/
#include <ctype.h>
#include <stdio.h>
#include <stdlib.h>
#ifndef YYSTYPE
#define YYSTYPE double
#endif

int yylex();
extern int yyparse();
FILE* yyin;
void yyerror(const char* s);
%}

%token NUMBER
%token ADD SUB MUL DIV LBR RBR
%left ADD SUB
%left MUL DIV
%right UMINUS

%%
lines	:	lines expr ';'	{ printf("%f\n", $2); }
		|	lines ';'
		|
		;

expr	:	expr ADD expr	{ $$ = $1 + $3; }
		|	expr SUB expr	{ $$ = $1 - $3; }
		|	expr MUL expr	{ $$ = $1 * $3; }
		|	expr DIV expr	{ $$ = $1 / $3; }
		|	LBR expr RBR	{ $$ = $2; }
		|	SUB expr %prec UMINUS	{ $$ = -$2; }
		|	NUMBER
		;
%%

int yylex(void)
{	
	int t;
	while(1){
		t = getchar();
		switch(t){
			case '+': 
				return ADD;
				break;
			case '-':
				return SUB;
				break;
			case '*':
				return MUL;
				break;
			case '/':
				return DIV;
				break;
			case '(':
				return LBR;
				break;
			case ')':
				return RBR;
				break;
			default:
				if(isdigit(t)){
					yylval = 0;
					while(isdigit(t)){
						yylval = yylval * 10 + t - '0';
						t = getchar();
					}
					ungetc(t, stdin);
					return NUMBER;
				}
				else if(t == '\n' || t == ' ' || t == '\t')
					break;
				else
					return t;
		};
	}
}

int main(void)
{
    yyin = stdin;
    do{
        yyparse();
    }while(!feof(yyin));
	return 0;
}

void yyerror(const char* s)
{
    fprintf(stderr, "Parse error: %s\n", s);
    exit(1);
}