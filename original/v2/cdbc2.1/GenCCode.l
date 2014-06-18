;***********************************************************************
; Copyright (C) 1989, G. E. Weddell.
;***********************************************************************

(declare
  (special OutPort *Dummy)
  (nlambda 

;names defined in the CDB grammar
      AbstDeclParens
      AbstDeclWPtrAbsDecl
      Access
      AddrOp
      AndPred
      ArgExpList
      ArrayExp
      ArrayVar
      ArrayVarWSize
      AssignAddOp
      AssignBitAndOp
      AssignBitOrOp
      AssignBitXOrOp
      AssignDivOp
      AssignLeftShiftOp
      AssignModOp
      AssignMultOp
      AssignOp
      AssignRightShiftOp
      AssignSubOp
      At
      Auto
      BangOp
      BinAddOp
      BinSubOp
      BitAndOp
      BitOrOp
      BitXOrOp
      Break
      CaseStmt
      CastExp
      Char
      CompArrayAbstDecl
      CompArrayWSizeAbstDecl
      CompFuncAbstDecl
      CompFuncAbstDeclWPList
      CompndStmt
      CompndStmtWDList
      CompndStmtWDListSList
      CompndStmtWSList
      CondExp
      Const
      Continue
      DeclList
      DeclSpec
      DeclSpecWVars
      DefaultStmt
      DivOp
      Do
      Double
      EnumList
      EnumWEnumList
      EnumWId
      EnumWIdEnumList
      EnumWInit
      EqPred
      ExprList
      ExprStmt
      Extern
;     ExternSchemaAccess
      FieldAcc
      File
      Float
      For
;     ForQuery
      ForWF
      ForWI
      ForWIF
      ForWIS
      ForWISF 
      ForWS
      ForWSF
      FuncBodyWDeclList
      FuncCall
      FuncCallP
      FuncDefn
      FuncDefnWDeclSpec
      FuncVar
      FuncVarWPIdList
      FuncVarWPTList
      GEPred
      GTPred
      Goto
      Id 
      IdList
;*    IdListWElipsis
      If
      IfElse
;     IfElseQuery
;     IfElseQueryWIdList 
;     IfQuery
;     IfQueryWIdList
      InitDecl
      InitDeclList
      InitList
      InitListHdr
      InitListHdrWCom
      Int
      LEPred
      LTPred
      LabeledStmt
      LeftShiftOp
      LogNot
      Long
      ModOp
      MultOp
      NEPred
      NullStmt
      OnesComp
      OrPred
      ParamDecl
      ParamList
;*    ParamListWElipsis
;     ParamQueryCall
      PostDec
      PostInc
      PreDec
      PreInc
      Preprocessor
      PrimExp
;     Prop
      Ptr
      PtrPtr
      PtrTSList
      PtrTSListPtr
      PtrVar
      Register
      Return
      ReturnWExp
      RightShiftOp
;     SchemaAccess
      Short
      Signed
      SimpArrayAbstDecl
      SimpArrayWSizeAbst
      SimpFuncAbstDecl
      SimpFuncAbstDeclWPList
      SizeExpOp
      SizeTypeOp
      Static
      StmtList
      StorDeclSpec
      StrLit 
      StructDecl
      StructDeclList
      StructFiller
      StructPacked
      StructVarList
      StructWDecl
      StructWId
      StructWIdDecl
      Switch
      TypeDeclSpec
      TypeDef
      TypeSpecList
      TypeSpecListWAbsDecl
      UnAddOp
      UnSubOp
      UnionWDecl
      UnionWId
      UnionWIdDecl
      Unsigned
      VarWParens
      Void
      Volatile
      While
;     WhileQuery
;     WhileQueryWIdList


;extra namres for code generation
      Constant
      Comment
      DefineStore
      EmptyStmt
      ExternDeclSpecWVars
      EvalFirstParm
      FuncVarDecl
      Preprocessor1
      ))


;***********************************************************************************************************************************
;***********************************************************************************************************************************


(defun AbstDeclParens fexpr (L)
  (patom "(" OutPort)
  (eval (car L))
  (patom ")" OutPort))


(defun AbstDeclWPtrAbsDecl fexpr (L)
  (eval (car L))
  (eval (cadr L)))


(defun Access fexpr (L)
  (eval (car L))
  (patom "." OutPort)
  (eval (cadr L)))


