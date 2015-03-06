;***********************************************************************
; Copyright (C) 1989, G. E. Weddell.
;***********************************************************************

(defvar OutPort)

;***********************************************************************************************************************************
;***********************************************************************************************************************************


(defun AbstDeclParens fexpr (L)
  (princ "(" OutPort)
  (eval (car L))
  (princ ")" OutPort))


(defun AbstDeclWPtrAbsDecl fexpr (L)
  (eval (car L))
  (eval (cadr L)))


(defun Access fexpr (L)
  (eval (car L))
  (princ "." OutPort)
  (eval (cadr L)))


(defun AddrOp fexpr (L)
  (princ "&" OutPort)
  (eval (car L)))


(defun AndPred fexpr (L)
  (eval (car L))
  (princ " && " OutPort)
  (eval (cadr L)))


(defun ArgExpList fexpr (L)
  (eval (car L))
  (princ ", " OutPort)
  (eval (cadr L)))


(defun ArrayExp fexpr (L)
  (eval (car L))
  (princ "[" OutPort)
  (eval (cadr L))
  (princ "] " OutPort))


(defun ArrayVar fexpr (L)
  (eval (car L))
  (princ "[] " OutPort))


(defun ArrayVarWSize fexpr (L)
  (eval (car L))
  (princ "[" OutPort)
  (eval (cadr L))
  (princ "] " OutPort))


(defun AssignAddOp fexpr (L)
  (eval (car L))
  (princ " += " OutPort)
  (eval (cadr L)))


(defun AssignBitAndOp fexpr (L)
  (eval (car L))
  (princ " &= " OutPort)
  (eval (cadr L)))


(defun AssignBitOrOp fexpr (L)
  (eval (car L))
  (princ " |= " OutPort)
  (eval (cadr L)))


(defun AssignBitXOrOp fexpr (L)
  (eval (car L))
  (princ " ^= " OutPort)
  (eval (cadr L)))


(defun AssignDivOp fexpr (L)
  (eval (car L))
  (princ " /= " OutPort)
  (eval (cadr L)))


(defun AssignLeftShiftOp fexpr (L)
  (eval (car L))
  (princ " <<= " OutPort)
  (eval (cadr L)))


(defun AssignModOp fexpr (L)
  (eval (car L))
  (princ " %= " OutPort)
  (eval (cadr L)))


(defun AssignMultOp fexpr (L)
  (eval (car L))
  (princ " *= " OutPort)
  (eval (cadr L)))


(defun AssignOp fexpr (L)
  (eval (car L))
  (princ " = " OutPort)
  (eval (cadr L)))


(defun AssignRightShiftOp fexpr (L)
  (eval (car L))
  (princ " >>= " OutPort)
  (eval (cadr L)))


(defun AssignSubOp fexpr (L)
  (eval (car L))
  (princ " -= " OutPort)
  (eval (cadr L)))


(defun At fexpr (L)
  (eval (car L))
  (princ "@" OutPort)
  (eval (cadr L)))


(defun Auto fexpr (L)
  (princ "auto " OutPort))


(defun BangOp fexpr (L)
  (princ "*" OutPort)
  (eval (car L)))


(defun BinAddOp fexpr (L)
  (eval (car L))
  (princ " + " OutPort)
  (eval (cadr L)))


(defun BinSubOp fexpr (L)
  (eval (car L))
  (princ " - " OutPort)
  (eval (cadr L)))


(defun BitAndOp fexpr (L)
  (eval (car L))
  (princ " & " OutPort)
  (eval (cadr L)))


(defun BitOrOp fexpr (L)
  (eval (car L))
  (princ " | " OutPort)
  (eval (cadr L)))


(defun BitXOrOp fexpr (L)
  (eval (car L))
  (princ " ^ " OutPort)
  (eval (cadr L)))


(defun Break fexpr (L)
  (princ "break;" OutPort)
  (terpri OutPort))


(defun CaseStmt fexpr (L)
  (princ "case " OutPort)
  (eval (car L))
  (princ ":" OutPort)
  (terpri OutPort)
  (eval (cadr L)))


(defun CastExp fexpr (L)
  (princ "(" OutPort)
  (eval (car L))
  (princ ")" OutPort)
  (eval (cadr L)))


(defun Char fexpr (L)
  (princ "char " OutPort))
   

(defun CompndArrayAbstDecl fexpr (L)
  (eval (car L))
  (princ "[]" OutPort))


