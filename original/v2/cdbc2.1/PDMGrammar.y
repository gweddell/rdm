%{
%}


/* Reserved-keyword tokens. */
%token   ACTIONS
%token   ADD
%token   ALLOC
%token   ALLOCATE
%token   ARRAY
%token   AS
%token   ASC
%token   ASSIGN
%token   BINARY
%token   BY
%token   CLASS
%token   COMPLIMENT
%token   COPY
%token   CREATE
%token   CUT
%token   DECLARE
%token   DESC
%token   DESTROY
%token   DIRECT
%token   DISTRIBUTED
%token   DYNAMIC
%token   EACH
%token   ELSE
%token   END
%token   ENDIF
%token   EXTENSION
%token   FIELDS
%token   FIRST
%token   FOR
%token   FREE
%token   FREQUENCY
%token   FROM
%token   GIVEN
%token   IF
%token   IN
%token   INIT
%token   INDEX
%token   INDIRECT
%token   INSERT
%token   IS
%token   ISA
%token   LABELID
%token   LIST
%token   MAXLEN
%token   MAXIMUM
%token   MSC
%token   MSCSUM
%token   NEST
%token   NOT
%token   OF
%token   OFFSET
%token   ON
%token   ONE
%token   ORDERED
%token   OVERLAP
%token   POINTER
%token   PROPERTIES
%token   PROPERTY
%token   QUERY
%token   RANGE
%token   REFERENCE
%token   REMOVE
%token   RETURN
%token   SCHEMA
%token   SELECT
%token   SELECTIVITY
%token   SIZE
%token   SPACE
%token   STATIC
%token   STORE
%token   STORING
%token   SUB
%token   THEN
%token   TIME
%token   TO
%token   TRANSACTION
%token   TREE
%token   TYPE
%token   UNIT
%token   UNOPTIMIZED
%token   VERIFY
%token   WHERE
%token   WITH


/* Punctuation tokens. */
%token   COMMA   
%token   DOT
%token   SEMICOLON   


/* Special tokens. */
%token   ID
%token   INT   
%token   REAL
%token   STRING
%token   EQ
%token   LT
%token   GT
%token   LE
%token   GE
%token   NE
%token   LEFTP
%token   RIGHTP
%token   PLUS
%token   MINUS
%token   TIMES
%token   DIVIDE
%token   MOD
%token   COLONEQ


%%

/*<<<<<<<<<<<<<<<<<<<<   PDMSource   >>>>>>>>>>>>>>>>>>>>>*/
PDMSource
      : SCHEMA Identifier PDMBody
         {printf("PDMSource 2 "); }
      ;

PDMBody
      : PDMSpec                  
         { printf("PDMSpecList 1 "); }
      | PDMSpec PDMBody
         { printf("PDMSpecList 2 "); }
      ;

PDMSpec
      : PDMClassSpec
      | PDMPropertySpec
      | PDMIndexSpec
      | PDMStoreSpec
      | PDMStatSpec
      | PDMQuerySpec
      | PDMTransSpec
      ;

/*<<<<<<<<<<<<<<<<<<<<   PDMClass   >>>>>>>>>>>>>>>>>>>>>*/
PDMClassSpec 
      : PDMClassClass PDMClassProperties PDMClassMsc PDMClassReference PDMClassExtension PDMClassFields
         { printf("ClassSpec 6 "); }
      ; 

PDMClassClass 
      : CLASS Identifier
         { printf("Class 1 "); } 
      | CLASS Identifier ISA PDMNameList
         { printf("Class 2 "); } 
      ;

PDMClassProperties 
      :
         { printf("Properties 0 "); }
      | PROPERTIES PDMNameList
         { printf("Properties 1 "); }
      ;
      
PDMClassMsc
      : MSC BareInteger MSCSUM BareInteger
         { printf("Msc 2 "); }
      ;

PDMClassReference
      : REFERENCE PDMClassReferenceType
         { printf("Reference 1 "); } 
      | REFERENCE PDMClassReferenceType BY OFFSET IN Identifier
         { printf("Reference 2 "); } 
      ;
      