(defun AddrOp fexpr (L)
  (patom "&" OutPort)
  (eval (car L)))


(defun AndPred fexpr (L)
  (eval (car L))
  (patom " && " OutPort)
  (eval (cadr L)))


(defun ArgExpList fexpr (L)
  (eval (car L))
  (patom ", " OutPort)
  (eval (cadr L)))


(defun ArrayExp fexpr (L)
  (eval (car L))
  (patom "[" OutPort)
  (eval (cadr L))
  (patom "] " OutPort))


(defun ArrayVar fexpr (L)
  (eval (car L))
  (patom "[] " OutPort))


(defun ArrayVarWSize fexpr (L)
  (eval (car L))
  (patom "[" OutPort)
  (eval (cadr L))
  (patom "] " OutPort))


(defun AssignAddOp fexpr (L)
  (eval (car L))
  (patom " += " OutPort)
  (eval (cadr L)))


(defun AssignBitAndOp fexpr (L)
  (eval (car L))
  (patom " &= " OutPort)
  (eval (cadr L)))


(defun AssignBitOrOp fexpr (L)
  (eval (car L))
  (patom " |= " OutPort)
  (eval (cadr L)))


(defun AssignBitXOrOp fexpr (L)
  (eval (car L))
  (patom " ^= " OutPort)
  (eval (cadr L)))


(defun AssignDivOp fexpr (L)
  (eval (car L))
  (patom " /= " OutPort)
  (eval (cadr L)))


(defun AssignLeftShiftOp fexpr (L)
  (eval (car L))
  (patom " <<= " OutPort)
  (eval (cadr L)))


(defun AssignModOp fexpr (L)
  (eval (car L))
  (patom " %= " OutPort)
  (eval (cadr L)))


(defun AssignMultOp fexpr (L)
  (eval (car L))
  (patom " *= " OutPort)
  (eval (cadr L)))


(defun AssignOp fexpr (L)
  (eval (car L))
  (patom " = " OutPort)
  (eval (cadr L)))


(defun AssignRightShiftOp fexpr (L)
  (eval (car L))
  (patom " >>= " OutPort)
  (eval (cadr L)))


(defun AssignSubOp fexpr (L)
  (eval (car L))
  (patom " -= " OutPort)
  (eval (cadr L)))


(defun At fexpr (L)
  (eval (car L))
  (patom "@" OutPort)
  (eval (cadr L)))


(defun Auto fexpr (L)
  (patom "auto " OutPort))


(defun BangOp fexpr (L)
  (patom "*" OutPort)
  (eval (car L)))


(defun BinAddOp fexpr (L)
  (eval (car L))
  (patom " + " OutPort)
  (eval (cadr L)))


(defun BinSubOp fexpr (L)
  (eval (car L))
  (patom " - " OutPort)
  (eval (cadr L)))


(defun BitAndOp fexpr (L)
  (eval (car L))
  (patom " & " OutPort)
  (eval (cadr L)))


(defun BitOrOp fexpr (L)
  (eval (car L))
  (patom " | " OutPort)
  (eval (cadr L)))


(defun BitXOrOp fexpr (L)
  (eval (car L))
  (patom " ^ " OutPort)
  (eval (cadr L)))


(defun Break fexpr (L)
  (patom "break;" OutPort)
  (terpri OutPort))


(defun CaseStmt fexpr (L)
  (patom "case " OutPort)
  (eval (car L))
  (patom ":" OutPort)
  (terpri OutPort)
  (eval (cadr L)))


(defun CastExp fexpr (L)
  (patom "(" OutPort)
  (eval (car L))
  (patom ")" OutPort)
  (eval (cadr L)))


(defun Char fexpr (L)
  (patom "char " OutPort))
   

(defun CompndArrayAbstDecl fexpr (L)
  (eval (car L))
  (patom "[]" OutPort))


(defun CompndArrayWSizeAbstDecl fexpr (L)
  (eval (car L))
  (patom "[" OutPort)
  (eval (cadr L))
  (patom "]" OutPort))


(defun CompndFuncAbstDecl fexpr (L)
  (eval (car L))
  (patom "(" OutPort)
  (patom ")" OutPort))


(defun CompndFuncAbstDeclWPList fexpr (L)
  (eval (car L))
  (patom "(" OutPort)
  (eval (cadr L))
  (patom ")" OutPort))


