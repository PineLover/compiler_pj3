/****************************************************/
/* File: util.c                                     */
/* Utility function implementation                  */
/* for the C- compiler                            */
/* Compiler Construction: Principles and Practice   */
/* Kenneth C. Louden                                */
/****************************************************/

#include "globals.h"
#include "util.h"
#include "cm.tab.h"
/* Procedure printToken prints a token 
 * and its lexeme to the listing file
 */
    void printToken( TokenType token, const char* tokenString )
{ switch (token)
    { /* C- language lexical analyze part
    */
        case ELSE:
            fprintf(listing," \t\tELSE\t\t%s\n",tokenString);
            break;
        case IF:

            fprintf(listing," \t\tIF\t\t%s\n",tokenString);
            break;
        case INT:

            fprintf(listing," \t\tINT\t\t%s\n",tokenString);
            break;
        case RETURN:

            fprintf(listing," \t\tRETURN\t\t%s\n",tokenString);
            break;
        case VOID:

            fprintf(listing," \t\tVOID\t\t%s\n",tokenString);
            break;
        case WHILE:

            fprintf(listing," \t\tWHILE\t\t%s\n",tokenString);
            break;
        case ID:
            fprintf(listing," \t\tID\t\t%s\n",tokenString);

            break;
        case NUM:
            fprintf(listing," \t\tNUM\t\t%s\n",tokenString);

            break;
        case PLUS:
            fprintf(listing,"+\t\t%s\n",tokenString);

            break;
        case MINUS:

            fprintf(listing,"-\t\t%s\n",tokenString);
            break;
        case TIMES:
            fprintf(listing,"*\t\t%s\n",tokenString);

            break;
        case OVER:
            fprintf(listing,"/\t\t%s\n",tokenString);

            break;
        case LTE:
            fprintf(listing,"<=\t\t%s\n",tokenString);

            break;
        case LT:
            fprintf(listing,"<\t\t%s\n",tokenString);

            break;
        case GTE:
            fprintf(listing,">=\t\t%s\n",tokenString);

            break;
        case GT:
            fprintf(listing,">\t\t%s\n",tokenString);

            break;
        case EQ:
            fprintf(listing,"==\t\t%s\n",tokenString);

            break;
        case NE:
            fprintf(listing,"!=\t\t%s\n",tokenString);

            break;
        case ASSIGN:
            fprintf(listing,"=\t\t%s\n",tokenString);

            break;
        case SEMI:
            fprintf(listing," \t\t;\t\t%s\n",tokenString);

            break;
        case COMMA:
            fprintf(listing," \t\t,\t\t%s\n",tokenString);

            break;
        case LPAREN:
            fprintf(listing," \t\t(\t\t%s\n",tokenString);

            break;
        case RPAREN:
            fprintf(listing," \t\t)\t\t%s\n",tokenString);

            break;
        case LSB:
            fprintf(listing," \t\t[\t\t%s\n",tokenString);

            break;
        case RSB:
            fprintf(listing," \t\t]\t\t%s\n",tokenString);

            break;
        case LCB:
            fprintf(listing," \t\t{\t\t%s\n",tokenString);

            break;
        case RCB:
            fprintf(listing," \t\t}\t\t%s\n",tokenString);

            break;
        case ERROR:
            fprintf(listing," \t\tERROR\t\t%s\n",tokenString);
            /* case COMMENT_ERROR:
               fprintf(listing," \t\tERROR\t\tComment Error\n");

               break;*/
        case ENDFILE:
            fprintf(listing," \t\tEOF\t\t%s\n", tokenString);

            break;
        default: // should never happen 
            fprintf(listing,"unknown token: %d\n",token);

    }
}

/* Function newStmtNode creates a new statement
 * node for syntax tree construction
 */
TreeNode * newStmtNode(StmtKind kind)
{ TreeNode * t = (TreeNode *) malloc(sizeof(TreeNode));
    int i;
    if (t==NULL)
        fprintf(listing,"Out of memory error at line %d\n",lineno);
    else {
        for (i=0;i<MAXCHILDREN;i++) t->child[i] = NULL;
        t->sibling = NULL;
        t->nodekind = StmtK;
        t->kind.stmt = kind;
        t->lineno = lineno;
    }
    return t;
}

/* Function newExpNode creates a new expression 
 * node for syntax tree construction
 */
TreeNode * newExpNode(ExpKind kind)
{ TreeNode * t = (TreeNode *) malloc(sizeof(TreeNode));
    int i;
    if (t==NULL)
        fprintf(listing,"Out of memory error at line %d\n",lineno);
    else {
        for (i=0;i<MAXCHILDREN;i++) t->child[i] = NULL;
        t->sibling = NULL;
        t->nodekind = ExpK;
        t->kind.exp = kind;
        t->lineno = lineno;
        t->type = Void;
    }
    return t;
}
TreeNode * newDeclNode(DeclKind kind)
{
    TreeNode *t = (TreeNode*)malloc(sizeof(TreeNode));
    int i;
    if(t==NULL)
        fprintf(listing,"Out of memory error at line %d\n", lineno);
    else{
        for(i=0; i<MAXCHILDREN; i++) t->child[i] = NULL;
        t->sibling = NULL;
        t->nodekind = DeclK;
        t->kind.decl = kind;
        t->lineno = lineno;
    }
    return t;
}


/* Function copyString allocates and makes a new
 * copy of an existing string
 */
char * copyString(char * s)
{ int n;
    char * t;
    if (s==NULL) return NULL;
    n = strlen(s)+1;
    t = malloc(n);
    if (t==NULL)
        fprintf(listing,"Out of memory error at line %d\n",lineno);
    else strcpy(t,s);
    return t;
}

