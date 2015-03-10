%token IMPLIES OR AND NOT LE GE NE HAS MAX MIN AS ASC DESC MOD ASSIGN

%token SIZE SELECTIVITY OVERLAP
%token FREQUENCY UNIT TIME SPACE

%token STORE STORING DYNAMIC STATIC OF TYPE ORDERED BY
%token INDEX LIST ARRAY BINARY TREE DISTRIBUTED POINTER

%token SCHEMA IDENTIFIER CLASS ISA PROPERTIES CONSTRAINTS PROPERTY
%token ON DETERMINED COVER QUERY GIVEN FROM SELECT WHERE ORDER
%token PRECOMPUTED ONE EXIST FOR ALL TRANSACTION INTCLASS STRCLASS
%token INTEGER REAL DOUBLEREAL STRING MAXLEN RANGE TO
%token INSERT END CHANGE DELETE DECLARE RETURN

%start LDMProgram
%%

LDMProgram
	: SCHEMA Identifier LDMDDLSpecList LDMSpecList
		{ printf("Schema 3 "); }
	;

LDMDDLSpecList
	: LDMDDLSpec
	| LDMDDLSpec LDMDDLSpecList
		{ printf("SpecList 2 "); }
	;

LDMSpecList
	: LDMSpec
	| LDMSpec LDMSpecList
		{ printf("SpecList 2 "); }
	;

LDMSpec
	: LDMDMLSpec
	| LDMSDLSpec
	| LDMStatSpec
	;

Identifier
	: IDENTIFIER
		{ printf("|%s| ", yytext); }
	;

LDMDDLSpec
	: CLASS Identifier
		{ printf("gClass 1 "); }
	| CLASS Identifier LDMIsa
		{ printf("SubClass 2 "); }
	| CLASS Identifier LDMProperties
		{ printf("ClassWProps 2 "); }
	| CLASS Identifier LDMConstraints
		{ printf("ClassWCon 2 "); }
	| CLASS Identifier LDMIsa LDMProperties
		{ printf("SubClassWProps 3 "); }
	| CLASS Identifier LDMIsa LDMConstraints
		{ printf("SubClassWCon 3 "); }
	| CLASS Identifier LDMProperties LDMConstraints
		{ printf("ClassWPropsCon 3 "); }
	| CLASS Identifier LDMIsa LDMProperties LDMConstraints
		{ printf("SubClassWPropsCon 4 "); }
	| PROPERTY Identifier ON Identifier
		{ printf("Prop 2 "); }
	| PROPERTY Identifier ON STRCLASS MAXLEN LDMInteger
		{ printf("StringProp 2 "); }
	| PROPERTY Identifier ON INTCLASS RANGE LDMInteger TO LDMInteger
		{ printf("IntProp 3 "); }
	;

LDMIsa
	: ISA IdentifierList
	;

IdentifierList
	: Identifier
	| Identifier ',' IdentifierList
		{ printf("IdList 2 "); }
	;

LDMProperties
	: PROPERTIES IdentifierList
	;

LDMConstraints
	: CONSTRAINTS LDMClassConstraintList
	;

LDMClassConstraintList
	: LDMClassConstraint
	| LDMClassConstraint LDMClassConstraintList
		{ printf("ClassConList 2 "); }
	;

LDMClassConstraint
	: LDMPathFunction DETERMINED BY LDMPathFunctionList
		{ printf("Pfd 2 "); }
	| COVER BY IdentifierList
		{ printf("Cover 1 "); }
	;

LDMPathFunctionList
	: LDMPathFunction
	| LDMPathFunction ',' LDMPathFunctionList
		{ printf("PathFuncList 2 "); }
	;

LDMDMLSpec
	: LDMQueryDefn
	| LDMTransactionDefn
	;

LDMQueryDefn
	: QUERY Identifier LDMQueryBody
		{ printf("Query 2 "); }
	| QUERY Identifier GIVEN LDMVarDecl LDMQueryBody
		{ printf("ParamQuery 3 "); }
	;

LDMVarDecl
	: IdentifierList FROM IdentifierList
		{ printf("VarDecl 2 "); }
	;