(defun CompndStmt fexpr (L)
  (patom "{" OutPort)
  (terpri OutPort)
  (patom "}" OutPort))


(defun CompndStmtWDList fexpr (L)
  (patom "{" OutPort)
  (terpri OutPort)
  (eval (car L))
  (patom "}" OutPort))


(defun CompndStmtWDListSList fexpr (L)
  (patom "{" OutPort)
  (terpri OutPort)
  (eval (car L))
  (eval (cadr L))
  (patom "}" OutPort))


(defun CompndStmtWSList fexpr (L)
  (patom "{" OutPort)
  (terpri OutPort)
  (eval (car L))
  (patom "}" OutPort))


(defun CondExp fexpr (L)
  (eval (car L))
  (patom " ? " OutPort)
  (eval (cadr L))
  (patom " : " OutPort)
  (eval (caddr L)))


(defun Const fexpr (L)
  (patom (car L) OutPort))


(defun Continue fexpr (L)
  (patom "continue" OutPort))


(defun DeclList fexpr (L)
  (eval (car L))
  (eval (cadr L)))


(defun DeclSpec fexpr (L)
  (eval (car L))
  (patom ";" OutPort)
  (terpri OutPort))


(defun DeclSpecWVars fexpr (L)
  (eval (car L))
  (eval (cadr L))
  (patom ";" OutPort)
  (terpri OutPort))


(defun DefaultStmt fexpr (L)
  (patom "default:" OutPort)
  (terpri OutPort)
  (eval (car L)))


(defun DivOp fexpr (L)
  (eval (car L))
  (patom " / " OutPort)
  (eval (cadr L)))


(defun Do fexpr (L)
  (patom "do " OutPort)
  (eval (car L))
  (patom "while (" OutPort)
  (eval (cadr L))
  (patom ");" OutPort))


(defun Double fexpr (L)
  (patom "double " OutPort))
   

(defun EnumList fexpr (L)
  (eval (car L))
  (patom ", " OutPort)
  (eval (cadr L)))


(defun EnumWEnumList fexpr (L)
  (patom "enum {" OutPort)
  (eval (car L))
  (patom "}" OutPort))


(defun EnumWId fexpr (L)
  (patom "enum " OutPort)
  (eval (car L)))


(defun EnumWIdEnumList fexpr (L)
  (patom "enum " OutPort)
  (eval (car L))
  (patom "{" OutPort)
  (eval (cadr L))
  (patom "}" OutPort))


(defun EnumWInit fexpr (L)
  (eval (car L))
  (patom " = " OutPort)
  (eval (cadr L)))


(defun EqPred fexpr (L)
  (eval (car L))
  (patom " == " OutPort)
  (eval (cadr L)))


(defun ExprList fexpr (L)
  (eval (car L))
  (patom ", " OutPort)
  (eval (cadr L)))


(defun ExprStmt fexpr (L)
  (eval (car L))
  (patom ";" OutPort)
  (terpri OutPort))


(defun Extern fexpr (L)
  (patom "extern " OutPort))


(defun FieldAcc fexpr (L)
  (eval (car L))
  (patom "->" OutPort)
  (eval (cadr L)))
   

(defun File fexpr (L)
  (eval (car L))
  (eval (cadr L)))
   

(defun Float fexpr (L)
  (patom "float " OutPort))
   

(defun For fexpr (L)
  (patom "for (;;)" OutPort)
  (eval (car L)))


(defun ForWF fexpr (L)
  (patom "for (;;" OutPort)
  (eval (car L))
  (patom ")" OutPort)
  (eval (cadr L)))


(defun ForWI fexpr (L)
  (patom "for (" OutPort)
  (eval (car L))
  (patom ";;)" OutPort)
  (eval (cadr L)))


(defun ForWIF fexpr (L)
  (patom "for (" OutPort)
  (eval (car L))
  (patom ";;" OutPort)
  (eval (cadr L))
  (patom ")" OutPort)
  (eval (caddr L)))


(defun ForWIS fexpr (L)
  (patom "for (" OutPort)
  (eval (car L))
  (patom ";" OutPort)
  (eval (cadr L))
  (patom ";)" OutPort)
  (eval (caddr L)))


