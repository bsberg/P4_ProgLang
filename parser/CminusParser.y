/*******************************************************/
/*                     Cminus Parser                   */
/*                                                     */
/*******************************************************/

/*********************DEFINITIONS***********************/
%{
#include <stdio.h>
#include <stdlib.h>
#include <strings.h>
#include <string.h>
#include <util/general.h>
#include <util/symtab.h>
#include <util/symtab_stack.h>
#include <util/dlink.h>
#include <util/string_utils.h>
#include <codegen/symfields.h>
#include <codegen/types.h>
#include <codegen/codegen.h>
#include <codegen/reg.h>
#include <stdbool.h>

#define SYMTABLE_SIZE 100

/*********************EXTERNAL DECLARATIONS***********************/

EXTERN(void,Cminus_error,(char*));

EXTERN(int,Cminus_lex,(void));

// took all sytabs turned them into lastSymtab(stack)

//SymTable symtab;
SymtabStack stack;


int symCount = 0;

static DList instList;
static DList dataList;
DLinkNode * temp;
int d = 0;
int i;
int * globalSize;

char *fileName;

static int functionOffset;
int globalOffset = 0;

static char* functionName;

extern union YYSTYPE yylval;

extern int Cminus_lineno;

%}

%name-prefix="Cminus_"
%defines

%start Program

%token AND
%token ELSE
%token EXIT
%token FLOAT
%token FOR
%token IF 		
%token INTEGER 
%token NOT 		
%token OR 		
%token READ
%token WHILE
%token WRITE
%token LBRACE
%token RBRACE
%token LE
%token LT
%token GE
%token GT
%token EQ
%token NE
%token ASSIGN
%token COMMA
%token SEMICOLON
%token LBRACKET
%token RBRACKET
%token LPAREN
%token RPAREN
%token PLUS
%token TIMES
%token IDENTIFIER
%token DIVIDE
%token RETURN
%token STRING	
%token INTCON
%token FLOATCON
%token MINUS

%left OR
%left AND
%left NOT
%left LT LE GT GE NE EQ
%left PLUS MINUS
%left TIMES DIVDE

%union {
	char*	name;
	int     symIndex;
	DList	idList;
	int 	offset;
}

%type <idList> IdentifierList
%type <symIndex> Type TestAndThen Test WhileExpr WhileToken Expr SimpleExpr AddExpr
%type <symIndex> MulExpr Factor Variable StringConstant Constant VarDecl FunctionDecl ProcedureHead
%type <offset> DeclList
%type <name> IDENTIFIER STRING FLOATCON INTCON 

/***********************PRODUCTIONS****************************/
%%
Program		: Procedures 
		{
			//emitExit(instList);
			emitDataPrologue(dataList);
			emitInstructions(instList);
			
		}
	  	| DeclList Procedures
		{
			//emitExit(instList);
			globalOffset = $1;
			//getKey($1/4);
			//globalSize = $1/4;
			//printf("%d", $1/4);
			emitDataPrologue(dataList);
			emitInstructions(instList);


		}
          ;

Procedures 	: ProcedureDecl Procedures
	   	|
	   	;

ProcedureDecl : ProcedureHead ProcedureBody
               {

				emitExit(instList);

               }
	      ;

ProcedureHead : FunctionDecl DeclList 
		{
			emitProcedurePrologue(instList, lastSymtab(stack) ,$1, $2); 
			functionOffset = $2;
			//printf("%d\n", $2);
			// char * dec = (char*)malloc(200);
			// sprintf(dec, "        subq $%d, %%rsp", $1 );
			// temp = dlinkNodeAlloc(dec);
			// dlinkAppend(instList , temp );
			//beginScope(stack); // creates new sytab and adds to stack 
			
			$$ = $1; // adds full local stack 
			
		}
	      | FunctionDecl
		{
			emitProcedurePrologue(instList, lastSymtab(stack) ,$1, 0);
			//beginScope(stack);
			// char * dec = (char*)malloc(200);
			// sprintf(dec, "        subq $%d, %%rsp", 0 );
			// temp = dlinkNodeAlloc(dec);
			// dlinkAppend(instList , temp );
			functionOffset = 0;
			
			$$ = $1;
			
		}
              ;

FunctionDecl :  Type IDENTIFIER LPAREN RPAREN LBRACE 
		{
			beginScope(stack);
			$$ = SymIndex(lastSymtab(stack),$2);

		}
	      	;