LDMQueryBody
	: SELECT LDMVarDecl
		{ printf("AllBody 1 "); }
	| SELECT LDMVarDecl WHERE LDMPred
		{ printf("AllBodyPred 2 "); }
	| SELECT LDMVarDecl ORDER BY LDMOrderList
		{ printf("AllBodyOrder 2 "); }
	| SELECT LDMVarDecl WHERE LDMPred ORDER BY LDMOrderList
		{ printf("AllBodyPredOrder 3 "); }
	| SELECT LDMVarDecl PRECOMPUTED
		{ printf("AllBodyProj 1 "); }
	| SELECT LDMVarDecl WHERE LDMPred PRECOMPUTED
		{ printf("AllBodyPredProj 2 "); }
	| SELECT LDMVarDecl ORDER BY LDMOrderList PRECOMPUTED
		{ printf("AllBodyOrderProj 2 "); }
	| SELECT LDMVarDecl WHERE LDMPred ORDER BY LDMOrderList PRECOMPUTED
		{ printf("AllBodyPredOrderProj 3 "); }
	| SELECT ONE LDMVarDecl
		{ printf("OneBodyVar 1 "); }
	| SELECT ONE WHERE LDMPred
		{ printf("OneBodyPred 1 "); }
	| SELECT ONE LDMVarDecl WHERE LDMPred
		{ printf("OneBodyVarPred 2 "); }
	;

LDMPred
	: LDMImplicationPred
	| EXIST LDMVarDecl
		{ printf("Exist 1 "); }
	| EXIST LDMVarDecl WHERE LDMPred
		{ printf("ExistPred 2 "); }
	| FOR ALL LDMVarDecl LDMPred
		{ printf("Forall 2 "); }
	;

LDMImplicationPred
	: LDMOrPred
	| LDMImplicationPred IMPLIES LDMOrPred
		{ printf("Implies 2 "); }
	;

LDMOrPred
	: LDMAndPred
	| LDMAndPred OR LDMOrPred
		{ printf("gOr 2 "); }
	;

LDMAndPred
	: LDMNotPred
	| LDMNotPred AND LDMAndPred
		{ printf("gAnd 2 "); }
	;

LDMNotPred
	: LDMPrimaryPred
	| NOT LDMPrimaryPred
		{ printf("gNot 1 "); }
	;

LDMPrimaryPred
	: LDMTerm '=' LDMTerm
		{ printf("gEQ 2 "); }
	| LDMTerm '<' LDMTerm
		{ printf("LT 2 "); }
	| LDMTerm '>' LDMTerm
		{ printf("GT 2 "); }
	| LDMTerm  LE LDMTerm
		{ printf("LE 2 "); }
	| LDMTerm GE LDMTerm
		{ printf("GE 2 "); }
	| LDMTerm NE LDMTerm
		{ printf("NE 2 "); }
	| Identifier HAS MAX LDMPathFunction
		{ printf("HasMax 2 "); }
	| Identifier HAS MIN LDMPathFunction
		{ printf("HasMin 2 "); }
	| Identifier HAS MAX LDMPathFunction WHERE LDMPred
		{ printf("HasMaxPred 3 "); }
	| Identifier HAS MIN LDMPathFunction WHERE LDMPred
		{ printf("HasMinPred 3 "); }
	| Identifier '{' LDMAsOpList '}'
		{ printf("Pred 2 "); }
	| '(' LDMPred ')'
	;

LDMAsOpList
	: LDMTerm AS LDMPathFunction
		{ printf("AsOp 2 "); }
	| LDMTerm AS LDMPathFunction ',' LDMAsOpList
		{ printf("AsOpList 3 "); }
	;

LDMOrderList
	: LDMTerm ASC
		{ printf("OrderAsc 1 "); }
	| LDMTerm DESC
		{ printf("OrderDesc 1 "); }
	| LDMTerm ASC ',' LDMOrderList
		{ printf("OrderAscList 2 "); }
	| LDMTerm DESC ',' LDMOrderList
		{ printf("OrderDescList 2 "); }
	;

LDMTerm
	: LDMMultTerm
	| LDMTerm '+' LDMMultTerm
		{ printf("AddOp 2 "); }
	| LDMTerm '-' LDMMultTerm
		{ printf("SubOp 2 "); }
	;

LDMMultTerm
	: LDMUnaryTerm
	| LDMMultTerm MOD LDMUnaryTerm
		{ printf("ModOp 2 "); }
	| LDMMultTerm '*' LDMUnaryTerm
		{ printf("TimesOp 2 "); }
	| LDMMultTerm '/' LDMUnaryTerm
		{ printf("DivOp 2 "); }
	;

LDMUnaryTerm
	: LDMPrimaryTerm
	| '-' LDMPrimaryTerm
		{ printf("UnMinusOp 1 "); }
	;

LDMPrimaryTerm
	: LDMConstant
	| Identifier
	| Identifier '.' LDMPathFunction
		{ printf("gApply 2 "); }
	| '(' LDMTerm ')'
	;

LDMConstant
	: LDMInteger
	| REAL
		{ printf("\"%s\" Real Constant 2 ", yytext); }
	| DOUBLEREAL
		{ printf("\"%s\" DoubleReal Constant 2 ", yytext); }
	| STRING
		{ printf("%s String Constant 2 ", yytext); }
	;