PDMClassExtension   
      : 
         { printf("Extension 0 "); } 
      | EXTENSION OF Identifier
         { printf("Extension 1 "); } 
      ;

PDMClassFields 
      :
         { printf("Fields 0 "); } 
      | FIELDS PDMNameSeq
         { printf("Fields 1 "); } 
      ;

PDMClassReferenceType   
      : DIRECT
         { printf("Direct 0 "); } 
      | INDIRECT
         { printf("Indirect 0 "); } 
      ;

/*<<<<<<<<<<<<<<<<<<<<   PDMProperty   >>>>>>>>>>>>>>>>>>>>>*/
PDMPropertySpec
      : PROPERTY Identifier ON Identifier 
         { printf("PropertySpec 2 "); }
      | PROPERTY Identifier ON Identifier PDMPropertyDescription
         { printf("PropertySpec 3 "); }
      ;

PDMPropertyDescription
      : RANGE FormattedInteger TO FormattedInteger
         { printf("Range 2 "); }
      | MAXLEN FormattedInteger
         { printf("Maxlen 1 "); }
      ;

/*<<<<<<<<<<<<<<<<<<<<   PDMIndex   >>>>>>>>>>>>>>>>>>>>>*/
PDMIndexSpec
      : INDEX Identifier ON Identifier OF TYPE Identifier PDMIndexDistSpec PDMIndexSizeSpec PDMIndexSearchSpec    
         { printf("IndexSpec 6 "); }
      ;

PDMIndexDistSpec
      :
         { printf("nil "); }
      | DISTRIBUTED ON PDMpath
      ;

PDMIndexSizeSpec
      :
         { printf("nil "); }
      | WITH MAXIMUM SIZE FormattedInteger
      ;

PDMIndexSearchSpec
      :
         { printf("nil "); }
      | ORDERED BY PDMIndexSearchCondList
      ;

PDMIndexSearchCondList
      : PDMIndexSearchCond
      | PDMIndexSearchCondList COMMA PDMIndexSearchCond
         { printf("IdList 2 "); }
      ;

PDMIndexSearchCond 
      : PDMpath PDMIndexSearchDescript
      ;

PDMIndexSearchDescript
      :
      | ASC
         { printf("ASC 1 "); }
      | DESC
         { printf("DESC 1 "); }         
      ;

/*<<<<<<<<<<<<<<<<<<<<   PDMStore   >>>>>>>>>>>>>>>>>>>>>*/
PDMStoreSpec
      : STORE Identifier OF TYPE PDMStoreTypeSpec STORING PDMNameList
         { printf("StoreSpec 3 "); }
      ;

PDMStoreTypeSpec
      : DYNAMIC
         { printf("Dynamic 0 "); }
      | STATIC FormattedInteger
         { printf("Static 1 "); }
      ;

/*<<<<<<<<<<<<<<<<<<<<   PDMStat   >>>>>>>>>>>>>>>>>>>>>*/
PDMStatSpec
      : SIZE Identifier PDMNumber
      | SELECTIVITY Identifier PDMNumber
      | OVERLAP Identifier Identifier PDMNumber
      | FREQUENCY Identifier PDMNumber
      | UNIT TIME PDMNumber
      | UNIT SPACE PDMNumber
      ;

/*<<<<<<<<<<<<<<<<<<<<   PDMQuery   >>>>>>>>>>>>>>>>>>>>>*/
PDMQuerySpec
      : PDMQueryQuery PDMQueryGiven PDMQuerySelect PDMQueryDeclare PDMQueryLast
         { printf("QuerySpec 5 "); }
      ;

PDMQueryQuery
      : QUERY Identifier
         { printf("Query 1 "); }
      ;

PDMQueryGiven
      : 
         { printf("Given 0 "); }
      | GIVEN PDMNameList FROM PDMNameList
         { printf("Given 2 "); }
      ;

