;***********************************************************************
; Copyright (C) 1989, G. E. Weddell.
;***********************************************************************

;**************************** PASS FIVE ********************************

;(declare
;   (special Schema)
;   (special Classes)
;   (special BuiltInClasses)
;   (special Properties)
;   (special Queries)
;   (special Indices)
;   (special Stores)
;   (special Transactions)
;   (special QueryName?)
;   (special QueryOrTransName)
;   (special Source)
;   (special PDMPort)
;   (special DefaultRCntEst)
;   (special VarStack)
;   (special MatchVarStack)
;   (special FreeMatchVars)
;   (special MatchVar))

;***********************************************************************
; PassFive translates queries from low level ASL code generated from
; PassThree to readable PDM.  A LISP port is required as an argument,
; which can be allocated by using (fileopen FileName "w").
;***********************************************************************

(defun PassFive ()
   (PrintString "schema ")
   (PrintString Schema)
   (PrintLF)
   (PrintLF)
   (PrintClasses 'Entity () '**NoExtension**)
   (mapc 'PrintProperty Properties)
   (PrintLF)
   (mapc 'PrintIndex Indices)
   (mapc 'PrintStore Stores)
   (setq Queries (sort Queries 'alphalessp))
   (mapc 'PrintQuery Queries)
   (setq Transactions (sort Transactions 'alphalessp))
   (mapc 'PrintTransaction Transactions))


(defun PrintClasses (CName PNameList CExt)
   (if (UserClass? CName) then
      (PrintString "class ")
      (PrintString CName)
      (if (SupUserClasses CName) then
         (PrintString " isa ")
         (PrintIdList (SupUserClasses CName)))
      (PrintLF)
      (if (ClassUserProps CName) then
         (PrintString "properties ")
         (PrintIdList (ClassUserProps CName))
         (PrintLF))
      (PrintString "msc ")
      (PrintString (ClassMscVal CName))
      (PrintString " mscsum ")
      (PrintString (ClassMscSumVal CName))
      (PrintLF)
      (PrintString "reference ")
      (caseq (ClassReference CName)
         (Pointer (PrintString "direct"))
         (IndPointer (PrintString "indirect")))
      (PrintLF)
      (if (not (eq CExt '**NoExtension**)) then
         (PrintString "extension of ")
         (PrintString CExt)
         (PrintLF))
      (setq PNameList (append PNameList (ClassProps CName)))
      (if PNameList then
         (PrintString "fields")
         (PrintLF)
         (PrintIndent 1)
         (PrintString (car PNameList))
         (do FList (cdr PNameList) (cdr FList) (null FList)
            (PrintString ";")
            (PrintLF)
            (PrintIndent 1)
            (PrintString (car FList)))
         (PrintLF))
      (PrintLF)
      (setq PNameList ())
      (setq CExt CName)
    else
      (setq PNameList (append PNameList (ClassProps CName))))
   (do SubCList Classes (cdr SubCList) (null SubCList)
      (if (eq CName (ClassExtension (car SubCList))) then
         (PrintClasses (car SubCList) PNameList CExt))))


(defun PrintProperty (PName)
   (PrintString "property ")
   (PrintString PName)
   (PrintString " on ")
   (PrintString (PropType PName))
   (if (PropConstraint PName) then
      (caseq (car (PropConstraint PName))
         (Range
            (PrintString " range ")
            (PrintString (cadr (PropConstraint PName)))
            (PrintString " to ")
            (PrintString (caddr (PropConstraint PName))))
         (Maxlen
            (PrintString " maxlen ")
            (PrintString (cadr (PropConstraint PName))))))
   (PrintLF))


(defun PrintIndex (IName)
   (PrintString "index ")
   (PrintString IName)
   (PrintString " on ")
   (PrintString (IndexClass IName))
   (PrintLF)
   (PrintString "of type ")
   (caseq (IndexType IName)
      (List
         (PrintString "LIST"))
      (Array
         (PrintString "ARRAY")
         (PrintLF)
         (PrintString "with maximum size ")
         (PrintString (IndexSize IName))
         (PrintLF)
         (PrintString "ordered by ")
         (PrintSearchConds (IndexSearchConds IName)))
      (DistList
         (PrintString "DISTLIST")
         (PrintLF)
         (PrintString "distributed on ")
         (PrintPF (DistPF IName)))
      (DistPointer
         (PrintString "DISTPOINTER")
         (PrintLF)
         (PrintString "distributed on ")
         (PrintPF (DistPF IName)))
      (BinaryTree
         (PrintString "BINTREE")
         (PrintLF)
         (PrintString "ordered by ")
         (PrintSearchConds (IndexSearchConds IName)))
      (DistBinaryTree
         (PrintString "DISTBINTREE")
         (PrintLF)
         (PrintString "distributed on ")
         (PrintPF (DistPF IName))
         (PrintLF)
         (PrintString "ordered by ")
         (PrintSearchConds (cdr (IndexSearchConds IName)))))
   (PrintLF)
   (PrintLF))


(defun PrintSearchConds (SCList)
   (prog ()
    Loop
      (caseq (caar SCList)
         (PFCond
            (PrintPF (cadar SCList))
            (if (eq 'Asc (caddar SCList)) then
               (PrintString " asc")
             else
               (PrintString " desc")))
         (SCCond
            (PrintString (cadar SCList))))
      (setq SCList (cdr SCList))
      (if (null SCList) then (return t))
      (PrintString ", ")
      (go Loop)))


(defun PrintStore (SName &aux CList)
   (PrintString "store ")
   (PrintString SName)
   (PrintString " of type ")
   (caseq (StoreType SName)
      (Dynamic
         (PrintString "dynamic"))
      (Static
         (PrintString "static ")
         (PrintString (StoreSize SName))))
   (PrintLF)
   (PrintString "storing")
   (PrintLF)
   (setq CList (StoreClasses SName))
   (PrintIndent 1)
   (PrintString (car CList))
   (do CList (cdr CList) (cdr CList) (null CList)
      (PrintString ",")
      (PrintLF)
      (PrintIndent 1)
      (PrintString (car CList)))
   (PrintLF)
   (PrintLF))


(defun PrintQuery (QName)
   (let* ((QBody (QueryBody QName))
          (GivenVars (SelectVar (caddr QBody) '(PVar)))
          (QueryVars (SelectVar (caddr QBody) '(QVar)))
          (LocalVars (SelectVar (cdddadddr QBody) '(EVar))))
      (PrintString "query ")
      (PrintString QName)
      (PrintLF)
      (if GivenVars then
         (PrintString "given ")
         (PrintList GivenVars 'cadr)
         (if (lessp (length GivenVars) 3) then
            (PrintString " from ")
          else
            (PrintLF)
            (PrintString "from "))
            (PrintList GivenVars 'caddr)
            (PrintLF))
      (PrintString "select ")
      (if (eq (car QBody) 'OneQuery) (PrintString "one "))
      (if QueryVars then
         (PrintList QueryVars 'cadr)
         (if (lessp (length QueryVars) 3) then
            (PrintString " from ")
          else
            (PrintLF)
            (PrintString "from "))
         (PrintList QueryVars 'caddr))
      (PrintLF)
      (if LocalVars then
         (PrintString "declare ") (PrintList LocalVars 'cadr)
         (if (lessp (length LocalVars) 3) then
            (PrintString " from ")
          else
            (PrintLF)
            (PrintString "from "))
         (PrintList LocalVars 'caddr)
         (PrintLF))
      (if (eq (caadddr QBody) 'Find) then
         (PrintFindForm 0 (cadddr QBody))
       else
         (PrintString "unoptimized"))
      (PrintLF)
      (PrintLF)))


(defun PrintFindForm (Indent FindForm)
   (if (Match '(? ? (All ? (Sort >+ OrderList)) *) FindForm) then
      (PrintString "sort ")
      (PrintSortSpec (GetBindVal 'OrderList))
      (PrintLF)
      (setq Indent (add1 Indent))
      (PrintIndent Indent))
   (if (Match '(? ? (All (Proj >+ ProjList) ?) *) FindForm) then
      (PrintString "project ")
      (PrintList (GetBindVal 'ProjList) 'cadr)
      (PrintLF)
      (setq Indent (add1 Indent))
      (PrintIndent Indent))
   (if (Match '(? ? ? (Not ?)) FindForm) then
      (PrintSubForm Indent (cadddr FindForm))
      (PrintLF)
    else
      (PrintString "nest")
      (PrintLF)
      (do SubForms (cdddr FindForm) (cdr SubForms) (null SubForms)
         (PrintSubForm (add1 Indent) (car SubForms))
         (PrintString ";")
         (PrintLF))
      (PrintIndent (add1 Indent))
      (PrintString "end")))


(defun PrintSortSpec (OrderList)
   (PrintExpr (caar OrderList))
   (if (eq 'Asc (cadar OrderList)) then
      (PrintString " asc")
    else
      (PrintString " desc"))
   (do OrderList (cdr OrderList) (cdr OrderList) (null OrderList)
      (PrintString ", ")
      (PrintExpr (caar OrderList))
      (if (eq 'Asc (cadar OrderList)) then
         (PrintString " asc")
       else
         (PrintString " desc"))))


(defun PrintSubForm (Indent SubForm)
   (PrintIndent Indent)
   (if (Match
	 '(Scan > ExprVar
	    (>or (Substitute CondSubstitute) ScanType > Expr))
	 SubForm) then
      (PrintString "assign ")
      (PrintExpr (GetBindVal 'ExprVar))
      (PrintString " as ")
      (PrintExpr (GetBindVal 'Expr))
      (if (eq (GetBindVal 'ScanType) 'CondSubstitute) then
	 (PrintString " in ")
	 (PrintString (caddr (GetBindVal 'ExprVar))))

    elseif (Match
	    '(Scan > ExprVar
	       (>or (LookUp SCLookUp Iter SCIter) ScanType > IName >* SelCond))
	    SubForm) then
      (PrintString "assign ")
      (PrintExpr (GetBindVal 'ExprVar))
      (PrintString " as ")
      (if (memq (GetBindVal 'ScanType) '(LookUp SCLookUp))
	 (PrintString "first")
	 (PrintString "each"))
      (PrintString " of ")
      (PrintString (GetBindVal 'IName))
      (if (memq (GetBindVal 'ScanType) '(SCLookUp SCIter)) then
	 (PrintString " in ")
	 (PrintString (caddr (GetBindVal 'ExprVar))))
      (if (GetBindVal 'SelCond) then
	 (PrintString " where")
	 (PrintLF)
	 (PrintSelCond (add1 Indent) SubForm))

    elseif (Match '(Find *) SubForm) then
      (PrintFindForm Indent SubForm)

    elseif (Match '(Not (Find *)) SubForm) then
      (PrintString "compliment")
      (PrintLF)
      (PrintIndent (add1 Indent))
      (PrintFindForm (add1 Indent) (cadr SubForm))

    elseif (Match '(Cut > ExprVar) SubForm) then
      (PrintString "cut ")
      (PrintExpr (GetBindVal 'ExprVar))

    else
      (PrintString "verify ")
      (PrintPred SubForm)))


(defun PrintPred (Pred)
   (caseq (car Pred)
      ((EQ LT GT LE GE NE)
         (PrintExpr (cadr Pred))
         (caseq (car Pred)
	    (EQ (PrintString " = "))
            (LT (PrintString " < "))
            (GT (PrintString " > "))
            (LE (PrintString " <= "))
            (GE (PrintString " >= "))
				(NE (PrintString " <> ")))
         (PrintExpr (caddr Pred)))
      ((In Is)
         (PrintExpr (cadr Pred))
         (caseq (car Pred)
            (In (PrintString " IN "))
            (Is (PrintString " IS ")))
         (PrintString (caddr Pred)))))


(defun PrintSelCond (Indent ScanEntry)
   (let* ((Conditions (InterpretScan ScanEntry)))
      (PrintIndent Indent)
      (PrintPred (car Conditions))
      (do Cond (cdr Conditions) (cdr Cond) (null Cond)
	 (PrintString ",")
	 (PrintLF)
	 (PrintIndent Indent)
	 (PrintPred (car Cond)))))


(defun PrintExpr (Expr)
   (caseq (car Expr)
      (Constant
         (if (eq 'String (caddr Expr)) then
            (PrintStringQuoted (cadr Expr))
          else
            (PrintString (cadr Expr))))
      ((QVar PVar LVar EVar)
         (PrintString (cadr Expr)))
      (Apply
	 (PrintExpr (cadr Expr))
         (PrintString ".")
         (PrintPF (caddr Expr)))
      (UnMinusOp
	 (PrintString "(-")
	 (PrintExpr (cadr Expr))
	 (PrintString " )"))
      ((AddOp SubOp ModOp TimesOp DivOp)
	 (PrintString "(")
	 (PrintExpr (cadr Expr))
	 (PrintString
	    (cadr (assq (car Expr)
	       '((AddOp " + ")(SubOp " - ")
		 (ModOp " % ")(TimesOp " * ")(DivOp " / ")))))
	 (PrintExpr (caddr Expr))
	 (PrintString ")"))
      (As
         (PrintString "(")
         (PrintExpr (cadr Expr))
         (PrintString " AS ")
         (PrintString (caddr Expr))
         (PrintString ")"))))


(defun PrintList (VarList Func)
   (PrintString (funcall Func (car VarList)))
   (do VList (cdr VarList) (cdr VList) (null VList)
      (PrintString ", ")
      (PrintString (funcall Func (car VList)))))


(defun PrintPF (Pf)
   (PrintString (car Pf))
   (do PfRest (cdr Pf) (cdr PfRest) (null PfRest)
      (PrintString ".")
      (PrintString (car PfRest))))


(defun PrintIdList (IdList)
   (PrintString (car IdList))
   (do Rest (cdr IdList) (cdr Rest) (null Rest)
      (PrintString ", ")
      (PrintString (car Rest))))


(defun PrintIndent (Indent)
   (do I Indent (sub1 I) (zerop I) (PrintString "   ")))


(defun PrintString (String)
   (patom String PDMPort))


(defun PrintStringQuoted (String)
   (print String PDMPort))


(defun PrintLF ()
   (terpri PDMPort))


(defun PrintTransaction (TName)
   (let* ((Body (TransBody TName)))
      (PrintString "transaction ")
      (PrintString (cadr Body))
      (PrintLF)
      (if (caddr Body) then
	 (PrintString "given ")
	 (PrintList (caddr Body) 'cadr)
	 (PrintString " from ")
	 (PrintList (caddr Body) 'caddr)
	 (PrintLF))
      (if (cadadddr Body) then
	 (PrintString "declare ")
	 (PrintList (cadadddr Body) 'cadr)
	 (PrintString " from ")
	 (PrintList (cadadddr Body) 'caddr)
	 (PrintLF))
      (PrintString "actions")
      (PrintLF)
      (PrintIndent 1)
      (PrintStmt (cadddr Body) 1)
      (PrintLF)
      (if (eq (car Body) 'ExprTrans) then
	 (PrintString "return ")
	 (PrintExpr (caddddr Body))
	 (PrintLF))
      (PrintLF)))


(defun PrintStmt (Stmt Indent)
   (caseq (car Stmt)
      (Assign
	 (PrintExpr (cadr Stmt))
	 (PrintString " := ")
	 (PrintExpr (caddr Stmt)))
      (AssignId
	 (PrintExpr (cadr Stmt))
	 (PrintString " id:= ")
	 (PrintExpr (caddr Stmt)))
      ((FreeId AllocId)
	 (PrintString (cadr (assq (car Stmt)
	    '((FreeId "free id ") (AllocId "alloc id ")))))
	 (PrintExpr (cadr Stmt)))
      ((SInit IInit)
         (PrintString (cadr (assq (car Stmt)
            '((SInit "init store ") (IInit "init index ")))))
         (PrintString (cadr Stmt)))
      (Copy
         (PrintString "copy ")
         (PrintExpr (cadddr Stmt))
         (PrintString " to ")
         (PrintExpr (caddr Stmt))
         (PrintString " for ")
         (PrintString (cadr Stmt)))
      ((Add Sub Cre Des Alloc Free IndirectAlloc IndirectFree)
	 (PrintString
	    (cadr (assq (car Stmt) '(
	       (Add "insert ")
	       (Sub "remove ")
	       (Cre "create ")
	       (Des "destroy ")
	       (Alloc "allocate ")
	       (Free "free ")
	       (IndirectAlloc "allocate indirect ")
	       (IndirectFree "free indirect ")))))
	 (PrintExpr (caddr Stmt))
	 (PrintString
	    (cadr (assq (car Stmt) '(
	       (Add " in ")
	       (Sub " from ")
	       (Cre " for ")
	       (Des " for ")
	       (Alloc " from ")
	       (Free " to ")
	       (IndirectAlloc " from ")
	       (IndirectFree " to ")))))
	 (PrintString (cadr Stmt)))
      (If
	 (PrintString "if ")
	 (PrintPred (cadr Stmt))
	 (PrintString " then")
	 (PrintLF)
	 (PrintIndent (add1 Indent))
	 (PrintStmt (caddr Stmt) (add1 Indent))
	 (if (cadddr Stmt) then
	    (PrintLF)
	    (PrintIndent Indent)
	    (PrintString "else ")
	    (if (eq (caadddr Stmt) 'If) then
	       (PrintStmt (cons 'ElseIf (cdadddr Stmt)) Indent)
	     else
	       (PrintLF)
	       (PrintIndent (add1 Indent))
	       (PrintStmt (cadddr Stmt) (add1 Indent))))
	 (PrintLF)
	 (PrintIndent Indent)
	 (PrintString "endif"))
      (ElseIf
	 (PrintString "if ")
	 (PrintPred (cadr Stmt))
	 (PrintString " then")
	 (PrintLF)
	 (PrintIndent (add1 Indent))
	 (PrintStmt (caddr Stmt) (add1 Indent))
	 (if (cadddr Stmt) then
	    (PrintLF)
	    (PrintIndent Indent)
	    (PrintString "else ")
	    (if (eq (caadddr Stmt) 'If) then
	       (PrintStmt (cons 'ElseIf (cdadddr Stmt)) Indent)
	     else
	       (PrintLF)
	       (PrintIndent (add1 Indent))
	       (PrintStmt (cadddr Stmt) (add1 Indent)))))
      (Block
	 (PrintStmt (caddr Stmt) Indent)
	 (do StmtList (cdddr Stmt) (cdr StmtList) (null StmtList)
	    (PrintString ";")
	    (PrintLF)
	    (PrintIndent Indent)
	    (PrintStmt (car StmtList) Indent)))))