(defun ForWISF fexpr (L)
  (patom "for (" OutPort)
  (eval (car L))
  (patom ";" OutPort)
  (eval (cadr L))
  (patom ";" OutPort)
  (eval (caddr L))
  (patom ")" OutPort)
  (eval (cadddr L)))


(defun ForWS fexpr (L)
  (patom "for (;" OutPort)
  (eval (car L))
  (patom ";)" OutPort)
  (eval (cadr L)))


(defun ForWSF fexpr (L)
  (patom "for (;" OutPort)
  (eval (car L))
  (patom ";" OutPort)
  (eval (cadr L))
  (patom ")" OutPort)
  (eval (caddr L)))


(defun FuncBodyWDeclList fexpr (L)
  (eval (car L))
  (eval (cadr L))) 


(defun FuncCall fexpr (L)
  (eval (car L))
  (patom "(" OutPort)
  (patom ")" OutPort))


(defun FuncCallP fexpr (L)
  (eval (car L))
  (patom "(" OutPort)
  (eval (cadr L))
  (patom ")" OutPort))


(defun FuncDefn fexpr (L) 
  (terpri OutPort)
  (terpri OutPort)
  (eval (car L))
  (eval (cadr L)))


(defun FuncDefnWDeclSpec fexpr (L)
  (terpri OutPort)
  (terpri OutPort)
  (eval (car L))
  (eval (cadr L))
  (eval (caddr L)))


(defun FuncVar fexpr (L)
  (eval (car L))
  (patom "()" OutPort)
  (terpri OutPort))
   

(defun FuncVarWPIdList fexpr (L)
  (eval (car L))
  (patom "(" OutPort)  
  (eval (cadr L))
  (patom ")" OutPort)
  (terpri OutPort))


(defun FuncVarWPTList fexpr (L)
  (eval (car L))
  (patom "(" OutPort)  
  (eval (cadr L))
  (patom ")" OutPort)
  (terpri OutPort))


(defun GEPred fexpr (L)
  (eval (car L))
  (patom " >= " OutPort)
  (eval (cadr L)))


(defun GTPred fexpr (L)
  (eval (car L))
  (patom " > " OutPort)
  (eval (cadr L)))


(defun Goto fexpr (L)
  (patom "goto " OutPort)
  (eval (car L))
  (patom "; " OutPort)
  (terpri OutPort))


(defun Id fexpr (L)
  (print (car L) OutPort))


(defun IdList fexpr (L)
  (eval (car L))
  (patom ", " OutPort)
  (eval (cadr L)))


(defun If fexpr (L)
  (patom "if (" OutPort)
  (eval (car L))
  (patom ")" OutPort)
  (terpri OutPort)
  (eval (cadr L)))


(defun IfElse fexpr (L)
  (patom "if (" OutPort)
  (eval (car L))
  (patom ")" OutPort)
  (terpri OutPort)
  (eval (cadr L))
  (patom "else " OutPort)
  (terpri OutPort)
  (eval (caddr L)))


(defun InitDecl fexpr (L)
  (eval (car L))
  (patom " = " OutPort)
  (eval (cadr L)))


(defun InitDeclList fexpr (L)
  (eval (car L))
  (patom ", " OutPort)
  (eval (cadr L)))


(defun InitList fexpr (L)
  (eval (car L))
  (patom ", " OutPort)
  (eval (cadr L)))


(defun InitListHdr fexpr (L)
  (patom "{" OutPort)
  (eval (car L))
  (patom "}" OutPort))


(defun InitListHdrWCom fexpr (L)
  (patom "{" OutPort)
  (eval (car L))
  (patom ",}" OutPort))


(defun Int fexpr (L)
  (patom "int " OutPort))


(defun LEPred fexpr (L)
  (eval (car L))
  (patom " <= " OutPort)
  (eval (cadr L)))


(defun LTPred fexpr (L)
  (eval (car L))
  (patom " < " OutPort)
  (eval (cadr L)))


(defun LabeledStmt fexpr (L)
  (eval (car L))
  (patom ": " OutPort)
  (eval (cadr L)))


(defun LeftShiftOp fexpr (L)
  (eval (car L))
  (patom " << " OutPort)
  (eval (cadr L)))


(defun Long fexpr (L)
  (patom "long " OutPort))


(defun LogNot fexpr (L)
  (patom " ! " OutPort)
  (eval (car L)))


(defun ModOp fexpr (L)
  (eval (car L))
  (patom " % " OutPort)
  (eval (cadr L)))


