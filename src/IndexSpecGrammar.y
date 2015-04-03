%token IDENTIFIER CONSTANT STRING_LITERAL SIZEOF
%token PTR_OP INC_OP DEC_OP LEFT_OP RIGHT_OP LE_OP GE_OP EQ_OP NE_OP
%token AND_OP OR_OP MUL_ASSIGN DIV_ASSIGN MOD_ASSIGN ADD_ASSIGN
%token SUB_ASSIGN LEFT_ASSIGN RIGHT_ASSIGN AND_ASSIGN
%token XOR_ASSIGN OR_ASSIGN TYPE_NAME IN 
%token TYPEDEF EXTERN STATIC AUTO REGISTER 
%token CHAR SHORT INT LONG SIGNED UNSIGNED FLOAT DOUBLE CONST VOLATILE VOID
%token STRUCT UNION ENUM ELIPSIS RANGE 
%token CASE DEFAULT IF ELSE SWITCH WHILE DO FOR GOTO CONTINUE BREAK RETURN 

%token PROP INLINE 
%token INDEX SPECIFICATION FUNCTIONS GENERIC NAME NAMES SCHEMA ON CLASS DISTRIBUTED MAXIMUM SIZE

%{
extern char Result[500];
%}


%start IndexSpecification
%%

IndexSpecification
	: IndexSpecHeader IndexSpecGenericNames IndexSpecGenericFunctions
      { printf("IndexSpecification 3 "); }
	;

IndexSpecHeader
	: INDEX SPECIFICATION FOR Identifier
	;

IndexSpecGenericNames
	: GENERIC NAMES SchemaName IndexName OnClass DistributedOn MaximumSize
      { printf("GenericNames 5 "); }
	;

SchemaName
	: SCHEMA NAME ':' Identifier     
	;

IndexName
   : INDEX NAME ':' Identifier
	;

OnClass
	: ON CLASS ':' Identifier
   ;

DistributedOn
   :
      { printf("nil "); }
	| DISTRIBUTED ON ':' Identifier
	;

MaximumSize
   :
      { printf("nil "); }
	| MAXIMUM SIZE ':' Number
	;

Number
	: CONSTANT
      { printf("\"%s\" Const 1 ", yytext); }
	;

IndexSpecGenericFunctions
	: GENERIC FUNCTIONS File
	;

PrimaryExpr
   : Identifier
   | CONSTANT
      { printf("\"%s\" Const 1 ", yytext); }
   | STRING_LITERAL
      { printf("%s StrLit 1 ", yytext); }
   | '(' Expr ')'
      { printf("PrimExp 1 "); }
   ;

PostfixExpr
   : PrimaryExpr
   | PostfixExpr '[' Expr ']'
      { printf("ArrayExp 2 "); }
   | PostfixExpr '(' ')'
      { printf("FuncCall 1 "); }
   | PostfixExpr '(' ArgumentExprList ')'
      { printf("FuncCallP 2 "); }
   | PostfixExpr '.' Identifier
      { printf("Access 2 "); }
   | PostfixExpr PTR_OP Identifier
      { printf("FieldAcc 2 "); }
   | PostfixExpr INC_OP
      { printf("PostInc 1 "); }
   | PostfixExpr DEC_OP
      { printf("PostDec 1 "); }
   | PostfixExpr '@' Identifier
      { printf("At 2 "); }
   ;

ArgumentExprList
   : AssignmentExpr
   | ArgumentExprList ',' AssignmentExpr
      { printf("ArgExpList 2 "); }
   ;

UnaryExpr
   : PostfixExpr
   | INC_OP UnaryExpr
      { printf("PreInc 1 "); }
   | DEC_OP UnaryExpr
      { printf("PreDec 1 "); }
   | '&' CastExpr
      { printf("AddrOp 1 "); }
   | '*' CastExpr
      { printf("BangOp 1 "); }
   | '+' CastExpr
      { printf("UnAddOp 1 "); }
   | '-' CastExpr
      { printf("UnSubOp 1 "); }
   | '~' CastExpr
      { printf("OnesComp 1 "); }
   | '!' CastExpr
      { printf("NotOp 1 "); }
   | SIZEOF UnaryExpr
      { printf("SizeExpOp 1 "); }
   | SIZEOF '(' TypeName ')'
      { printf("SizeTypeOp 1 "); }
   ;