(defun CompndArrayWSizeAbstDecl fexpr (L)
  (eval (car L))
  (princ "[" OutPort)
  (eval (cadr L))
  (princ "]" OutPort))


(defun CompndFuncAbstDecl fexpr (L)
  (eval (car L))
  (princ "(" OutPort)
  (princ ")" OutPort))


(defun CompndFuncAbstDeclWPList fexpr (L)
  (eval (car L))
  (princ "(" OutPort)
  (eval (cadr L))
  (princ ")" OutPort))


(defun CompndStmt fexpr (L)
  (princ "{" OutPort)
  (terpri OutPort)
  (princ "}" OutPort))


(defun CompndStmtWDList fexpr (L)
  (princ "{" OutPort)
  (terpri OutPort)
  (eval (car L))
  (princ "}" OutPort))


(defun CompndStmtWDListSList fexpr (L)
  (princ "{" OutPort)
  (terpri OutPort)
  (eval (car L))
  (eval (cadr L))
  (princ "}" OutPort))


(defun CompndStmtWSList fexpr (L)
  (princ "{" OutPort)
  (terpri OutPort)
  (eval (car L))
  (princ "}" OutPort))


(defun CondExp fexpr (L)
  (eval (car L))
  (princ " ? " OutPort)
  (eval (cadr L))
  (princ " : " OutPort)
  (eval (caddr L)))


(defun Const fexpr (L)
  (princ (car L) OutPort))


(defun Continue fexpr (L)
  (princ "continue" OutPort))


(defun DeclList fexpr (L)
  (eval (car L))
  (eval (cadr L)))


(defun DeclSpec fexpr (L)
  (eval (car L))
  (princ ";" OutPort)
  (terpri OutPort))


(defun DeclSpecWVars fexpr (L)
  (eval (car L))
  (eval (cadr L))
  (princ ";" OutPort)
  (terpri OutPort))


(defun DefaultStmt fexpr (L)
  (princ "default:" OutPort)
  (terpri OutPort)
  (eval (car L)))


(defun DivOp fexpr (L)
  (eval (car L))
  (princ " / " OutPort)
  (eval (cadr L)))


(defun Do fexpr (L)
  (princ "do " OutPort)
  (eval (car L))
  (princ "while (" OutPort)
  (eval (cadr L))
  (princ ");" OutPort))


(defun Double fexpr (L)
  (princ "double " OutPort))
   

(defun EnumList fexpr (L)
  (eval (car L))
  (princ ", " OutPort)
  (eval (cadr L)))


(defun EnumWEnumList fexpr (L)
  (princ "enum {" OutPort)
  (eval (car L))
  (princ "}" OutPort))


(defun EnumWId fexpr (L)
  (princ "enum " OutPort)
  (eval (car L)))


(defun EnumWIdEnumList fexpr (L)
  (princ "enum " OutPort)
  (eval (car L))
  (princ "{" OutPort)
  (eval (cadr L))
  (princ "}" OutPort))


(defun EnumWInit fexpr (L)
  (eval (car L))
  (princ " = " OutPort)
  (eval (cadr L)))


(defun EqPred fexpr (L)
  (eval (car L))
  (princ " == " OutPort)
  (eval (cadr L)))


(defun ExprList fexpr (L)
  (eval (car L))
  (princ ", " OutPort)
  (eval (cadr L)))


(defun ExprStmt fexpr (L)
  (eval (car L))
  (princ ";" OutPort)
  (terpri OutPort))


(defun Extern fexpr (L)
  (princ "extern " OutPort))


(defun FieldAcc fexpr (L)
  (eval (car L))
  (princ "->" OutPort)
  (eval (cadr L)))
   

(defun File fexpr (L)
  (eval (car L))
  (eval (cadr L)))
   

(defun Float fexpr (L)
  (princ "float " OutPort))
   

(defun For fexpr (L)
  (princ "for (;;)" OutPort)
  (eval (car L)))


(defun ForWF fexpr (L)
  (princ "for (;;" OutPort)
  (eval (car L))
  (princ ")" OutPort)
  (eval (cadr L)))


(defun ForWI fexpr (L)
  (princ "for (" OutPort)
  (eval (car L))
  (princ ";;)" OutPort)
  (eval (cadr L)))


(defun ForWIF fexpr (L)
  (princ "for (" OutPort)
  (eval (car L))
  (princ ";;" OutPort)
  (eval (cadr L))
  (princ ")" OutPort)
  (eval (caddr L)))