(defun MultOp fexpr (L)
  (eval (car L))
  (patom " * " OutPort)
  (eval (cadr L)))


(defun NEPred fexpr (L)
  (eval (car L))
  (patom " != " OutPort)
  (eval (cadr L)))


(defun NullStmt fexpr (L)
  (patom ";" OutPort))


(defun OnesComp fexpr (L)
  (patom " ~ " OutPort)
  (eval (car L)))


(defun OrPred fexpr (L)
  (eval (car L))
  (patom " || " OutPort)
  (eval (cadr L)))


(defun ParamDecl fexpr (L)
  (eval (car L))
  (eval (cadr L)))


(defun ParamList fexpr (L)
  (eval (car L))
  (patom " , " OutPort)
  (eval (cadr L)))


(defun PostDec fexpr (L)
  (eval (car L))
  (patom "--" OutPort))


(defun PostInc fexpr (L)
  (eval (car L))
  (patom "++" OutPort))


(defun PreDec fexpr (L)
  (patom "--" OutPort)
  (eval (car L)))


(defun PreInc fexpr (L)
  (patom "++" OutPort)
  (eval (car L)))


(defun Preprocessor fexpr (L)
  (patom "#" OutPort)
  (patom (car L) OutPort)
  (terpri OutPort))


(defun PrimExp fexpr (L)
  (patom "(" OutPort)
  (eval (car L))
  (patom ")" OutPort))


(defun Ptr fexpr (L)
  (patom "*" OutPort))


(defun PtrPtr fexpr (L) 
  (patom "*" OutPort)
  (eval (car L)))
   

(defun PtrTSList fexpr (L) 
  (patom "*" OutPort)
  (eval (car L)))
   

(defun PtrTSListPtr fexpr (L) 
  (patom "*" OutPort)
  (eval (car L))
  (eval (cadr L)))
   

(defun PtrVar fexpr (L)
  (eval (car L))
  (eval (cadr L)))


(defun Register fexpr (L)
  (patom "register " OutPort))


(defun Return fexpr (L)
  (patom "return;" OutPort)) 


(defun ReturnWExp fexpr (L)
  (patom "return" OutPort) 
  (eval (car L))
  (patom ";" OutPort)
  (terpri OutPort))


(defun RightShiftOp fexpr (L)
  (eval (car L))
  (patom " << " OutPort)
  (eval (cadr L)))


(defun Short fexpr (L)
  (patom "short " OutPort))


(defun Signed fexpr (L)
  (patom "signed " OutPort))


(defun SimpArrayAbstDecl fexpr (L)
  (patom "[]" OutPort))


(defun SimpArrayWSizeAbst fexpr (L)
  (patom "[" OutPort)
  (eval (car L))
  (patom "]" OutPort))


(defun SimpFuncAbstDecl fexpr (L)
  (patom "()" OutPort))


(defun SimpFuncAbstDeclWPList fexpr (L)
  (patom "(" OutPort)
  (eval (car L))
  (patom ")" OutPort))


(defun SizeExpOp fexpr (L)
  (patom " sizeof " OutPort) 
  (eval (car L)))


(defun SizeTypeOp fexpr (L)
  (patom " sizeof(" OutPort) 
  (eval (car L))
  (patom ") " OutPort))


(defun Static fexpr (L)
  (patom "static " OutPort))


(defun StmtList fexpr (L)
   (eval (car L))
   (eval (cadr L)))


(defun StorDeclSpec fexpr (L)
   (eval (car L))
   (eval (cadr L)))


(defun StrLit fexpr (L)
   (print (car L) OutPort))


(defun StructDecl fexpr (L)
   (eval (car L))
   (eval (cadr L))
   (patom ";" OutPort)
   (terpri OutPort))
   

(defun StructDeclList fexpr (L)
   (eval (car L))
   (eval (cadr L)))


(defun StructFiller fexpr (L)
   (patom " : " OutPort)
   (eval (car L)))


(defun StructPacked fexpr (L)
   (eval (car L))
   (patom " : " OutPort)
   (eval (cadr L)))


(defun StructVarList fexpr (L)
   (eval (car L))
   (patom ", " OutPort)
   (eval (cadr L)))


(defun StructWDecl fexpr (L)
   (patom "struct {" OutPort)
   (eval (car L))
   (patom "} " OutPort))
   

