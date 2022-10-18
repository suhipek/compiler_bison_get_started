%{
/****************************************************************************
expr.y
ParserWizard generated YACC file.

Date: 2005年8月22日
****************************************************************************/
#include <ctype.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#ifndef YYSTYPE
#define YYSTYPE char*
#endif

char numStr[50];
char idStr[50];

int yylex();
extern int yyparse();
FILE* yyin;
void yyerror(const char* s);
%}

%token NUMBER
%token ID
%token ADD SUB MUL DIV LBR RBR

%left ADD SUB
%left MUL DIV
%right UMINUS

%%
lines	:	lines expr ';'	{ printf("%s\n", $2); }
		|	lines ';'
		|
		;

expr	:	expr ADD expr	{ $$ = (char *)malloc(50*sizeof(char));
								strcpy($$,$1);strcat($$,$3);strcat($$,"+ "); }
		|	expr SUB expr	{ $$ = (char *)malloc(50*sizeof(char));
								strcpy($$,$1);strcat($$,$3);strcat($$,"- "); }
		|	expr MUL expr	{ $$ = (char *)malloc(50*sizeof(char));
								strcpy($$,$1);strcat($$,$3);strcat($$,"* "); }
		|	expr DIV expr	{ $$ = (char *)malloc(50*sizeof(char));
								strcpy($$,$1);strcat($$,$3);strcat($$,"/ "); }
		|	SUB expr %prec UMINUS	{ $$ = (char *)malloc(50*sizeof(char));
								strcpy($$,"0 ");strcat($$,$2);strcat($$,"- "); }
		|	LBR expr RBR	{ $$ = (char *)malloc(50*sizeof(char));
								strcpy($$,$2); }
		|	NUMBER			{ $$ = (char *)malloc(50*sizeof(char));
								strcpy($$,$1); strcat($$, " "); }
		|	ID				{ $$ = (char *)malloc(50*sizeof(char));
								strcpy($$,$1); strcat($$, " "); }
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
			case ';':
				return ';';
				break;
			default:
				if(isdigit(t)){
					int ti = 0;
					while(isdigit(t)){
						numStr[ti] = t;
						t = getchar();
						ti++;
					}
					numStr[ti] = '\0';
					yylval = numStr;
					ungetc(t, stdin);
					return NUMBER;
				}
				else if(isalpha(t) || t == '_'){
					int ti = 0;
					while(isalpha(t) || isdigit(t) || t == '_'){
						idStr[ti] = t;
						t = getchar();
						ti++;
					}
					idStr[ti] = '\0';
					yylval = idStr;
					ungetc(t, stdin);
					return ID;
				}
				else
					break;
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
}