/* Variable indentno is used by printTree to
 * store current number of spaces to indent
 */
static indentno = 0;

/* macros to increase/decrease indentation */
#define INDENT indentno+=2
#define UNINDENT indentno-=2

/* printSpaces indents by printing spaces */
static void printSpaces(void)
{ int i;
    for (i=0;i<indentno;i++)
        fprintf(listing," ");
}
/*
 *
 *procedure printOperatr prints a styntax tree to the listing file
 *
 * */

void printOperator(TokenType token)
{
    switch(token)
    {

        case ASSIGN: fprintf(listing,"=\n"); break;
        case EQ: fprintf(listing,"==\n"); break;
        case PLUS: fprintf(listing,"+\n"); break;
        case MINUS: fprintf(listing,"-\n"); break;
        case TIMES: fprintf(listing,"*\n"); break;
        case OVER: fprintf(listing,"/\n"); break;
        case LTE: fprintf(listing,"<=\n"); break;
        case LT: fprintf(listing,"<\n"); break;
        case GTE: fprintf(listing,">=\n"); break;
        case GT: fprintf(listing,">\n"); break;
        case NE: fprintf(listing,"!=\n"); break;
    }
}


/* procedure printTree prints a syntax tree to the 
 * listing file using indentation to indicate subtrees
 */
void printExpresesion(TreeNode *tree, ExpKind exp)
{
    switch (exp) {
        case OpK:
            fprintf(listing,"Op: ");
            printOperator(tree->attr.op);
            break;
        case ConstK:
            fprintf(listing,"Const: %d\n",tree->attr.val);
            break;
        case IdK:
            fprintf(listing,"Id: %s\n",tree->attr.name);
            break;
        case IdArrK:// ID is array.
            fprintf(listing,"Id: %s\n", tree->attr.arr.name);
            break;
        case CallK:
            fprintf(listing,"Call Function : %s\n", tree->attr.name);
            break;

        default:
            fprintf(listing,"Unknown ExpNode kind\n");
            break;
    }

}
void printStatement(TreeNode *tree, StmtKind stmt)
{
    switch(stmt){

        case ExprK:
            fprintf(listing,"Expression statement\n");
            break;
        case CompK:
            fprintf(listing,"Compound statement\n");
            break;
        case SelecK:
            fprintf(listing,"If- Else statement\n");
            break;
        case IterK:
            fprintf(listing,"While Iterative Statement\n");//Iterative Statement
            break;
        case RetK:
            fprintf(listing,"Return\n");// Return Statement;
            break;
        case EmptyK:
            fprintf(listing,"Empty statement\n");
            break;
        default:
            break;
    }




}
void printType(ExpType type)
{

    switch(type){
        case Integer :

            fprintf(listing,"Type : Int\n");
            break;
        case Void :
            fprintf(listing,"Type : Void\n");
            break;
        default :
            fprintf(listing,"Unknown Type\n");
            break;


            /*  default:
                fprintf(listing,"Unknown ExpNode kind\n");
                break;*/
    }

}
void printDelaration(TreeNode *tree, DeclKind decl)
{
    switch (decl){

        case VarK:
            fprintf(listing,"Variable Declaration : %s\n ", tree->attr.name);
            break;
        case VarArrK:
            fprintf(listing,"Variable Array Delaration : %s  \n",tree->attr.arr.name);
            fprintf(listing,"Size : %d\n",tree->attr.arr.size);
            break;
        case ParamK:
            fprintf(listing,"Parameter Id: %s\n",tree->attr.name);
            break;
        case ParamArrK:
            fprintf(listing,"Parameter Array Id: %s\n",tree->attr.name);
            break;
        case ParamVoidK:
            fprintf(listing,"No Parameter\n");
            break;
        case FuncK:
            fprintf(listing,"Function Declaration : %s\n",tree->attr.name);
            break;
        case TypeK:
            printType(tree->type);
        default:
            fprintf(listing,"Unknown ExpNode kind\n");
            break;
    }

}
void printTree( TreeNode * tree )
{   int i;
    INDENT;
    while (tree != NULL) {
        printSpaces();
        if (tree->nodekind==StmtK){ 

            printStatement(tree, tree->kind.stmt);

        }
        else if (tree->nodekind==ExpK){ 

            printExpresesion(tree, tree->kind.exp);

        }
        else if(tree->nodekind == DeclK){

            switch (tree->kind.decl){
                case VarK:
                    fprintf(listing,"Variable Declaration : %s\n ", tree->attr.name);
                    break;

                case VarArrK:
                    fprintf(listing,"Variable Array Delaration : %s  ",tree->attr.arr.name);
                    
                    fprintf(listing,"Size : %d\n",tree->attr.arr.size);
                    break;
                case ParamK:
                    fprintf(listing,"Parameter Id: %s\n",tree->attr.name);

                    break;
                case ParamArrK:
                    fprintf(listing,"Parameter Array Id: %s\n",tree->attr.name);

                    break;
                case ParamVoidK:
                    fprintf(listing,"No Parameter\n");

                    break;
                case FuncK:
                    fprintf(listing,"Function Declaration : %s\n",tree->attr.name);

                    break;
                case TypeK:
                    printType(tree->type);
                    break;
                default:
                    fprintf(listing,"Unknown ExpNode kind\n");
                    break;
            }
        }

        else fprintf(listing,"Unknown node kind\n");
        for (i=0;i<MAXCHILDREN;i++)
            printTree(tree->child[i]);
        tree = tree->sibling;
    }
    UNINDENT;
}

