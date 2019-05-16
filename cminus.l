/*********************************
 FILE : cminus.l
   lex specification for langue Cminus
 
 
************************************ */

%{
/*lexeme of identifier or reserved word 
  reference for tiny.l format       */
#include "globals.h"
#include "util.h"
#include "scan.h"
#include "cm.tab.h"

#define yylex yylexx
char tokenString[MAXTOKENLEN+1];
char beforeTokenString[MAXTOKENLEN+1];
/**/
%}

digit      [0-9]
number     {digit}+
letter     [a-zA-Z]
identifier {letter}+
newline    \n
whitespace [ \t]+

%%
"else"   {return ELSE;}
"if"     {return IF;  }
"int"    {return INT; }
"return" {return RETURN; }
"void"   {return VOID;  }
"while"  {return WHILE; }


"+"     {return PLUS;}
"-"     {return MINUS;}
"*"     {return TIMES;}
"/"     {return OVER; }
"<="    {return LTE; }
"<"     {return LT; }
">="    {return GTE;}
">"     {return GT; }
"=="    {return EQ; }
"!="    {return NE; }
"="     {return ASSIGN; }
";"     {return SEMI;   }
","     {return COMMA; }
"("     {return LPAREN; }
")"     {return RPAREN; }
"["     {return LSB;}
"]"     {return RSB; }
"{"     {return LCB; }
"}"     {return RCB; }



"/*"    {register int c;
         for(;;)
         { while((c=input()) != '*' && c != EOF){
             ;            
                if(c=='\n') lineno++;    
            }                                  
             if(c == '*')
             {
                while((c=input())=='*'){;
                
                if(c=='\n')lineno++;
                }
                if(c=='/') {
                    break;
                }
                else if(c == '\n') lineno++;
             }
             if(c==EOF){
               //  return COMMENT_ERROR;
             }
         }


}
{number}        {return NUM;}
{identifier}    {return ID;}
{newline}       {lineno++;}
{whitespace}    {/*skip whitespace*/}

.               {return ERROR;}

%%

TokenType getToken(void)
{ static int firstTime = TRUE;
    TokenType currentToken;
    if (firstTime)
    { firstTime = FALSE;
        lineno++;
        yyin = source;
        yyout = listing;
    }
    currentToken = yylex();
    strncpy(beforeTokenString,tokenString,MAXTOKENLEN);
    strncpy(tokenString, yytext, MAXTOKENLEN);
    if (TraceScan) {
       // fprintf(listing,"\t%d: ",lineno);
   //     fprintf(listing,"\t%d  ", lineno);
        printToken(currentToken,tokenString);
    }
    return currentToken;
}










