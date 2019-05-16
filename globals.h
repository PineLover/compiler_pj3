/****************************************************/
/* File: globals.h                                  */
/* Global types and vars for C- compiler          */
/* must come before other include files             */
/* Compiler Construction: Principles and Practice   */
/* Kenneth C. Louden                                */
/****************************************************/

#ifndef _GLOBALS_H_
#define _GLOBALS_H_

#include <stdio.h>
#include <stdlib.h>
#include <ctype.h>
#include <string.h>

#ifndef YYPARSER

//#include "cm.tab.h"
#define ENDFILE 0
#endif

#ifndef FALSE
#define FALSE 0
#endif

#ifndef TRUE
#define TRUE 1
#endif

/* MAXRESERVED = the number of reserved words */
#define MAXRESERVED 8

/* Do not need any more */
//typedef enum 
    /* book-keeping tokens */
//   {ENDFILE,ERROR, COMMENT_ERROR,
    /* reserved words */
// this is TINY    IF,THEN,ELSE,END,REPEAT,UNTIL,READ,WRITE,
    //c minus reserved words
  //  ELSE, IF, INT, RETURN, VOID, WHILE,
       
    /* multicharacter tokens */
  //  ID,NUM,
    /* special symbols */
  // thyisis tiny ASSIGN,EQ,LT,PLUS,MINUS,TIMES,OVER,LPAREN,RPAREN,SEMI
   // this is C minus
 //  PLUS, MINUS, TIMES, OVER, LTE,LT,GTE, GT, EQ, NE, ASSIGN,SEMI, COMMA,LPAREN,RPAREN,LSB,
 //  RSB,LCB,RCB
 //  } TokenType;
//////////////////////////////////////////////
typedef int TokenType;

extern FILE* source; /* source code text file */
extern FILE* listing; /* listing output text file */
extern FILE* code; /* code text file for TM simulator */

extern int lineno; /* source line number for listing */

/**************************************************/
/***********   Syntax tree for parsing ************/
/**************************************************/

typedef enum {StmtK,ExpK, DeclK} NodeKind;// DeclK is delarion part.
//typedef enum {IfK,RepeatK,AssignK,ReadK,WriteK} StmtKind;//statement
typedef enum{ExprK, CompK, SelecK, IterK, RetK, EmptyK}StmtKind;//statement
typedef enum {OpK,ConstK,IdK, IdArrK, CallK} ExpKind;//expression
typedef enum{VarK, VarArrK, ParamK, ParamArrK, ParamVoidK, FuncK, TypeK} DeclKind;// variation, array, parameter, parameterarray, parameter void, funciton, Type

/* ExpType is used for type checking */
typedef enum {Void,Integer,Boolean} ExpType;

#define MAXCHILDREN 3

typedef struct treeNode
   { struct treeNode * child[MAXCHILDREN];
     struct treeNode * sibling;
     int lineno;
     NodeKind nodekind;
     union { StmtKind stmt; ExpKind exp;DeclKind decl;} kind;
     union { TokenType op;
             int val;
             char *name;
             struct {char * name;int size;} arr;} attr;
     ExpType type; /* for type checking of exps */
   } TreeNode;

/**************************************************/
/***********   Flags for tracing       ************/
/**************************************************/

/* EchoSource = TRUE causes the source program to
 * be echoed to the listing file with line numbers
 * during parsing
 */
extern int EchoSource;

/* TraceScan = TRUE causes token information to be
 * printed to the listing file as each token is
 * recognized by the scanner
 */
extern int TraceScan;

/* TraceParse = TRUE causes the syntax tree to be
 * printed to the listing file in linearized form
 * (using indents for children)
 */
extern int TraceParse;

/* TraceAnalyze = TRUE causes symbol table inserts
 * and lookups to be reported to the listing file
 */
extern int TraceAnalyze;

/* TraceCode = TRUE causes comments to be written
 * to the TM code file as code is generated
 */
extern int TraceCode;

/* Error = TRUE prevents further passes if an error occurs */
extern int Error; 
#endif