ProcedureBody : StatementList RBRACE
	      ;


DeclList 	: Type IdentifierList  SEMICOLON // ------------------------------------------------------<<
		{
			AddIdStructPtr data = (AddIdStructPtr)malloc(sizeof(AddIdStruct));
			data->offset = 0;
			data->symtab = currentSymtab(stack); // last or current
            data->typeIndex = $1;
			dlinkApply1($2,(DLinkApply1Func)addIdToSymtab,(Generic)data);
			$$ = data->offset;
			dlinkFreeNodes($2);
			free(data);
		}		
	   		| DeclList Type IdentifierList SEMICOLON
	 	{
			AddIdStructPtr data = (AddIdStructPtr)malloc(sizeof(AddIdStruct));
			data->offset = $1;
			data->typeIndex = $2;
			data->symtab = currentSymtab(stack); // last to current 
			dlinkApply1($3,(DLinkApply1Func)addIdToSymtab,(Generic)data);
			$$ = data->offset;
			dlinkFreeNodes($3);
			free(data);
	 	}
          	;


IdentifierList 	: VarDecl  
		{
			$$ = dlinkListAlloc(NULL);
			dlinkAppend($$,dlinkNodeAlloc((Generic)$1));
		}
						
                | IdentifierList COMMA VarDecl
		{
			dlinkAppend($1,dlinkNodeAlloc((Generic)$3));
			$$ = $1;
		}
                ;

VarDecl 	: IDENTIFIER
		{ 
			$$ = SymIndex(currentSymtab(stack),$1);
		}
		| IDENTIFIER LBRACKET INTCON RBRACKET
		{
			int symIndex = SymIndex(currentSymtab(stack),$3);
                	char* numElemString = 
                		(char*)SymGetFieldByIndex(currentSymtab(stack),symIndex,SYM_NAME_FIELD);
                		
                	char* typeString = 
                		nssave(4,SYMTAB_VOID_TYPE_STRING,"[",numElemString,"]");
                		
                	int typeIndex = SymIndex(currentSymtab(stack),typeString);
                	SymPutFieldByIndex(currentSymtab(stack),typeIndex,SYMTAB_BASIC_TYPE_FIELD,(Generic)VOID_TYPE);
                	
                	int numElements = atoi(numElemString);
                	SymPutFieldByIndex(currentSymtab(stack),typeIndex,SYMTAB_SIZE_FIELD,(Generic)(VOID_SIZE*numElements));
                	int new = numElements*4;
                	//printf("%d\n", new);			   
                	sfree(typeString);

			symIndex = SymIndex(currentSymtab(stack),$1);
                	SymPutFieldByIndex(currentSymtab(stack),symIndex,SYMTAB_TYPE_INDEX_FIELD,(Generic)typeIndex);
                	SymPutFieldByIndex(currentSymtab(stack),symIndex,SYMTAB_SIZE_FIELD,(Generic)new);

			$$ = symIndex;		  
		}
		;

Type     	: INTEGER 
                {
                        $$ = SymQueryIndex(lastSymtab(stack),SYMTAB_INTEGER_TYPE_STRING);
                }
                | FLOAT   
                ;

Statement 	: Assignment{
			// char * dec = (char*)malloc(200);
			// sprintf(dec, "        >>>popq " );
			// temp = dlinkNodeAlloc(dec);
			// dlinkAppend(instList , temp );
			}
                | IfStatement
		| WhileStatement
                | IOStatement 
		| ReturnStatement{
			
		}
		| ExitStatement	
		| CompoundStatement
                ;

Assignment      : Variable ASSIGN Expr SEMICOLON
		{
			// char * dec = (char*)malloc(200);
			// sprintf(dec, "        popq %s ",get64bitIntegerRegisterName(symtab, $1) );
			// temp = dlinkNodeAlloc(dec);
			// dlinkAppend(instList , temp );
			//printf("%d, %d, %s", $1, $3, (char*)SymGetFieldByIndex(symtab,$1,SYM_NAME_FIELD));
			emitAssignment(instList,lastSymtab(stack),$1,$3);
		}
                ;

IfStatement	: IF TestAndThen ELSE CompoundStatement
		{
			emitEndBranchTarget(instList,lastSymtab(stack),$2);
		}
		| IF TestAndThen
		{
			emitEndBranchTarget(instList,lastSymtab(stack),$2);
		}
		;
		
				
