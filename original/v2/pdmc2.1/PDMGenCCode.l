;***********************************************************************
; Copyright (C) 1989, G. E. Weddell.
;***********************************************************************

(defvar OutPort)

;***********************************************************************************************************************************
;***********************************************************************************************************************************

(defvar TokenList '(ABSTDECLPARENS ABSTDECLWPTRABSDECL ACCESS ADDROP ANDPRED ARGEXPLIST ARRAYEXP ARRAYVAR ARRAYVARWSIZE ASSIGNADDOP ASSIGNBITANDOP ASSIGNBITOROP ASSIGNBITXOROP ASSIGNDIVOP ASSIGNLEFTSHIFTOP ASSIGNMODOP ASSIGNMULTOP ASSIGNOP ASSIGNRIGHTSHIFTOP ASSIGNSUBOP AT AUTO BANGOP BINADDOP BINSUBOP BITANDOP BITOROP BITXOROP BREAK CASESTMT CASTEXP CHAR COMPNDARRAYABSTDECL COMPNDARRAYWSIZEABSTDECL COMPNDFUNCABSTDECL COMPNDFUNCABSTDECLWPLIST COMPNDSTMT COMPNDSTMTWDLIST COMPNDSTMTWDLISTSLIST COMPNDSTMTWSLIST CONDEXP CONST CONTINUE DECLLIST DECLSPEC DECLSPECWVARS DEFAULTSTMT DIVOP DO DOUBLE ENUMLIST ENUMWENUMLIST ENUMWID ENUMWIDENUMLIST ENUMWINIT EQPRED EXPRLIST EXPRSTMT EXTERN FIELDACC FILE FLOAT FOR FORWF FORWI FORWIF FORWIS FORWISF FORWS FORWSF FUNCBODYWDECLLIST FUNCCALL FUNCCALLP FUNCDEFN FUNCDEFNWDECLSPEC FUNCVAR FUNCVARWPIDLIST FUNCVARWPTLIST GEPRED GTPRED GOTO ID IDLIST IF IFELSE INITDECL INITDECLLIST INITLIST INITLISTHDR INITLISTHDRWCOM INLINEFUNCDEFN INLINEFUNCDEFNWDECLSPEC INT LEPRED LTPRED LABELEDSTMT LEFTSHIFTOP LONG LOGNOT MODOP MULTOP NEPRED NULLSTMT ONESCOMP ORPRED PARAMDECL PARAMLIST POSTDEC POSTINC PREDEC PREINC PREPROCESSOR PRIMEXP PTR PTRPTR PTRTSLIST PTRTSLISTPTR PTRVAR REGISTER RETURN RETURNWEXP RIGHTSHIFTOP SHORT SIGNED SIMPARRAYABSTDECL SIMPARRAYWSIZEABST SIMPFUNCABSTDECL SIMPFUNCABSTDECLWPLIST SIZEEXPOP SIZETYPEOP STATIC STMTLIST STORDECLSPEC STRLIT STRUCTDECL STRUCTDECLLIST STRUCTFILLER STRUCTPACKED STRUCTVARLIST STRUCTWDECL STRUCTWID STRUCTWIDDECL SWITCH TYPEDECLSPEC TYPEDEF TYPESPECLIST TYPESPECLISTWABSDECL UNADDOP UNSUBOP UNIONWDECL UNIONWID UNIONWIDDECL UNSIGNED VARWPARENS VOID VOLATILE WHILE CONSTANT COMMENT DEFINESTORE EMPTYSTMT EXTERNDECLSPECWVARS EVALFIRSTPARM FUNCVARDECL PREPROCESSOR1))


(defun evalfexpr (L)
   (if (member (car L) TokenList)
      (eval (list (car L) (list 'quote (cdr L))))
      (eval (cons (car L) (mapcar (lambda (e) (list 'quote (evalfexpr e))) (cdr L))))))


(defun AbstDeclParens (L)
  (princ "(" OutPort)
  (evalfexpr (car L))
  (princ ")" OutPort))


(defun AbstDeclWPtrAbsDecl (L)
  (evalfexpr (car L))
  (evalfexpr (cadr L)))


(defun Access (L)
  (evalfexpr (car L))
  (princ "." OutPort)
  (evalfexpr (cadr L)))


(defun AddrOp (L)
  (princ "&" OutPort)
  (evalfexpr (car L)))


(defun AndPred (L)
  (evalfexpr (car L))
  (princ " && " OutPort)
  (evalfexpr (cadr L)))


(defun ArgExpList (L)
  (evalfexpr (car L))
  (princ ", " OutPort)
  (evalfexpr (cadr L)))


(defun ArrayExp (L)
  (evalfexpr (car L))
  (princ "[" OutPort)
  (evalfexpr (cadr L))
  (princ "] " OutPort))


(defun ArrayVar (L)
  (evalfexpr (car L))
  (princ "[] " OutPort))


(defun ArrayVarWSize (L)
  (evalfexpr (car L))
  (princ "[" OutPort)
  (evalfexpr (cadr L))
  (princ "] " OutPort))


(defun AssignAddOp (L)
  (evalfexpr (car L))
  (princ " += " OutPort)
  (evalfexpr (cadr L)))


(defun AssignBitAndOp (L)
  (evalfexpr (car L))
  (princ " &= " OutPort)
  (evalfexpr (cadr L)))


(defun AssignBitOrOp (L)
  (evalfexpr (car L))
  (princ " |= " OutPort)
  (evalfexpr (cadr L)))


(defun AssignBitXOrOp (L)
  (evalfexpr (car L))
  (princ " ^= " OutPort)
  (evalfexpr (cadr L)))


(defun AssignDivOp (L)
  (evalfexpr (car L))
  (princ " /= " OutPort)
  (evalfexpr (cadr L)))


(defun AssignLeftShiftOp (L)
  (evalfexpr (car L))
  (princ " <<= " OutPort)
  (evalfexpr (cadr L)))


(defun AssignModOp (L)
  (evalfexpr (car L))
  (princ " %= " OutPort)
  (evalfexpr (cadr L)))


(defun AssignMultOp (L)
  (evalfexpr (car L))
  (princ " *= " OutPort)
  (evalfexpr (cadr L)))


(defun AssignOp (L)
  (evalfexpr (car L))
  (princ " = " OutPort)
  (evalfexpr (cadr L)))


(defun AssignRightShiftOp (L)
  (evalfexpr (car L))
  (princ " >>= " OutPort)
  (evalfexpr (cadr L)))


(defun AssignSubOp (L)
  (evalfexpr (car L))
  (princ " -= " OutPort)
  (evalfexpr (cadr L)))


(defun At (L)
  (evalfexpr (car L))
  (princ "@" OutPort)
  (evalfexpr (cadr L)))


(defun Auto (L)
  (princ "auto " OutPort))


(defun BangOp (L)
  (princ "*" OutPort)
  (evalfexpr (car L)))


(defun BinAddOp (L)
  (evalfexpr (car L))
  (princ " + " OutPort)
  (evalfexpr (cadr L)))


(defun BinSubOp (L)
  (evalfexpr (car L))
  (princ " - " OutPort)
  (evalfexpr (cadr L)))


(defun BitAndOp (L)
  (evalfexpr (car L))
  (princ " & " OutPort)
  (evalfexpr (cadr L)))


(defun BitOrOp (L)
  (evalfexpr (car L))
  (princ " | " OutPort)
  (evalfexpr (cadr L)))


(defun BitXOrOp (L)
  (evalfexpr (car L))
  (princ " ^ " OutPort)
  (evalfexpr (cadr L)))


(defun Break (L)
  (princ "break;" OutPort)
  (terpri OutPort))


(defun CaseStmt (L)
  (princ "case " OutPort)
  (evalfexpr (car L))
  (princ ":" OutPort)
  (terpri OutPort)
  (evalfexpr (cadr L)))


(defun CastExp (L)
  (princ "(" OutPort)
  (evalfexpr (car L))
  (princ ")" OutPort)
  (evalfexpr (cadr L)))


(defun Char (L)
  (princ "char " OutPort))
   

(defun CompndArrayAbstDecl (L)
  (evalfexpr (car L))
  (princ "[]" OutPort))


(defun CompndArrayWSizeAbstDecl (L)
  (evalfexpr (car L))
  (princ "[" OutPort)
  (evalfexpr (cadr L))
  (princ "]" OutPort))


(defun CompndFuncAbstDecl (L)
  (evalfexpr (car L))
  (princ "(" OutPort)
  (princ ")" OutPort))


(defun CompndFuncAbstDeclWPList (L)
  (evalfexpr (car L))
  (princ "(" OutPort)
  (evalfexpr (cadr L))
  (princ ")" OutPort))


(defun CompndStmt (L)
  (princ "{" OutPort)
  (terpri OutPort)
  (princ "}" OutPort))


(defun CompndStmtWDList (L)
  (princ "{" OutPort)
  (terpri OutPort)
  (evalfexpr (car L))
  (princ "}" OutPort))


(defun CompndStmtWDListSList (L)
  (princ "{" OutPort)
  (terpri OutPort)
  (evalfexpr (car L))
  (evalfexpr (cadr L))
  (princ "}" OutPort))


(defun CompndStmtWSList (L)
  (princ "{" OutPort)
  (terpri OutPort)
  (evalfexpr (car L))
  (princ "}" OutPort))


(defun CondExp (L)
  (evalfexpr (car L))
  (princ " ? " OutPort)
  (evalfexpr (cadr L))
  (princ " : " OutPort)
  (evalfexpr (caddr L)))


(defun Const (L)
  (princ (car L) OutPort))


(defun Continue (L)
  (princ "continue" OutPort))


(defun DeclList (L)
  (evalfexpr (car L))
  (evalfexpr (cadr L)))


(defun DeclSpec (L)
  (evalfexpr (car L))
  (princ ";" OutPort)
  (terpri OutPort))


(defun DeclSpecWVars (L)
  (evalfexpr (car L))
  (evalfexpr (cadr L))
  (princ ";" OutPort)
  (terpri OutPort))


(defun DefaultStmt (L)
  (princ "default:" OutPort)
  (terpri OutPort)
  (evalfexpr (car L)))


(defun DivOp (L)
  (evalfexpr (car L))
  (princ " / " OutPort)
  (evalfexpr (cadr L)))


(defun Do (L)
  (princ "do " OutPort)
  (evalfexpr (car L))
  (princ "while (" OutPort)
  (evalfexpr (cadr L))
  (princ ");" OutPort))


(defun Double (L)
  (princ "double " OutPort))
   

(defun EnumList (L)
  (evalfexpr (car L))
  (princ ", " OutPort)
  (evalfexpr (cadr L)))


(defun EnumWEnumList (L)
  (princ "enum {" OutPort)
  (evalfexpr (car L))
  (princ "}" OutPort))


(defun EnumWId (L)
  (princ "enum " OutPort)
  (evalfexpr (car L)))


(defun EnumWIdEnumList (L)
  (princ "enum " OutPort)
  (evalfexpr (car L))
  (princ "{" OutPort)
  (evalfexpr (cadr L))
  (princ "}" OutPort))


(defun EnumWInit (L)
  (evalfexpr (car L))
  (princ " = " OutPort)
  (evalfexpr (cadr L)))


(defun EqPred (L)
  (evalfexpr (car L))
  (princ " == " OutPort)
  (evalfexpr (cadr L)))


(defun ExprList (L)
  (evalfexpr (car L))
  (princ ", " OutPort)
  (evalfexpr (cadr L)))


(defun ExprStmt (L)
  (evalfexpr (car L))
  (princ ";" OutPort)
  (terpri OutPort))


(defun Extern (L)
  (princ "extern " OutPort))


(defun FieldAcc (L)
  (evalfexpr (car L))
  (princ "->" OutPort)
  (evalfexpr (cadr L)))
   

(defun File (L)
  (evalfexpr (car L))
  (evalfexpr (cadr L)))
   

(defun Float (L)
  (princ "float " OutPort))
   

(defun For (L)
  (princ "for (;;)" OutPort)
  (evalfexpr (car L)))


(defun ForWF (L)
  (princ "for (;;" OutPort)
  (evalfexpr (car L))
  (princ ")" OutPort)
  (evalfexpr (cadr L)))


(defun ForWI (L)
  (princ "for (" OutPort)
  (evalfexpr (car L))
  (princ ";;)" OutPort)
  (evalfexpr (cadr L)))


(defun ForWIF (L)
  (princ "for (" OutPort)
  (evalfexpr (car L))
  (princ ";;" OutPort)
  (evalfexpr (cadr L))
  (princ ")" OutPort)
  (evalfexpr (caddr L)))


(defun ForWIS (L)
  (princ "for (" OutPort)
  (evalfexpr (car L))
  (princ ";" OutPort)
  (evalfexpr (cadr L))
  (princ ";)" OutPort)
  (evalfexpr (caddr L)))


(defun ForWISF (L)
  (princ "for (" OutPort)
  (evalfexpr (car L))
  (princ ";" OutPort)
  (evalfexpr (cadr L))
  (princ ";" OutPort)
  (evalfexpr (caddr L))
  (princ ")" OutPort)
  (evalfexpr (cadddr L)))


(defun ForWS (L)
  (princ "for (;" OutPort)
  (evalfexpr (car L))
  (princ ";)" OutPort)
  (evalfexpr (cadr L)))


(defun ForWSF (L)
  (princ "for (;" OutPort)
  (evalfexpr (car L))
  (princ ";" OutPort)
  (evalfexpr (cadr L))
  (princ ")" OutPort)
  (evalfexpr (caddr L)))


(defun FuncBodyWDeclList (L)
  (evalfexpr (car L))
  (evalfexpr (cadr L))) 


(defun FuncCall (L)
  (evalfexpr (car L))
  (princ "(" OutPort)
  (princ ")" OutPort))


(defun FuncCallP (L)
  (evalfexpr (car L))
  (princ "(" OutPort)
  (evalfexpr (cadr L))
  (princ ")" OutPort))


(defun FuncDefn (L) 
  (terpri OutPort)
  (terpri OutPort)
  (evalfexpr (car L))
  (evalfexpr (cadr L)))


(defun FuncDefnWDeclSpec (L)
  (terpri OutPort)
  (terpri OutPort)
  (evalfexpr (car L))
  (evalfexpr (cadr L))
  (evalfexpr (caddr L)))


(defun FuncVar (L)
  (evalfexpr (car L))
  (princ "()" OutPort)
  (terpri OutPort))
   

(defun FuncVarWPIdList (L)
  (evalfexpr (car L))
  (princ "(" OutPort)  
  (evalfexpr (cadr L))
  (princ ")" OutPort)
  (terpri OutPort))


(defun FuncVarWPTList (L)
  (evalfexpr (car L))
  (princ "(" OutPort)  
  (evalfexpr (cadr L))
  (princ ")" OutPort)
  (terpri OutPort))


(defun GEPred (L)
  (evalfexpr (car L))
  (princ " >= " OutPort)
  (evalfexpr (cadr L)))


(defun GTPred (L)
  (evalfexpr (car L))
  (princ " > " OutPort)
  (evalfexpr (cadr L)))


(defun Goto (L)
  (princ "goto " OutPort)
  (evalfexpr (car L))
  (princ "; " OutPort)
  (terpri OutPort))


(defun Id (L)
  (print (car L) OutPort))


(defun IdList (L)
  (evalfexpr (car L))
  (princ ", " OutPort)
  (evalfexpr (cadr L)))


(defun If (L)
  (princ "if (" OutPort)
  (evalfexpr (car L))
  (princ ")" OutPort)
  (terpri OutPort)
  (evalfexpr (cadr L)))


(defun IfElse (L)
  (princ "if (" OutPort)
  (evalfexpr (car L))
  (princ ")" OutPort)
  (terpri OutPort)
  (evalfexpr (cadr L))
  (princ "else " OutPort)
  (terpri OutPort)
  (evalfexpr (caddr L)))


(defun InitDecl (L)
  (evalfexpr (car L))
  (princ " = " OutPort)
  (evalfexpr (cadr L)))


(defun InitDeclList (L)
  (evalfexpr (car L))
  (princ ", " OutPort)
  (evalfexpr (cadr L)))


(defun InitList (L)
  (evalfexpr (car L))
  (princ ", " OutPort)
  (evalfexpr (cadr L)))


(defun InitListHdr (L)
  (princ "{" OutPort)
  (evalfexpr (car L))
  (princ "}" OutPort))


(defun InitListHdrWCom (L)
  (princ "{" OutPort)
  (evalfexpr (car L))
  (princ ",}" OutPort))


(defun InlineFuncDefn (L) 
  (terpri OutPort)
  (terpri OutPort)
  (cond ((equal InlineFlag 1) (princ "inline " OutPort)))
  (evalfexpr (car L))
  (evalfexpr (cadr L)))


(defun InlineFuncDefnWDeclSpec (L)
  (terpri OutPort)
  (terpri OutPort)
  (cond ((equal InlineFlag 1) (princ "inline " OutPort)))
  (evalfexpr (car L))
  (evalfexpr (cadr L))
  (evalfexpr (caddr L)))


(defun Int (L)
  (princ "int " OutPort))


(defun LEPred (L)
  (evalfexpr (car L))
  (princ " <= " OutPort)
  (evalfexpr (cadr L)))


(defun LTPred (L)
  (evalfexpr (car L))
  (princ " < " OutPort)
  (evalfexpr (cadr L)))


(defun LabeledStmt (L)
  (evalfexpr (car L))
  (princ ": " OutPort)
  (evalfexpr (cadr L)))


(defun LeftShiftOp (L)
  (evalfexpr (car L))
  (princ " << " OutPort)
  (evalfexpr (cadr L)))


(defun Long (L)
  (princ "long " OutPort))


(defun LogNot (L)
  (princ " ! " OutPort)
  (evalfexpr (car L)))


(defun ModOp (L)
  (evalfexpr (car L))
  (princ " % " OutPort)
  (evalfexpr (cadr L)))


(defun MultOp (L)
  (evalfexpr (car L))
  (princ " * " OutPort)
  (evalfexpr (cadr L)))


(defun NEPred (L)
  (evalfexpr (car L))
  (princ " != " OutPort)
  (evalfexpr (cadr L)))


(defun NullStmt (L)
  (princ ";" OutPort))


(defun OnesComp (L)
  (princ " ~ " OutPort)
  (evalfexpr (car L)))


(defun OrPred (L)
  (evalfexpr (car L))
  (princ " || " OutPort)
  (evalfexpr (cadr L)))


(defun ParamDecl (L)
  (evalfexpr (car L))
  (evalfexpr (cadr L)))


(defun ParamList (L)
  (evalfexpr (car L))
  (princ " , " OutPort)
  (evalfexpr (cadr L)))


(defun PostDec (L)
  (evalfexpr (car L))
  (princ "--" OutPort))


(defun PostInc (L)
  (evalfexpr (car L))
  (princ "++" OutPort))


(defun PreDec (L)
  (princ "--" OutPort)
  (evalfexpr (car L)))


(defun PreInc (L)
  (princ "++" OutPort)
  (evalfexpr (car L)))


(defun Preprocessor (L)
  (princ "#" OutPort)
  (princ (car L) OutPort)
  (terpri OutPort))


(defun PrimExp (L)
  (princ "(" OutPort)
  (evalfexpr (car L))
  (princ ")" OutPort))


(defun Ptr (L)
  (princ "*" OutPort))


(defun PtrPtr (L) 
  (princ "*" OutPort)
  (evalfexpr (car L)))
   

(defun PtrTSList (L) 
  (princ "*" OutPort)
  (evalfexpr (car L)))
   

(defun PtrTSListPtr (L) 
  (princ "*" OutPort)
  (evalfexpr (car L))
  (evalfexpr (cadr L)))
   

(defun PtrVar (L)
  (evalfexpr (car L))
  (evalfexpr (cadr L)))


(defun Register (L)
  (princ "register " OutPort))


(defun Return (L)
  (princ "return;" OutPort)) 


(defun ReturnWExp (L)
  (princ "return" OutPort) 
  (evalfexpr (car L))
  (princ ";" OutPort)
  (terpri OutPort))


(defun RightShiftOp (L)
  (evalfexpr (car L))
  (princ " << " OutPort)
  (evalfexpr (cadr L)))


(defun Short (L)
  (princ "short " OutPort))


(defun Signed (L)
  (princ "signed " OutPort))


(defun SimpArrayAbstDecl (L)
  (princ "[]" OutPort))


(defun SimpArrayWSizeAbst (L)
  (princ "[" OutPort)
  (evalfexpr (car L))
  (princ "]" OutPort))


(defun SimpFuncAbstDecl (L)
  (princ "()" OutPort))


(defun SimpFuncAbstDeclWPList (L)
  (princ "(" OutPort)
  (evalfexpr (car L))
  (princ ")" OutPort))


(defun SizeExpOp (L)
  (princ " sizeof " OutPort) 
  (evalfexpr (car L)))


(defun SizeTypeOp (L)
  (princ " sizeof(" OutPort) 
  (evalfexpr (car L))
  (princ ") " OutPort))


(defun Static (L)
  (princ "static " OutPort))


(defun StmtList (L)
   (evalfexpr (car L))
   (evalfexpr (cadr L)))


(defun StorDeclSpec (L)
   (evalfexpr (car L))
   (evalfexpr (cadr L)))


(defun StrLit (L)
   (print (car L) OutPort))


(defun StructDecl (L)
   (evalfexpr (car L))
   (evalfexpr (cadr L))
   (princ ";" OutPort)
   (terpri OutPort))
   

(defun StructDeclList (L)
   (evalfexpr (car L))
   (evalfexpr (cadr L)))


(defun StructFiller (L)
   (princ " : " OutPort)
   (evalfexpr (car L)))


(defun StructPacked (L)
   (evalfexpr (car L))
   (princ " : " OutPort)
   (evalfexpr (cadr L)))


(defun StructVarList (L)
   (evalfexpr (car L))
   (princ ", " OutPort)
   (evalfexpr (cadr L)))


(defun StructWDecl (L)
   (princ "struct {" OutPort)
   (evalfexpr (car L))
	(princ "} " OutPort))
   

(defun StructWId (L)
   (princ "struct " OutPort)
   (evalfexpr (car L))
	(princ " " OutPort))
   

(defun StructWIdDecl (L)
   (terpri OutPort)
   (princ "struct " OutPort)
   (evalfexpr (car L))
   (princ " { " OutPort)
   (terpri OutPort)
   (evalfexpr (cadr L))
   (princ "}" OutPort))
   

(defun Switch (L)
  (princ "switch (" OutPort)
  (evalfexpr (car L))
  (princ ")" OutPort)
  (terpri OutPort)
  (evalfexpr (cadr L)))


(defun TypeDeclSpec (L)
  (evalfexpr (car L))
  (evalfexpr (cadr L)))


(defun TypeDef (L)
  (princ "TypeDef " OutPort))


(defun TypeSpecList (L)
  (evalfexpr (car L))
  (evalfexpr (cadr L)))


(defun TypeSpecListWAbsDecl (L)
  (evalfexpr (car L))
  (evalfexpr (cadr L)))


(defun UnAddOp (L)
  (princ " + " OutPort)
  (evalfexpr (car L)))


(defun UnSubOp (L)
  (princ " - " OutPort)
  (evalfexpr (car L)))


(defun UnionWDecl (L)
  (princ "union " OutPort)
  (princ "{" OutPort)
  (evalfexpr (car L))
  (princ "}" OutPort))


(defun UnionWId (L)
  (princ "union " OutPort)
  (evalfexpr (car L)))


(defun UnionWIdDecl (L)
  (princ "union " OutPort)
  (evalfexpr (car L))
  (princ "{" OutPort)
  (evalfexpr (cadr L))
  (princ "}" OutPort))


(defun Unsigned (L)
  (princ "unsigned " OutPort))


(defun VarWParens (L)
  (princ "(" OutPort)
  (evalfexpr (car L))
  (princ ") " OutPort))


(defun Void (L)
  (princ "void " OutPort))


(defun Volatile (L)
  (princ "volatile " OutPort))
   

(defun While (L)
   (princ "while (" OutPort)
   (evalfexpr (car L))
   (princ ")" OutPort)
   (terpri OutPort)
   (evalfexpr (cadr L)))


;***********************************************************************************************************************************
;***********************************************************************************************************************************


(defun GenCode (Source OutFile)
  (setq OutPort (open OutFile
    :direction :output
    :if-does-not-exist :create
    :if-exists :supersede))
  (evalfexpr Source)
  (close OutPort))


(defun Constant (L)
  (princ (cadr L) OutPort))


(defun Comment (L)
  (terpri OutPort)
  (terpri OutPort)
  (princ "/* " OutPort)
  (princ (car L) OutPort)
  (princ " */" OutPort)
  (terpri OutPort)
  (terpri OutPort))


(defun DefineStore (L)
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


(defun EmptyStmt (L)
  (princ "" OutPort))


(defun ExternDeclSpecWVars (L)
  (princ "extern " OutPort)
  (evalfexpr (car L))
  (evalfexpr (cadr L))
  (princ ";" OutPort)
  (terpri OutPort))


(defun EvalFirstParm (L)
  (evalfexpr (car L)))
   

(defun FuncVarDecl (L)
  (evalfexpr (car L))
  (princ "()" OutPort))


(defun Preprocessor1 (L)
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