(defun ForWIS fexpr (L)
  (princ "for (" OutPort)
  (eval (car L))
  (princ ";" OutPort)
  (eval (cadr L))
  (princ ";)" OutPort)
  (eval (caddr L)))


(defun ForWISF fexpr (L)
  (princ "for (" OutPort)
  (eval (car L))
  (princ ";" OutPort)
  (eval (cadr L))
  (princ ";" OutPort)
  (eval (caddr L))
  (princ ")" OutPort)
  (eval (cadddr L)))


(defun ForWS fexpr (L)
  (princ "for (;" OutPort)
  (eval (car L))
  (princ ";)" OutPort)
  (eval (cadr L)))


(defun ForWSF fexpr (L)
  (princ "for (;" OutPort)
  (eval (car L))
  (princ ";" OutPort)
  (eval (cadr L))
  (princ ")" OutPort)
  (eval (caddr L)))


(defun FuncBodyWDeclList fexpr (L)
  (eval (car L))
  (eval (cadr L))) 


(defun FuncCall fexpr (L)
  (eval (car L))
  (princ "(" OutPort)
  (princ ")" OutPort))


(defun FuncCallP fexpr (L)
  (eval (car L))
  (princ "(" OutPort)
  (eval (cadr L))
  (princ ")" OutPort))


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
  (princ "()" OutPort)
  (terpri OutPort))
   

(defun FuncVarWPIdList fexpr (L)
  (eval (car L))
  (princ "(" OutPort)  
  (eval (cadr L))
  (princ ")" OutPort)
  (terpri OutPort))


(defun FuncVarWPTList fexpr (L)
  (eval (car L))
  (princ "(" OutPort)  
  (eval (cadr L))
  (princ ")" OutPort)
  (terpri OutPort))


(defun GEPred fexpr (L)
  (eval (car L))
  (princ " >= " OutPort)
  (eval (cadr L)))


(defun GTPred fexpr (L)
  (eval (car L))
  (princ " > " OutPort)
  (eval (cadr L)))


(defun Goto fexpr (L)
  (princ "goto " OutPort)
  (eval (car L))
  (princ "; " OutPort)
  (terpri OutPort))


(defun Id fexpr (L)
  (print (car L) OutPort))


(defun IdList fexpr (L)
  (eval (car L))
  (princ ", " OutPort)
  (eval (cadr L)))


(defun If fexpr (L)
  (princ "if (" OutPort)
  (eval (car L))
  (princ ")" OutPort)
  (terpri OutPort)
  (eval (cadr L)))


(defun IfElse fexpr (L)
  (princ "if (" OutPort)
  (eval (car L))
  (princ ")" OutPort)
  (terpri OutPort)
  (eval (cadr L))
  (princ "else " OutPort)
  (terpri OutPort)
  (eval (caddr L)))


(defun InitDecl fexpr (L)
  (eval (car L))
  (princ " = " OutPort)
  (eval (cadr L)))


(defun InitDeclList fexpr (L)
  (eval (car L))
  (princ ", " OutPort)
  (eval (cadr L)))


(defun InitList fexpr (L)
  (eval (car L))
  (princ ", " OutPort)
  (eval (cadr L)))


(defun InitListHdr fexpr (L)
  (princ "{" OutPort)
  (eval (car L))
  (princ "}" OutPort))


(defun InitListHdrWCom fexpr (L)
  (princ "{" OutPort)
  (eval (car L))
  (princ ",}" OutPort))


(defun InlineFuncDefn fexpr (L) 
  (terpri OutPort)
  (terpri OutPort)
  (cond ((equal InlineFlag 1) (princ "inline " OutPort)))
  (eval (car L))
  (eval (cadr L)))


(defun InlineFuncDefnWDeclSpec fexpr (L)
  (terpri OutPort)
  (terpri OutPort)
  (cond ((equal InlineFlag 1) (princ "inline " OutPort)))
  (eval (car L))
  (eval (cadr L))
  (eval (caddr L)))


(defun Int fexpr (L)
  (princ "int " OutPort))


(defun LEPred fexpr (L)
  (eval (car L))
  (princ " <= " OutPort)
  (eval (cadr L)))


(defun LTPred fexpr (L)
  (eval (car L))
  (princ " < " OutPort)
  (eval (cadr L)))


(defun LabeledStmt fexpr (L)
  (eval (car L))
  (princ ": " OutPort)
  (eval (cadr L)))


