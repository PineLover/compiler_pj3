/****************************************************/
/* File: cm.y a.k.a cminus file                     */
/* The C- Language Yacc/Bison specification file    */
/* Compiler Construction: Principles and Practice   */
/* Kenneth C. Louden                                */
/****************************************************/
%{
#define YYPARSER /* distinguishes Yacc output from other code files */

#include "globals.h"
#include "util.h"
#include "scan.h"
#include "parse.h"

#define YYSTYPE TreeNode *
#define MAXSIZE 256

static char * savedName[MAXSIZE]; /* for use in assignments */
static int savedLineNo[MAXSIZE];  /* ditto */
static int savedStackTop = 0;
static TreeNode * savedTree; /* stores syntax tree for later return */

static int savedSize;	/* Using for Array range*/
//static int yylex(void);

%}

%token ELSE IF INT RETURN VOID WHILE
%token ID NUM 
%token ASSIGN EQ PLUS MINUS TIMES OVER LTE LT GTE GT NE LPAREN RPAREN SEMI COMMA LSB RSB LCB RCB
%token ERROR

%right ASSIGN
%nonassoc LTE LT GTE GT EQ NE
%left PLUS MINUS
%left TIMES OVER
%nonassoc LOWER_THAN_ELSE
%nonassoc ELSE 

%% /* Grammar for C- */

program		: declaration_list
			{ savedTree = $1;}
		;

declaration_list	: declaration_list declaration
		{  YYSTYPE t = $1;
		   if (t != NULL)
		   { while (t->sibling != NULL)
		       t = t->sibling;
		     t->sibling = $2;
		     $$ = $1;  }
		     else $$ = $2;
		}
		| declaration { $$ = $1; }
		;
declaration 	: var_declaration {$$ = $1;}
		| fun_declaration {$$ = $1;}
		;
var_declaration : type_specifier ID 
			{
				savedName[savedStackTop] = copyString (beforeTokenString);
				savedLineNo[savedStackTop] = lineno;
				savedStackTop++;
			}
			SEMI
			{
				$$ = newDeclNode (VarK);
				$$->child[0] = $1;
				savedStackTop--;
				$$->attr.name = savedName[savedStackTop];
				$$->lineno = savedLineNo[savedStackTop];
			}
		| type_specifier ID 
			{
				savedName[savedStackTop] = copyString (beforeTokenString);
				savedLineNo[savedStackTop] = lineno;
				savedStackTop++;
			}
			LSB NUM {
				savedSize = atoi (tokenString);
			}
			RSB SEMI
			{
				$$ = newDeclNode (VarArrK);
				$$->child[0] = $1;
				savedStackTop--;
				$$->attr.arr.name = savedName[savedStackTop];
				$$->attr.arr.size = savedSize;
				$$->lineno = savedLineNo[savedStackTop];
			}
		;
type_specifier	: INT 
		  { 
			  $$ = newDeclNode(TypeK); 
			  $$->type = Integer;
		  }
		| VOID
		{
			$$ = newDeclNode(TypeK);
			$$->type = Void;
		}
		;
fun_declaration	: type_specifier ID 
		{
		  savedName[savedStackTop] = copyString(beforeTokenString);
		  savedLineNo[savedStackTop] = lineno;
		  savedStackTop++;
		}LPAREN params RPAREN compound_stmt
		{
			$$ = newDeclNode (FuncK);
			$$->child[0] = $1;
			$$->child[1] = $5;
			$$->child[2] = $7;
			savedStackTop--;
			$$->attr.name = savedName[savedStackTop];
			$$->lineno = savedLineNo[savedStackTop];
		}
		;
params		: param_list { $$ = $1; }
		| VOID	{ 
			$$ = newDeclNode (ParamVoidK); 
		}
		;
param_list	: param_list COMMA param
                 { YYSTYPE t = $1;
                   if (t != NULL)
                   { while (t->sibling != NULL)
                        t = t->sibling;
                     t->sibling = $3;
                     $$ = $1; }
                     else $$ = $3;
		  }
		| param { $$ = $1;}
		;
param		: type_specifier ID
		  {
			  $$ = newDeclNode (ParamK);
			  $$->child[0] = $1;
			  $$->attr.name = copyString (beforeTokenString);
		  }
		| type_specifier ID 
		  {
			  savedName[savedStackTop] = copyString (beforeTokenString);
			  savedLineNo[savedStackTop] = lineno;
		 	  savedStackTop++;
		  }
		  LSB RSB
		  {
			  $$ = newDeclNode (ParamArrK);
			  $$->child[0] = $1;
			  savedStackTop--;
			  $$->attr.name = savedName[savedStackTop];
			  $$->lineno = savedLineNo[savedStackTop];
		  }
		;
compound_stmt	: LCB local_declarations statement_list RCB
		{
			$$ = newStmtNode (CompK);
			$$->child[0] = $2;
			$$->child[1] = $3;
		}
		;
local_declarations	: local_declarations var_declaration
	                 { YYSTYPE t = $1;
        	           if (t != NULL)
	                   { while (t->sibling != NULL)
	                        t = t->sibling;
	                     t->sibling = $2;
	                     $$ = $1; }
	                     else $$ = $2;
			  }
			| /* EMPTY */ { $$ = NULL; }
			;
statement_list	: statement_list statement
	                 { YYSTYPE t = $1;
        	           if (t != NULL)
	                   { while (t->sibling != NULL)
	                        t = t->sibling;
	                     t->sibling = $2;
	                     $$ = $1; }
	                     else $$ = $2;
			  }
		| /* EMPTY */ { $$ = NULL; }
		;
statement	: expression_stmt { $$ = $1; }
		| compound_stmt { $$ = $1; }
		| selection_stmt { $$ = $1; }
		| iteration_stmt { $$ = $1; }
		| return_stmt { $$ = $1; }
		;