TestAndThen	: Test CompoundStatement
		{
		   	$$ = emitThenBranch(instList,lastSymtab(stack),$1);
		}
		;
				
Test		: LPAREN Expr RPAREN
		{
			$$ = emitIfTest(instList,lastSymtab(stack),$2);
		}
		;
	

WhileStatement  : WhileToken WhileExpr Statement
		{
			emitWhileLoopBackBranch(instList,lastSymtab(stack),$1,$2);
		}
                ;
                
WhileExpr	: LPAREN Expr RPAREN
		{
			$$ = emitWhileLoopTest(instList,lastSymtab(stack),$2);
		}
		;
				
WhileToken	: WHILE
		{
			$$ = emitWhileLoopLandingPad(instList,lastSymtab(stack));
		}
		;
				
IOStatement     : READ LPAREN Variable RPAREN SEMICOLON
		{
			emitReadVariable(instList,lastSymtab(stack),$3);
		}
                | WRITE LPAREN Expr RPAREN SEMICOLON
		{
			emitWriteExpression(instList,lastSymtab(stack),$3,SYSCALL_PRINT_INTEGER);
		}
                | WRITE LPAREN StringConstant RPAREN SEMICOLON         
		{
			emitWriteExpression(instList,lastSymtab(stack),$3,SYSCALL_PRINT_STRING);
		}
                ;

ReturnStatement : RETURN Expr SEMICOLON{


					char * dec = (char*)malloc(200);
					//char * ret = (char*)malloc(200);
					char * pop = (char*)malloc(200);
					sprintf(dec, "        movl %s, %%eax", (char*)SymGetFieldByIndex(lastSymtab(stack), $2, SYM_NAME_FIELD) );
					//sprintf(pop, "        popq %%rbp");
					//sprintf(ret, "        ret");
					temp = dlinkNodeAlloc(dec);
					dlinkAppend(instList , temp );
					//temp = dlinkNodeAlloc(pop);
					//dlinkAppend(instList , temp );
					// temp = dlinkNodeAlloc(ret);
					// dlinkAppend(instList , temp );

					char *symReg = (char*)SymGetFieldByIndex(lastSymtab(stack), $2, SYM_NAME_FIELD);
					int tregIndex = SymIndex(currentSymtab(stack),symReg);
					
					//freeIntegerRegister(tregIndex);
					//printf("%s %d",symReg, $2);
					// frees all regs in func before return 
					freeIntegerRegister((int)SymGetFieldByIndex(lastSymtab(stack),$2,SYMTAB_REGISTER_INDEX_FIELD));

					// for( i = 0; i < NUM_INTEGER_REGISTERS; i++ ){
					// 	freeIntegerRegister(i);
					// }
					//endScope(stack);

					
					
				}
                ;

ExitStatement 	: EXIT SEMICOLON
		{
			endScope(stack);
			emitExit(instList);
			 
		}
		;

CompoundStatement : LBRACE StatementList RBRACE
                ;

StatementList   : Statement
		
                | StatementList Statement
		
                ;

Expr            : SimpleExpr
		{
			$$ = $1; 
		}
                | Expr OR SimpleExpr 
		{
			$$ = emitOrExpression(instList,lastSymtab(stack),$1,$3);
		}
                | Expr AND SimpleExpr 
		{
			$$ = emitAndExpression(instList,lastSymtab(stack),$1,$3);
		}
                | NOT SimpleExpr 
		{
			$$ = emitNotExpression(instList,lastSymtab(stack),$2);
		}
                ;

SimpleExpr	: AddExpr
		{
			$$ = $1; 
		}
                | SimpleExpr EQ AddExpr
		{
			$$ = emitEqualExpression(instList,lastSymtab(stack),$1,$3);
		}
                | SimpleExpr NE AddExpr
		{
			$$ = emitNotEqualExpression(instList,lastSymtab(stack),$1,$3);
		}
                | SimpleExpr LE AddExpr
		{
			$$ = emitLessEqualExpression(instList,lastSymtab(stack),$1,$3);
		}
                | SimpleExpr LT AddExpr
		{
			$$ = emitLessThanExpression(instList,lastSymtab(stack),$1,$3);
		}
                | SimpleExpr GE AddExpr
		{
			$$ = emitGreaterEqualExpression(instList,lastSymtab(stack),$1,$3);
		}
                | SimpleExpr GT AddExpr
		{
			$$ = emitGreaterThanExpression(instList,lastSymtab(stack),$1,$3);
		}
                ;