(defun LeftShiftOp fexpr (L)
  (eval (car L))
  (princ " << " OutPort)
  (eval (cadr L)))


(defun Long fexpr (L)
  (princ "long " OutPort))


(defun LogNot fexpr (L)
  (princ " ! " OutPort)
  (eval (car L)))


(defun ModOp fexpr (L)
  (eval (car L))
  (princ " % " OutPort)
  (eval (cadr L)))


(defun MultOp fexpr (L)
  (eval (car L))
  (princ " * " OutPort)
  (eval (cadr L)))


(defun NEPred fexpr (L)
  (eval (car L))
  (princ " != " OutPort)
  (eval (cadr L)))


(defun NullStmt fexpr (L)
  (princ ";" OutPort))


(defun OnesComp fexpr (L)
  (princ " ~ " OutPort)
  (eval (car L)))


(defun OrPred fexpr (L)
  (eval (car L))
  (princ " || " OutPort)
  (eval (cadr L)))


(defun ParamDecl fexpr (L)
  (eval (car L))
  (eval (cadr L)))


(defun ParamList fexpr (L)
  (eval (car L))
  (princ " , " OutPort)
  (eval (cadr L)))


(defun PostDec fexpr (L)
  (eval (car L))
  (princ "--" OutPort))


(defun PostInc fexpr (L)
  (eval (car L))
  (princ "++" OutPort))


(defun PreDec fexpr (L)
  (princ "--" OutPort)
  (eval (car L)))


(defun PreInc fexpr (L)
  (princ "++" OutPort)
  (eval (car L)))


(defun Preprocessor fexpr (L)
  (princ "#" OutPort)
  (princ (car L) OutPort)
  (terpri OutPort))


(defun PrimExp fexpr (L)
  (princ "(" OutPort)
  (eval (car L))
  (princ ")" OutPort))


(defun Ptr fexpr (L)
  (princ "*" OutPort))


(defun PtrPtr fexpr (L) 
  (princ "*" OutPort)
  (eval (car L)))
   

(defun PtrTSList fexpr (L) 
  (princ "*" OutPort)
  (eval (car L)))
   

(defun PtrTSListPtr fexpr (L) 
  (princ "*" OutPort)
  (eval (car L))
  (eval (cadr L)))
   

(defun PtrVar fexpr (L)
  (eval (car L))
  (eval (cadr L)))


(defun Register fexpr (L)
  (princ "register " OutPort))


(defun Return fexpr (L)
  (princ "return;" OutPort)) 


(defun ReturnWExp fexpr (L)
  (princ "return" OutPort) 
  (eval (car L))
  (princ ";" OutPort)
  (terpri OutPort))


(defun RightShiftOp fexpr (L)
  (eval (car L))
  (princ " << " OutPort)
  (eval (cadr L)))


(defun Short fexpr (L)
  (princ "short " OutPort))


(defun Signed fexpr (L)
  (princ "signed " OutPort))


(defun SimpArrayAbstDecl fexpr (L)
  (princ "[]" OutPort))


(defun SimpArrayWSizeAbst fexpr (L)
  (princ "[" OutPort)
  (eval (car L))
  (princ "]" OutPort))


(defun SimpFuncAbstDecl fexpr (L)
  (princ "()" OutPort))


(defun SimpFuncAbstDeclWPList fexpr (L)
  (princ "(" OutPort)
  (eval (car L))
  (princ ")" OutPort))


(defun SizeExpOp fexpr (L)
  (princ " sizeof " OutPort) 
  (eval (car L)))


(defun SizeTypeOp fexpr (L)
  (princ " sizeof(" OutPort) 
  (eval (car L))
  (princ ") " OutPort))


(defun Static fexpr (L)
  (princ "static " OutPort))


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
   (princ ";" OutPort)
   (terpri OutPort))
   

(defun StructDeclList fexpr (L)
   (eval (car L))
   (eval (cadr L)))


(defun StructFiller fexpr (L)
   (princ " : " OutPort)
   (eval (car L)))


(defun StructPacked fexpr (L)
   (eval (car L))
   (princ " : " OutPort)
   (eval (cadr L)))


(defun StructVarList fexpr (L)
   (eval (car L))
   (princ ", " OutPort)
   (eval (cadr L)))


(defun StructWDecl fexpr (L)
   (princ "struct {" OutPort)
   (eval (car L))
	(princ "} " OutPort))
   