PDMQuerySelect
      : SELECT ONE
         { printf("nil nil One 0 Select 3 "); }
      | SELECT ONE PDMNameList FROM PDMNameList
         { printf("One 0 Select 3 "); }
      | SELECT PDMNameList FROM PDMNameList
         { printf("All 0 Select 3 "); }
      ;

PDMQueryDeclare
      :
         { printf("Declare 0 "); }
      | DECLARE PDMNameList FROM PDMNameList 
         { printf("Declare 2 "); }
      ;

PDMQueryLast
      : PDMQueryTupleExpr
      | UNOPTIMIZED
         { printf("Unoptimized 0 "); }
      ;

PDMQueryTupleExpr
      :   
         { printf("NullTuple 0 "); }
      | NEST PDMQuerySubTupleExpr END
      | COMPLIMENT PDMQueryTupleExpr
         { printf("Compliment 1 "); }
      | VERIFY PDMPred PDMQueryTupleExpr
         { printf("Select 2 "); }
      | CUT Identifier PDMQueryTupleExpr
         { printf("Cut 2 "); }
      | ASSIGN Id AS PDMTerm
         { printf("Assign 2 "); }
      | ASSIGN Id AS PDMTerm IN Id 
         { printf("Assign 3 "); }
      | ASSIGN Id AS FIRST OF Id 
         { printf("AssignIndexFirst 2 "); }
      | ASSIGN Id AS FIRST OF Id WHERE PDMPredList 
         { printf("AssignIndexFirstCond  3 "); }
      | ASSIGN Id AS EACH OF Id 
         { printf("AssignIndexEach 2 "); }
      | ASSIGN Id AS EACH OF Id WHERE PDMPredList 
         { printf("AssignIndexEachCond 3 "); }
      ;

PDMQuerySubTupleExpr
      : PDMQueryTupleExpr SEMICOLON
      | PDMQueryTupleExpr SEMICOLON PDMQuerySubTupleExpr
         { printf("Join 2 "); }
      ;

/*<<<<<<<<<<<<<<<<<<<<   PDMTrans   >>>>>>>>>>>>>>>>>>>>>*/
PDMTransSpec
      : TRANSACTION Identifier PDMTransGiven PDMTransDeclare PDMTransActions
         { printf("TransSpec 4 "); }
      ;

PDMTransGiven
      : 
         { printf("Given 0 "); }
      | GIVEN PDMIdNameList FROM PDMIdNameList
         { printf("Given 2 "); }
      ;

PDMTransDeclare
      :
         { printf("Declare 0 "); }
      | DECLARE PDMIdNameList FROM PDMIdNameList 
         { printf("Declare 2 "); }
      ;

PDMTransActions
      : ACTIONS PDMTransStmtList
         { printf("Procedure 1 "); }
      | ACTIONS PDMTransStmtList RETURN Id 
         { printf("Function 2 "); }
      ;

PDMTransStmtList
      : PDMTransStmt
      | PDMTransStmtList SEMICOLON PDMTransStmt
         { printf("StmtList 2 "); }
      ;

PDMTransStmt      
      : PDMTerm COLONEQ PDMTerm
         { printf("COLONEQ 2 "); }
      | Id LABELID COLONEQ PDMTerm
         { printf("COLONEQID 2 "); }
      | REMOVE PDMTerm FROM Id
         { printf("REMOVE 2 "); }
      | INSERT PDMTerm IN Id
         { printf("INSERT 2 "); }
      | CREATE PDMTerm FOR Id
         { printf("CREATE 2 "); }
      | DESTROY PDMTerm FOR Id
         { printf("DESTROY 2 "); }
      | ALLOCATE PDMTerm FROM Id
         { printf("ALLOCATE 2 "); }
      | ALLOCATE INDIRECT PDMTerm FROM Id
         { printf("ALLOCATEINDIRECT 2 "); }
      | FREE PDMTerm TO Id
         { printf("FREE 2 "); }
      | FREE INDIRECT PDMTerm TO Id
         { printf("FREEINDIRECT 2 "); }
      | COPY PDMTerm TO PDMTerm FOR Id
         { printf("COPY 3 "); }
      | IF PDMPred THEN PDMTransStmtList PDMTransElsePart
         { printf("IF 3 "); }
      | ALLOC LABELID Id 
         { printf("ALLOCID 1 "); }
      | FREE LABELID Id 
         { printf("FREEID 1 "); }
		| INIT INDEX Id
			{ printf("INITINDEX 1 "); }
		| INIT STORE Id
			{ printf("INITSTORE 1 "); }
      ;