AddExpr		:  MulExpr            
		{
			$$ = $1; 
		}
                |  AddExpr PLUS MulExpr
		{
			$$ = emitAddExpression(instList,lastSymtab(stack),$1,$3);
		}
                |  AddExpr MINUS MulExpr
		{
			$$ = emitSubtractExpression(instList,lastSymtab(stack),$1,$3);
		}
                ;

MulExpr		:  Factor
		{
			$$ = $1; 
		}
                |  MulExpr TIMES Factor
		{
			$$ = emitMultiplyExpression(instList,lastSymtab(stack),$1,$3);
		}
                |  MulExpr DIVIDE Factor
		{
			$$ = emitDivideExpression(instList,lastSymtab(stack),$1,$3);
		}		
                ;
				
Factor          : Variable
		{ 
			$$ = emitLoadVariable(instList,lastSymtab(stack),$1);
		}
                | Constant
		{ 
			$$ = $1;
		}
                | IDENTIFIER LPAREN RPAREN
		{
			
			// begin scope on stack 
			// need to find correct symtable search $1 in index 0 

			char * dec = (char*)malloc(200);
			char * ba = (char*)malloc(200);
			char * ca = (char*)malloc(200);

			// push --------------------------------
			char * big = (char*)malloc(200);

			for( i = 0; i < NUM_INTEGER_REGISTERS-1; i++){
				if(isAllocatedIntegerRegister(i)){
					//printf("%d", i);
					sprintf( big + strlen(big), "        pushq %s\n", get64(i));
				}
			}
			temp = dlinkNodeAlloc(big);
			dlinkAppend(instList , temp );

			// ----------------------------------------

			

			sprintf(dec, "        call %s", $1 );
			
			//sprintf(ca, "        call %s", $1 );
			temp = dlinkNodeAlloc(dec);
			dlinkAppend(instList , temp );
			

			// pop ------------------------------------
			char * bigPop = (char*)malloc(200);

			for( i = 0; i < NUM_INTEGER_REGISTERS-1; i++){
				if(isAllocatedIntegerRegister(i)){
					//printf("%d", i);
					sprintf( bigPop + strlen(bigPop), "        popq %s\n", get64(i));
				}
			}
			temp = dlinkNodeAlloc(bigPop);
			dlinkAppend(instList , temp );

			// ------------------------------------

			int treg = allocateIntegerRegister();
			char *symReg = getIntegerRegisterName(treg);
			int tregIndex = SymIndex(lastSymtab(stack),symReg);
			SymPutFieldByIndex(lastSymtab(stack),tregIndex,SYMTAB_REGISTER_INDEX_FIELD,(Generic)treg);

			sprintf(ba, "        movl %%eax, %s", symReg);
			temp = dlinkNodeAlloc(ba);
			dlinkAppend(instList , temp );

			$$ = tregIndex;
		}
         	| LPAREN Expr RPAREN
		{
			$$ = $2;
		}
                ;  

Variable        : IDENTIFIER
		{
			
			//int symIndex1 = SymQueryIndex(lastSymtab(stack),$1); // original
			int symIndex = SymQueryIndex(findSymtab(stack, $1),$1);
			int key = isLocal(stack, $1);
			$$ = emitComputeVariableAddress(instList, lastSymtab(stack), findSymtab(stack, $1), symIndex, key); // was find sytab
			 // if(findSymtab(stack, $1) == lastSymtab(stack)){

			 // }
			
		}
                | IDENTIFIER LBRACKET Expr RBRACKET    
		{
			SymTable symtab = findSymtab(stack, $1);
			int key = isLocal(stack, $1);
			int symIndex = SymQueryIndex( symtab ,$1);

			// char * dec = (char*)malloc(200);
			// sprintf(dec, "        >>>>>>>>>" );
			// temp = dlinkNodeAlloc(dec);
			// dlinkAppend(instList , temp );
			// changes here
			$$ = emitComputeArrayAddress(instList,symtab,symIndex,lastSymtab(stack),$3, key);	

		}
                ;			       

StringConstant 	: STRING
		{ 
			int symIndex = SymIndex(lastSymtab(stack),$1);
			$$ = emitLoadStringConstantAddress(instList,dataList,lastSymtab(stack),symIndex); 
		}
                ;