(defun StructWId fexpr (L)
   (patom "struct " OutPort)
   (eval (car L))
   (patom " " OutPort))
   

(defun StructWIdDecl fexpr (L)
   (terpri OutPort)
   (patom "struct " OutPort)
   (eval (car L))
   (patom " { " OutPort)
   (terpri OutPort)
   (eval (cadr L))
   (patom "}" OutPort))
   

(defun Switch fexpr (L)
  (patom "switch (" OutPort)
  (eval (car L))
  (patom ")" OutPort)
  (terpri OutPort)
  (eval (cadr L)))


(defun TypeDeclSpec fexpr (L)
  (eval (car L))
  (eval (cadr L)))


(defun TypeDef fexpr (L)
  (patom "TypeDef " OutPort))


(defun TypeSpecList fexpr (L)
  (eval (car L))
  (eval (cadr L)))


(defun TypeSpecListWAbsDecl fexpr (L)
  (eval (car L))
  (eval (cadr L)))


(defun UnAddOp fexpr (L)
  (patom " + " OutPort)
  (eval (car L)))


(defun UnSubOp fexpr (L)
  (patom " - " OutPort)
  (eval (car L)))


(defun UnionWDecl fexpr (L)
  (patom "union " OutPort)
  (patom "{" OutPort)
  (eval (car L))
  (patom "}" OutPort))


(defun UnionWId fexpr (L)
  (patom "union " OutPort)
  (eval (car L)))


(defun UnionWIdDecl fexpr (L)
  (patom "union " OutPort)
  (eval (car L))
  (patom "{" OutPort)
  (eval (cadr L))
  (patom "}" OutPort))


(defun Unsigned fexpr (L)
  (patom "unsigned " OutPort))


(defun VarWParens fexpr (L)
  (patom "(" OutPort)
  (eval (car L))
  (patom ") " OutPort))


(defun Void fexpr (L)
  (patom "void " OutPort))


(defun Volatile fexpr (L)
  (patom "volatile " OutPort))
   

(defun While fexpr (L)
   (patom "while (" OutPort)
   (eval (car L))
   (patom ")" OutPort)
   (terpri OutPort)
   (eval (cadr L)))


;***********************************************************************************************************************************
;***********************************************************************************************************************************


(defun GenCode (Source OutFile)
  (setq OutPort (fileopen OutFile "w"))
  (eval Source)
  (close OutPort))


(defun Constant fexpr (L)
  (patom (cadr L) OutPort))


(defun Comment fexpr (L)
  (terpri OutPort)
  (terpri OutPort)
  (patom "/* " OutPort)
  (patom (car L) OutPort)
  (patom " */" OutPort)
  (terpri OutPort)
  (terpri OutPort))


(defun DefineStore fexpr (L)
  (patom "#define " OutPort)
  (patom (car L) OutPort)
  (patom " ( sizeof( " OutPort)
  (cond 
   ((equal (length (cadr L)) 1)
    (patom "struct " OutPort)
    (patom (caadr L) OutPort)
    (patom " ) )" OutPort))
   (t
    (patom "union { " OutPort)
    (SubDefineStore (cadr L))
    (patom " } ) )" OutPort)))
  (terpri OutPort))


(defun EmptyStmt fexpr (L)
  (patom "" OutPort))


(defun ExternDeclSpecWVars fexpr (L)
  (patom "extern " OutPort)
  (eval (car L))
  (eval (cadr L))
  (patom ";" OutPort)
  (terpri OutPort))


(defun EvalFirstParm fexpr (L)
  (eval (car L)))
   

(defun FuncVarDecl fexpr (L)
  (eval (car L))
  (patom "()" OutPort))


(defun Preprocessor1 fexpr (L)
  (prog (Temp)
        (patom "#" OutPort)
        (do Temp (car L) (cdr Temp) (null Temp)
            (patom (car Temp) OutPort)
            (patom " " OutPort))
        (terpri OutPort)))


(defun SubDefineStore (L)
  (cond
   ((null L))
   (t
    (patom "struct " OutPort)
    (patom (car L) OutPort)
    (patom " " OutPort)
    (patom (GenerateName 'Dummy) OutPort)
    (patom "; " OutPort)
    (SubDefineStore (cdr L)))))


;***********************************************************************************************************************************
;***********************************************************************************************************************************