CastExpr
   : UnaryExpr
   | '(' TypeName ')' CastExpr
      { printf("CastExp 2 "); }
   ;

MultiplicativeExpr
   : CastExpr
   | MultiplicativeExpr '*' CastExpr
      { printf("MultOp 2 "); }
   | MultiplicativeExpr '/' CastExpr
      { printf("DivOp 2 "); }
   | MultiplicativeExpr '%' CastExpr
      { printf("ModOp 2 "); }
   ;

AdditiveExpr
   : MultiplicativeExpr
   | AdditiveExpr '+' MultiplicativeExpr
      { printf("BinAddOp 2 "); }
   | AdditiveExpr '-' MultiplicativeExpr
      { printf("BinSubOp 2 "); }
   ;

ShiftExpr
   : AdditiveExpr
   | ShiftExpr LEFT_OP AdditiveExpr
      { printf("LeftShiftOp 2 "); }
   | ShiftExpr RIGHT_OP AdditiveExpr
      { printf("RightShiftOp 2 "); }
   ;

RelationalExpr
   : ShiftExpr
   | RelationalExpr '<' ShiftExpr
      { printf("LTPred 2 "); }
   | RelationalExpr '>' ShiftExpr
      { printf("GTPred 2 "); }
   | RelationalExpr LE_OP ShiftExpr
      { printf("LEPred 2 "); }
   | RelationalExpr GE_OP ShiftExpr
      { printf("GEPred 2 "); }
   ;

EqualityExpr
   : RelationalExpr
   | EqualityExpr EQ_OP RelationalExpr
      { printf("EqPred 2 "); }
   | EqualityExpr NE_OP RelationalExpr
      { printf("NEPred 2 "); }
   ;

AndExpr
   : EqualityExpr
   | AndExpr '&' EqualityExpr
      { printf("BitAndOp 2 "); }
   ;

ExclusiveOrExpr
   : AndExpr
   | ExclusiveOrExpr '^' AndExpr
      { printf("BitXOrOp 2 "); }
   ;

InclusiveOrExpr
   : ExclusiveOrExpr
   | InclusiveOrExpr '|' ExclusiveOrExpr
      { printf("BitOrOp 2 "); }
   ;

LogicalAndExpr
   : InclusiveOrExpr
   | LogicalAndExpr AND_OP InclusiveOrExpr
      { printf("AndPred 2 "); }
   ;

LogicalOrExpr
   : LogicalAndExpr
   | LogicalOrExpr OR_OP LogicalAndExpr
      { printf("OrPred 2 "); }
   ;

ConditionalExpr
   : LogicalOrExpr
   | LogicalOrExpr '?' LogicalOrExpr ':' ConditionalExpr
      { printf("CondExp 3 "); }
   ;

AssignmentExpr
   : ConditionalExpr
   | UnaryExpr '=' AssignmentExpr
      { printf("AssignOp 2 "); }
   | UnaryExpr MUL_ASSIGN AssignmentExpr
      { printf("AssignMultOp 2 "); }
   | UnaryExpr DIV_ASSIGN AssignmentExpr
      { printf("AssignDivOp 2 "); }
   | UnaryExpr MOD_ASSIGN AssignmentExpr
      { printf("AssignModOp 2 "); }
   | UnaryExpr ADD_ASSIGN AssignmentExpr
      { printf("AssignAddOp 2 "); }
   | UnaryExpr SUB_ASSIGN AssignmentExpr
      { printf("AssignSubOp 2 "); }
   | UnaryExpr LEFT_ASSIGN AssignmentExpr
      { printf("AssignLeftShiftOp 2 "); }
   | UnaryExpr RIGHT_ASSIGN AssignmentExpr
      { printf("AssignRightShiftOp 2 "); }
   | UnaryExpr AND_ASSIGN AssignmentExpr
      { printf("AssignBitAndOp 2 "); }
   | UnaryExpr XOR_ASSIGN AssignmentExpr
      { printf("AssignBitXOrOp 2 "); }
   | UnaryExpr OR_ASSIGN AssignmentExpr
      { printf("AssignBitOrOp 2 "); }
   ;