LDMInteger
	: INTEGER
		{ printf("\"%s\" Integer Constant 2 ", yytext); }
	;

LDMPathFunction
	: LDMSimplePathFunction
	| Identifier '.' LDMPathFunction
		{ printf("CompPF 2 "); }
	;

LDMSimplePathFunction
	: Identifier
		{ printf("SimpPF 1 "); }

LDMTransactionDefn
	: TRANSACTION Identifier LDMTransBody
		{ printf("Trans 2 "); }
	| TRANSACTION Identifier GIVEN LDMVarDecl LDMTransBody
		{ printf("ParamTrans 3 "); }
	;

LDMTransBody
	: LDMStatementList
		{ printf("Body 1 "); }
	| DECLARE LDMVarDecl LDMStatementList
		{ printf("BodyWLocVars 2 "); }
	| LDMStatementList RETURN LDMTerm
		{ printf("ReturnBody 2 "); }
	| DECLARE LDMVarDecl LDMStatementList RETURN LDMTerm
		{ printf("ReturnBodyWLocVars 3 "); }
	;

LDMStatementList
	: LDMStatement
	| LDMStatement ';' LDMStatementList
		{ printf("StmtList 2 "); }
	;

LDMStatement
	: INSERT IdentifierList
		{ printf("Insert 1 "); }
	| INSERT IdentifierList '(' LDMInitList ')'
		{ printf("InsertWInits 2 "); }
	| DELETE IdentifierList
		{ printf("gDelete 1 "); }
	| LDMTerm ASSIGN LDMTerm
		{ printf("Assign 2 "); }
	;

LDMInitList
	: Identifier '.' LDMSimplePathFunction ASSIGN LDMTerm
		{ printf("Init 3 "); }
	| Identifier '.' LDMSimplePathFunction ASSIGN LDMTerm ';' LDMInitList
		{ printf("InitList 4 "); }
	;

LDMStatSpec
	: SIZE Identifier LDMConstant
		{ printf("DefSizeEst 2 "); }
	| SELECTIVITY Identifier LDMConstant
		{ printf("DefSelectEst 2 "); }
	| OVERLAP Identifier Identifier LDMConstant
		{ printf("DefOverlapEst 3 "); }
	| FREQUENCY Identifier LDMConstant
		{ printf("DefFreqEst 2 "); }
	| UNIT TIME LDMConstant
		{ printf("DefUnitTime 1 "); }
	| UNIT SPACE LDMConstant
		{ printf("DefUnitSpace 1 "); }
	;

LDMSDLSpec
	: LDMIndexDefn
	| LDMStoreDefn
	;

LDMIndexDefn
	: INDEX Identifier ON Identifier OF TYPE LDMIndexTypeSpec
		{ printf("Index 3 "); }
	;

LDMIndexTypeSpec
	: LIST
		{ printf("gList 0 "); }
	| ARRAY LDMInteger LDMOrderedSearchSpec
		{ printf("gArray 2 "); }
	| BINARY TREE LDMOrderedSearchSpec
		{ printf("BinaryTree 1 "); }
	| DISTRIBUTED LIST ON LDMPathFunction
		{ printf("DistList 1 "); }
	| DISTRIBUTED POINTER ON LDMPathFunction
		{ printf("DistPointer 1 "); }
	| DISTRIBUTED BINARY TREE ON LDMPathFunction LDMOrderedSearchSpec
		{ printf("DistBinaryTree 2 "); }
	;

LDMOrderedSearchSpec
	: ORDERED BY LDMOrderedSearchCondList
	;

LDMOrderedSearchCondList
	: LDMOrderedSearchCond
	| LDMOrderedSearchCond ',' LDMOrderedSearchCondList
		{ printf("SearchCondList 2 "); }
	;

LDMOrderedSearchCond
	: LDMPathFunction ASC
		{ printf("AscSearchCond 1 "); }
	| LDMPathFunction DESC
		{ printf("DescSearchCond 1 "); }
	| Identifier
		{ printf("SCSearchCond 1 "); }
	;

LDMStoreDefn
	: STORE Identifier OF TYPE LDMStoreTypeSpec LDMStoreContentSpec
		{ printf("Store 3 "); }
	;

LDMStoreContentSpec
	: STORING IdentifierList
	;

LDMStoreTypeSpec
	: DYNAMIC
		{ printf("Dynamic 0 "); }
	| STATIC LDMInteger
		{ printf("Static 1 "); }
	;
%%
/*
 * Copyright (C) 1989, G. E. Weddell.
 */

extern char* yytext;