expression_stmt	: expression SEMI
		{
			$$ = newStmtNode (ExprK);
			$$->child[0] = $1;
		}
		| SEMI { $$ = newStmtNode (EmptyK); }
		;
selection_stmt	: IF LPAREN expression RPAREN statement
		  {
			  $$ = newStmtNode (SelecK);
			  $$->child[0] = $3;
			  $$->child[1] = $5;
		  }	%prec LOWER_THAN_ELSE
		  | IF LPAREN expression RPAREN statement ELSE statement
		  {
			  $$ = newStmtNode (SelecK);
			  $$->child[0] = $3;
			  $$->child[1] = $5;
			  $$->child[2] = $7;
		  }

		;
iteration_stmt	: WHILE LPAREN expression RPAREN statement
		  {
			  $$ = newStmtNode (IterK);
			  $$->child[0] = $3;
			  $$->child[1] = $5;
		  }
		;
return_stmt	: RETURN SEMI { $$ = newStmtNode(RetK);}
		| RETURN expression SEMI
		  {
			  $$ = newStmtNode (RetK);
			  $$->child[0] = $2;
		  }
		;
expression	: var ASSIGN expression
		  {
			  $$ = newExpNode (OpK);
			  $$->child[0] = $1;
			  $$->child[1] = $3;
			  $$->attr.op = ASSIGN;
		  }
		| simple_expression { $$ = $1; }
		;
var		: ID  {
			  $$ = newExpNode (IdK);
			  $$->attr.name = copyString (beforeTokenString);
		  }
		| ID  {
			savedName[savedStackTop] = copyString(beforeTokenString);
			savedLineNo[savedStackTop] = lineno;
			savedStackTop++;
		}
		LSB expression RSB{
			$$ = newExpNode (IdArrK);
			$$->child[0] = $4;
			savedStackTop--;
			$$->attr.name = savedName[savedStackTop];
			$$->lineno = savedLineNo[savedStackTop];
		}
		;
simple_expression	
		: additive_expression LTE additive_expression
		{
			$$ = newExpNode (OpK);
			$$->child[0] = $1;
			$$->child[1] = $3;
			$$->attr.op = LTE;
		}
		| additive_expression LT additive_expression
		{
			$$ = newExpNode (OpK);
			$$->child[0] = $1;
			$$->child[1] = $3;
			$$->attr.op = LT;
		}
		| additive_expression GT additive_expression
		{
			$$ = newExpNode (OpK);
			$$->child[0] = $1;
			$$->child[1] = $3;
			$$->attr.op = GT;
		}
		| additive_expression GTE additive_expression
		{
			$$ = newExpNode (OpK);
			$$->child[0] = $1;
			$$->child[1] = $3;
			$$->attr.op = GTE;
		}
		| additive_expression EQ additive_expression
		{
			$$ = newExpNode (OpK);
			$$->child[0] = $1;
			$$->child[1] = $3;
			$$->attr.op = EQ;
		}
		| additive_expression NE additive_expression
		{
			$$ = newExpNode (OpK);
			$$->child[0] = $1;
			$$->child[1] = $3;
			$$->attr.op = NE;
		}
		| additive_expression{ $$ = $1; }
		;
additive_expression
		: additive_expression PLUS term
		{
			$$ = newExpNode (OpK);
			$$->child[0] = $1;
			$$->child[1] = $3;
			$$->attr.op = PLUS;
		}	
		| additive_expression MINUS term
		{
			$$ = newExpNode (OpK);
			$$->child[0] = $1;
			$$->child[1] = $3;
			$$->attr.op = MINUS;
		}
		| term { $$ = $1; }
		;
term		: term TIMES factor
		{
			$$ = newExpNode (OpK);
			$$->child[0] = $1;
			$$->child[1] = $3;
			$$->attr.op = TIMES;
		}
		| term OVER factor
		{
			$$ = newExpNode (OpK);
			$$->child[0] = $1;
			$$->child[1] = $3;
			$$->attr.op = OVER;
		}
		| factor { $$ = $1; }
		;
factor		: LPAREN expression RPAREN { $$ = $2; }
		| var {$$ = $1;}
		| call {$$ = $1;}
		| NUM 
		{
			$$ = newExpNode (ConstK);
			$$->attr.val = atoi(tokenString);
		}
		;
call		: ID 
		{
			savedName[savedStackTop] = copyString (beforeTokenString);
			savedLineNo[savedStackTop] = lineno;
			savedStackTop++;
		}
		LPAREN args RPAREN
		{
			$$ = newExpNode (CallK);
			$$->child[0] = $4;
			savedStackTop--;
			$$->attr.name = savedName[savedStackTop];
			$$->lineno = savedLineNo[savedStackTop];
		}
		;
args		: arg_list { $$ = $1; }
		| { $$ = NULL; }/* EMPTY */ 
		;
arg_list	: arg_list COMMA expression
	                 { YYSTYPE t = $1;
        	           if (t != NULL)
	                   { while (t->sibling != NULL)
	                        t = t->sibling;
	                     t->sibling = $3;
	                     $$ = $1; }
	                     else $$ = $3;
			  }

		| expression {$$ = $1;}
		;
%%

int yyerror(char * message)
{ fprintf(listing,"Syntax error at line %d: %s\n",lineno,message);
  fprintf(listing,"Current token: ");
  printToken(yychar,tokenString);
  Error = TRUE;
  return 0;
}

/* yylex calls getToken to make Yacc/Bison output
 * compatible with ealier versions of the TINY scanner
 */
int yylex(void)
{ 
	int jjj = getToken();


return jjj; }

TreeNode * parse(void)
{ yyparse();
  return savedTree;
}