Expr
   : AssignmentExpr
   | Expr ',' AssignmentExpr
      { printf("ExprList 2 "); }
   ;

ConstantExpr
   : ConditionalExpr
   ;

Declaration
   : DeclarationSpecifiers ';'
      { printf("DeclSpec 1 "); }
   | DeclarationSpecifiers InitDeclaratorList ';'
      { printf("DeclSpecWVars 2 "); }
   ;

DeclarationSpecifiers
   : StorageClassSpecifier
   | StorageClassSpecifier DeclarationSpecifiers
      { printf("StorDeclSpec 2 "); }
   | TypeSpecifier
   | TypeSpecifier DeclarationSpecifiers
      { printf("TypeDeclSpec 2 "); }
   ;

InitDeclaratorList
   : InitDeclarator
   | InitDeclaratorList ',' InitDeclarator
      { printf("InitDeclList 2 "); }
   ;

InitDeclarator
   : Declarator
   | Declarator '=' Initializer
      { printf("InitDecl 2 "); }
   ;

StorageClassSpecifier
   : TYPEDEF
      { printf("TypeDef 0 "); }
   | EXTERN
      { printf("Extern 0 "); }
   | STATIC
      { printf("Static 0 "); }
   | AUTO
      { printf("Auto 0 "); }
   | REGISTER
      { printf("Register 0 "); }
   ;

TypeSpecifier
   : CHAR
      { printf("CharType 0 "); }
   | SHORT
      { printf("ShortType 0 "); }
   | INT
      { printf("IntType 0 "); }
   | LONG
      { printf("LongType 0 "); }
   | SIGNED
      { printf("SignedType 0 "); }
   | UNSIGNED
      { printf("UnsignedType 0 "); }
   | FLOAT
      { printf("FloatType 0 "); }
   | DOUBLE
      { printf("DoubleType 0 "); }
   | CONST
      { printf("ConstType 0 "); }
   | VOLATILE
      { printf("VolatileType 0 "); }
   | VOID
      { printf("VoidType 0 "); }
   | StructOrUnionSpecifier
   | EnumSpecifier
   | TYPE_NAME
      { printf("TypeDef 0 "); }
   | PROP Identifier
      { printf("Prop 1 "); }
   ;

StructOrUnionSpecifier
   : STRUCT Identifier '{' StructDeclarationList '}'
      { printf("StructWIdDecl 2 "); }
   | STRUCT '{' StructDeclarationList '}'
      { printf("StructWDecl 1 "); }
   | STRUCT Identifier
      { printf("StructWId 1 "); }
   | UNION Identifier '{' StructDeclarationList '}'
      { printf("UnionWIdDecl 2 "); }
   | UNION '{' StructDeclarationList '}'
      { printf("UnionWDecl 1 "); }
   | UNION Identifier
      { printf("UnionWId 1 "); }
   ;

StructDeclarationList
   : StructDeclaration
   | StructDeclarationList StructDeclaration
      { printf("StructDeclList 2 "); }
   ;

StructDeclaration
   : TypeSpecifierList StructDeclaratorList ';'
      { printf("StructDecl 2 "); }
   ;

StructDeclaratorList
   : StructDeclarator
   | StructDeclaratorList ',' StructDeclarator
      { printf("StructVarList 2 "); }
   ;

StructDeclarator
   : Declarator
   | ':' ConstantExpr
      { printf("StructFiller 1 "); }
   | Declarator ':' ConstantExpr
      { printf("StructPacked 2 "); }
   ;

EnumSpecifier
   : ENUM '{' EnumeratorList '}'
      { printf("EnumWEnumList 1 "); }
   | ENUM Identifier '{' EnumeratorList '}'
      { printf("EnumWIdEnumList 2 "); }
   | ENUM Identifier
      { printf("EnumWId 1 "); }
   ;