(defun StructWId fexpr (L)
   (princ "struct " OutPort)
   (eval (car L))
	(princ " " OutPort))
   

(defun StructWIdDecl fexpr (L)
   (terpri OutPort)
   (princ "struct " OutPort)
   (eval (car L))
   (princ " { " OutPort)
   (terpri OutPort)
   (eval (cadr L))
   (princ "}" OutPort))
   

(defun Switch fexpr (L)
  (princ "switch (" OutPort)
  (eval (car L))
  (princ ")" OutPort)
  (terpri OutPort)
  (eval (cadr L)))


(defun TypeDeclSpec fexpr (L)
  (eval (car L))
  (eval (cadr L)))


(defun TypeDef fexpr (L)
  (princ "TypeDef " OutPort))


(defun TypeSpecList fexpr (L)
  (eval (car L))
  (eval (cadr L)))


(defun TypeSpecListWAbsDecl fexpr (L)
  (eval (car L))
  (eval (cadr L)))


(defun UnAddOp fexpr (L)
  (princ " + " OutPort)
  (eval (car L)))


(defun UnSubOp fexpr (L)
  (princ " - " OutPort)
  (eval (car L)))


(defun UnionWDecl fexpr (L)
  (princ "union " OutPort)
  (princ "{" OutPort)
  (eval (car L))
  (princ "}" OutPort))


(defun UnionWId fexpr (L)
  (princ "union " OutPort)
  (eval (car L)))


(defun UnionWIdDecl fexpr (L)
  (princ "union " OutPort)
  (eval (car L))
  (princ "{" OutPort)
  (eval (cadr L))
  (princ "}" OutPort))


(defun Unsigned fexpr (L)
  (princ "unsigned " OutPort))


(defun VarWParens fexpr (L)
  (princ "(" OutPort)
  (eval (car L))
  (princ ") " OutPort))


(defun Void fexpr (L)
  (princ "void " OutPort))


(defun Volatile fexpr (L)
  (princ "volatile " OutPort))
   

(defun While fexpr (L)
   (princ "while (" OutPort)
   (eval (car L))
   (princ ")" OutPort)
   (terpri OutPort)
   (eval (cadr L)))


;***********************************************************************************************************************************
;***********************************************************************************************************************************


(defun GenCode (Source OutFile)
  (setq OutPort (open OutFile
    :direction :output
    :if-does-not-exist :create
    :if-exists :supersede))
  (eval Source)
  (close OutPort))


(defun Constant fexpr (L)
  (princ (cadr L) OutPort))


(defun Comment fexpr (L)
  (terpri OutPort)
  (terpri OutPort)
  (princ "/* " OutPort)
  (princ (car L) OutPort)
  (princ " */" OutPort)
  (terpri OutPort)
  (terpri OutPort))


(defun DefineStore fexpr (L)
  (princ "#define " OutPort)
  (princ (car L) OutPort)
  (princ " ( sizeof( " OutPort)
  (cond 
	((equal (length (cadr L)) 1)
	 (princ "struct " OutPort)
	 (princ (caadr L) OutPort)
	 (princ " ) )" OutPort))
   (t
	 (princ "union { " OutPort)
	 (SubDefineStore (cadr L))
	 (princ " } ) )" OutPort)))
  (terpri OutPort))


(defun EmptyStmt fexpr (L)
  (princ "" OutPort))


(defun ExternDeclSpecWVars fexpr (L)
  (princ "extern " OutPort)
  (eval (car L))
  (eval (cadr L))
  (princ ";" OutPort)
  (terpri OutPort))


(defun EvalFirstParm fexpr (L)
  (eval (car L)))
   

(defun FuncVarDecl fexpr (L)
  (eval (car L))
  (princ "()" OutPort))


(defun Preprocessor1 fexpr (L)
  (prog (Temp)
		  (princ "#" OutPort)
		  (do ((Temp (car L) (cdr Temp))) ((null Temp))
				(princ (car Temp) OutPort)
				(princ " " OutPort))
		  (terpri OutPort)))


(defun SubDefineStore (L)
  (cond
	((null L))
	(t
	 (princ "struct " OutPort)
	 (princ (car L) OutPort)
	 (princ " " OutPort)
	 (princ (GenerateName 'Dummy) OutPort)
	 (princ "; " OutPort)
	 (SubDefineStore (cdr L)))))


;***********************************************************************************************************************************
;***********************************************************************************************************************************
