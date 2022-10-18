%{
/****************************************************************************
expr.y
ParserWizard generated YACC file.

Date: 2005年8月22日
****************************************************************************/
#include <ctype.h>
#include <stdio.h>
#include <stdlib.h>
#include <iostream>
#include <string>
#include <map>

#ifndef YYSTYPE
#define YYSTYPE string
#endif

using namespace std;

map<string, string> symtab;
char idStr[50];

int yylex();
extern int yyparse();
FILE* yyin;
void yyerror(const char* s);


%}

%token NUMBER ID
%token ADD SUB MUL DIV LBR RBR EQ
%right EQ
%left ADD SUB
%left MUL DIV
%right UMINUS

%%
lines	:	lines expr ';'	{ printf("%s\n", $2.c_str()); }
		|	lines ';'
		|
		;

expr	:	expr ADD expr	{ $$ = to_string(stoi($1)+stoi($3)); }
		|	expr SUB expr	{ $$ = to_string(stoi($1)-stoi($3)); }
		|	expr MUL expr	{ $$ = to_string(stoi($1)*stoi($3)); }
		|	expr DIV expr	{ $$ = to_string(stoi($1)/stoi($3)); }
		|	SUB expr %prec UMINUS	{ $$ = to_string(0 - stoi($2)); }
        |	LBR expr RBR	{ $$ = $2; }
        |   ID EQ expr      { symtab[$1] = $3; $$ = $3; }
		|	NUMBER          { $$ = $1; }
		|   ID			    { $$ = (symtab.find($1) == symtab.end()) ? "0" : symtab[$1]; }
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
            case '=':
                return EQ;
                break;
			default:
				if(isdigit(t)){
					int nowval = 0;
					while(isdigit(t)){
						nowval = nowval * 10 + t - '0';
						t = getchar();
					}
                    yylval = to_string(nowval);
					ungetc(t, stdin);
					return NUMBER;
				}
                else if(isalpha(t) || t == '_'){
					int ti=0;
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