EnumeratorList
   : Enumerator
   | EnumeratorList ',' Enumerator
      { printf("EnumList 2 "); }
   ;

Enumerator
   : Identifier
   | Identifier '=' ConstantExpr
      { printf("EnumWInit 2 "); }
   ;

Declarator
   : Declarator2
   | Pointer Declarator2
      { printf("PtrVar 2 "); }
   ;

Declarator2
   : Identifier
   | '(' Declarator ')'
      { printf("VarWParens 1 "); }
   | Declarator2 '[' ']'
      { printf("ArrayVar 1 "); }
   | Declarator2 '[' ConstantExpr ']'
      { printf("ArrayVarWSize 2 "); }
   | Declarator2 '(' ')'
      { printf("FuncVar 1 "); }
   | Declarator2 '(' ParameterTypeList ')'
      { printf("FuncVarWPTList 2 "); }
   | Declarator2 '(' ParameterIdentifierList ')'
      { printf("FuncVarWPIdList 2 "); }
   ;

Pointer
   : '*'
      { printf("Ptr 0 "); }
   | '*' TypeSpecifierList
      { printf("PtrTSList 1 "); }
   | '*' Pointer
      { printf("PtrPtr 1 "); }
   | '*' TypeSpecifierList Pointer
      { printf("PtrTSListPtr 2 "); }
   ;

TypeSpecifierList
   : TypeSpecifier
   | TypeSpecifierList TypeSpecifier
      { printf("TypeSpecList 2 "); }
   ;

ParameterIdentifierList
   : IdentifierList
   | IdentifierList ',' ELIPSIS
      { printf("IdListWElipsis 1 "); }
   ;

IdentifierList
   : PostfixExpr
   | IdentifierList ',' PostfixExpr
      { printf("IdList 2 "); }
   ;

ParameterTypeList
   : ParameterList
   | ParameterList ',' ELIPSIS
      { printf("ParamListWElipsis 1 "); }
   ;

ParameterList
   : ParameterDeclaration
   | ParameterList ',' ParameterDeclaration
      { printf("ParamList 2 "); }
   ;

ParameterDeclaration
   : TypeSpecifierList Declarator
      { printf("ParamDecl 2 "); }
   | TypeName
   ;

TypeName
   : TypeSpecifierList
   | TypeSpecifierList AbstractDeclarator
      { printf("TypeSpecListWAbsDecl 2 "); }
   ;

AbstractDeclarator
   : Pointer
   | AbstractDeclarator2
   | Pointer AbstractDeclarator2
      { printf("AbstDeclWPtrAbsDecl 2 "); }
   ;

AbstractDeclarator2
   : '(' AbstractDeclarator ')'
      { printf("AbstDeclParens 1 "); }
   | '[' ']'
      { printf("SimpArrayAbstDecl 0 "); }
   | '[' ConstantExpr ']'
      { printf("SimpArrayWSizeAbst 1 "); }
   | AbstractDeclarator2 '[' ']'
      { printf("CompArrayAbstDecl 1 "); }
   | AbstractDeclarator2 '[' ConstantExpr ']'
      { printf("CompArrayWSizeAbstDecl 2 "); }
   | '(' ')'
      { printf("SimpFuncAbstDecl 0 "); }
   | '(' ParameterTypeList ')'
      { printf("SimpFuncAbstDeclWPList 1 "); }
   | AbstractDeclarator2 '(' ')'
      { printf("CompFuncAbstDecl 1 "); }
   | AbstractDeclarator2 '(' ParameterTypeList ')'
      { printf("CompFuncAbstDeclWPList 2 "); }
   ;

Initializer
   : AssignmentExpr
   | '{' InitializerList '}'
      { printf("InitListHdr 1 "); }
   | '{' InitializerList ',' '}'
      { printf("InitListHdrWCom 1 "); }
   ;

InitializerList
   : Initializer
   | InitializerList ',' Initializer
      { printf("InitList 2 "); }
   ;