Constant        :  INTCON
		{ 
			int symIndex = SymIndex(lastSymtab(stack),$1);
			$$ = emitLoadIntegerConstant(instList,lastSymtab(stack),symIndex); 

		}
                ;

%%


/********************C ROUTINES *********************************/

void Cminus_error(char *s)
{
  fprintf(stderr,"%s: line %d: %s\n",fileName,Cminus_lineno,s);
}

int Cminus_wrap() {
	return 1;
}

// static void initSymTable() {

// 	symtab = SymInit(SYMTABLE_SIZE); // either lastSymtab(stack) or symtab <<<---------------------------------------------------

// 	SymInitField(lastSymtab(stack),SYMTAB_OFFSET_FIELD,(Generic)-1,NULL);
// 	SymInitField(lastSymtab(stack),SYMTAB_REGISTER_INDEX_FIELD,(Generic)-1,NULL);

// 	int intIndex = SymIndex(lastSymtab(stack),SYMTAB_INTEGER_TYPE_STRING);
//         int errorIndex = SymIndex(lastSymtab(stack),SYMTAB_ERROR_TYPE_STRING);
//         int voidIndex = SymIndex(lastSymtab(stack),SYMTAB_VOID_TYPE_STRING);

//         SymPutFieldByIndex(lastSymtab(stack),intIndex,SYMTAB_SIZE_FIELD,(Generic)INTEGER_SIZE);
//         SymPutFieldByIndex(lastSymtab(stack),errorIndex,SYMTAB_SIZE_FIELD,(Generic)0);
//         SymPutFieldByIndex(lastSymtab(stack),voidIndex,SYMTAB_SIZE_FIELD,(Generic)0);

//         SymPutFieldByIndex(lastSymtab(stack),intIndex,SYMTAB_BASIC_TYPE_FIELD,(Generic)INTEGER_TYPE);
//         SymPutFieldByIndex(lastSymtab(stack),errorIndex,SYMTAB_BASIC_TYPE_FIELD,(Generic)ERROR_TYPE);
//         SymPutFieldByIndex(lastSymtab(stack),voidIndex,SYMTAB_BASIC_TYPE_FIELD,(Generic)VOID_TYPE);
// }

static void deleteSymTable() {
    SymKillField(lastSymtab(stack),SYMTAB_REGISTER_INDEX_FIELD);
    SymKillField(lastSymtab(stack),SYMTAB_OFFSET_FIELD);
    SymKill(lastSymtab(stack));

}

static void initialize(char* inputFileName) {

	stdin = freopen(inputFileName,"r", stdin);
        if (stdin == NULL) {
          fprintf(stderr,"Error: Could not open file %s\n",inputFileName);
          exit(-1);
        }

	char* dotChar = rindex(inputFileName,'.');
	int endIndex = strlen(inputFileName) - strlen(dotChar);
	char *outputFileName = nssave(2,substr(inputFileName,0,endIndex),".s");
	stdout = freopen(outputFileName,"w", stdout);
        if (stdout == NULL) {
          fprintf(stderr,"Error: Could not open file %s\n",outputFileName);
          exit(-1);
       } 

	//initSymTable();
	stack = symtabStackInit();
	beginScope(stack);
	d++;
	initRegisters();
	
	instList = dlinkListAlloc(NULL);
	dataList = dlinkListAlloc(NULL);

}

// mostly from symstack 
int isLocal(SymtabStack stack, char* key ){

	int csize = stackSize(stack);

	DNode node = dlinkHead(stack);
	while (node != NULL) {
	  if (SymQueryIndex((SymTable)dlinkNodeAtom(node),key) != SYM_INVALID_INDEX)
	    break;

	  csize--;
	  node = dlinkNext(node);
	}

	if (csize == 1)
		return 1;
	else
		return 0;
}


static void finalize() {

    fclose(stdin);
    /*fclose(stdout);*/
    
    deleteSymTable();
 	endScope(stack); // ends glabal symtab 
    cleanupRegisters();
    
    dlinkFreeNodesAndAtoms(instList);
    dlinkFreeNodesAndAtoms(dataList);

}



int main(int argc, char** argv)

{	
	fileName = argv[1];
	initialize(fileName);
	
        Cminus_parse();
  	
  	finalize();
  
  	return 0;
}
/******************END OF C ROUTINES**********************/