PDMTransElsePart
      : ENDIF
         { printf("ENDIF 0 "); }
      | ELSE PDMTransStmtList ENDIF
         { printf("ELSE 1 "); }
      | ELSE IF PDMPred THEN PDMTransStmtList PDMTransElsePart
         { printf("ELSEIF 3 "); }
      ;

/*<<<<<<<<<<<<<<<<<<<<   PDMPred   >>>>>>>>>>>>>>>>>>>>>*/
PDMPredList
      : PDMPred
      | PDMPred COMMA PDMPredList
         { printf("AndPred 2 "); }
      ;

PDMPred
      : PDMTerm EQ PDMTerm
         { printf("EqPred 2 "); }
      | PDMTerm LT PDMTerm
         { printf("LTPred 2 "); }
      | PDMTerm GT PDMTerm
         { printf("GTPred 2 "); }
      | PDMTerm LE PDMTerm
         { printf("LEPred 2 "); }
      | PDMTerm GE PDMTerm
         { printf("GEPred 2 "); }
      | PDMTerm NE PDMTerm
         { printf("NEPred 2 "); }
      | PDMTerm IS PDMTerm
         { printf("ISPred 2 "); }
      | PDMTerm IN PDMTerm
         { printf("INPred 2 "); }
      ;

PDMTerm    
      : PDMpath
      | FormattedInteger 
      | FormattedReal
      | String
      | LEFTP PDMTerm RIGHTP
      | MINUS PDMTerm
         { printf("UnSubOp 1 "); }
      | PDMTerm PLUS PDMTerm
         { printf("BinAddOp 2 "); }
      | PDMTerm MINUS PDMTerm
         { printf("BinSubOp 2 "); }
      | PDMTerm TIMES PDMTerm
         { printf("MultOp 2 "); }
      | PDMTerm DIVIDE PDMTerm
         { printf("DivOp 2 "); }
      | PDMTerm MOD PDMTerm
         { printf("ModOp 2 "); }
      | PDMTerm AS PDMTerm
         { printf("AS 2 "); }
      ;

/*<<<<<<<<<<<<<<<<<<<<   others   >>>>>>>>>>>>>>>>>>>>>*/
PDMpath
      : Id
      | PDMpath DOT Id
         { printf("At 2 "); } 
      ; 

PDMNameList
      : Identifier
      | Identifier COMMA PDMNameList
         { printf("IdList 2 "); } 
      ; 

PDMIdNameList
      : Id
      | Id COMMA PDMIdNameList
         { printf("IdList 2 "); } 
      ; 

PDMNameSeq   
      : Identifier
      | Identifier SEMICOLON PDMNameSeq
         { printf("IdList 2 "); } 
      ;

Identifier
      : ID
         { printf("%s ", yytext); }
      ;

Id
      : ID
         { printf("%s Id 1 ", yytext); }
      ;

PDMNumber
      : FormattedInteger
      | FormattedReal
      ;

FormattedReal
      : REAL
         { printf("Real \"%s\" Constant 2 ", yytext); }
      ;

FormattedInteger
      : INT
         { printf("Integer \"%s\" Constant 2 ", yytext); }
      ;

BareInteger
      : INT
         { printf("\"%s\" ", yytext); }
      ;

String
      : STRING
         { printf("%s StrLit 1 ", yytext); }
%%
/*
 * Copyright (C) 1989, G. E. Weddell.
 */