Statement
   : LabeledStatement
   | CompoundStatement
   | ExpressionStatement
   | SelectionStatement
   | IterationStatement
   | JumpStatement
   ;

LabeledStatement
   : Identifier ':' Statement
      { printf("LabeledStmt 2 "); }
   | CASE ConstantExpr ':' Statement
      { printf("CaseStmt 2 "); }
   | DEFAULT ':' Statement
      { printf("DefaultStmt 1 "); }
   ;

CompoundStatement
   : '{' '}'
      { printf("CompndStmt 0 "); }
   | '{' StatementList '}'
      { printf("CompndStmtWSList 1 "); }
   | '{' DeclarationList '}'
      { printf("CompndStmtWDList 1 "); }
   | '{' DeclarationList StatementList '}'
      { printf("CompndStmtWDListSList 2 "); }
   ;

DeclarationList
   : Declaration
   | DeclarationList Declaration
      { printf("DeclList 2 "); }
   ;

StatementList
   : Statement
   | StatementList Statement
      { printf("StmtList 2 "); }
   ;

ExpressionStatement
   : ';'
      { printf("NullStmt 0 "); }
   | Expr ';'
      { printf("ExprStmt 1 "); }
   ;

SelectionStatement
   : IF '(' Expr ')' Statement
      { printf("IfStmt 2 "); }
   | IF '(' Expr ')' Statement ELSE Statement
      { printf("IfElse 3 "); }
   | SWITCH '(' Expr ')' Statement
      { printf("Switch 2 "); }
   ;

IterationStatement
   : WHILE '(' Expr ')' Statement
      { printf("While 2 "); }
   | DO Statement WHILE '(' Expr ')' ';'
      { printf("DoStmt 2 "); }
   | FOR '(' ';' ';' ')' Statement
      { printf("For 1 "); }
   | FOR '(' ';' ';' Expr ')' Statement
      { printf("ForWF 2 "); }
   | FOR '(' ';' Expr ';' ')' Statement
      { printf("ForWS 2 "); }
   | FOR '(' ';' Expr ';' Expr ')' Statement
      { printf("ForWSF 3 "); }
   | FOR '(' Expr ';' ';' ')' Statement
      { printf("ForWI 2 "); }
   | FOR '(' Expr ';' ';' Expr ')' Statement
      { printf("ForWIF 3 "); }
   | FOR '(' Expr ';' Expr ';' ')' Statement
      { printf("ForWIS 3 "); }
   | FOR '(' Expr ';' Expr ';' Expr ')' Statement
      { printf("ForWISF 4 "); }
   ;

JumpStatement
   : GOTO Identifier ';'
      { printf("Goto 1 "); }
   | CONTINUE ';'
      { printf("ContinueStmt 0 "); }
   | BREAK ';'
      { printf("BreakStmt 0 "); }
   | RETURN ';'
      { printf("ReturnStmt 0 "); }
   | RETURN Expr ';'
      { printf("ReturnWExp 1 "); }
   ;


File
   : ExternalDefinition
   | File ExternalDefinition
      { printf("File 2 "); }
   ;

ExternalDefinition
   : FunctionDefinition
	| InlineFunctionDefinition
   ;

FunctionDefinition
   : Declarator FunctionBody
      { printf("FuncDefn 2 "); }
   | DeclarationSpecifiers Declarator FunctionBody
      { printf("FuncDefnWDeclSpec 3 "); }
   ;

InlineFunctionDefinition
   : INLINE Declarator FunctionBody
      { printf("InlineFuncDefn 2 "); }
   | INLINE DeclarationSpecifiers Declarator FunctionBody
      { printf("InlineFuncDefnWDeclSpec 3 "); }
   | STATIC INLINE DeclarationSpecifiers Declarator FunctionBody
      { printf("StaticInlineFuncDefnWDeclSpec 3 "); }
   ;

FunctionBody
   : CompoundStatement
   | DeclarationList CompoundStatement
      { printf("FuncBodyWDeclList 2 "); }
   ;

Identifier
	: IDENTIFIER
      { printf("%s", Result); }

%%
