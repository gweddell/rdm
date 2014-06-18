;***********************************************************************
; Copyright (C) 1989, G. E. Weddell.
;***********************************************************************

(declare
   (special Schema)
   (special Classes)
   (special BuiltInClasses)
   (special Properties)
   (special Queries)
   (special Indices)
   (special Stores)
   (special Transactions)
   (special QueryName?)
   (special QueryOrTransName)
   (special Source)
   (special PDMPort)
   (special DefaultRCntEst)
   (special VarStack)
   (special MatchVarStack)
   (special FreeMatchVars)
   (special MatchVar))

;***********************************************************************
; Reports syntax and semantic errors to the standard error file.
;
; Expects a list of atoms as an argument: the first atom
; identifies the message text, the remaining atoms are
; message arguments. e.g.
;
;      (ReportError '(UndefProp <PName> query <QName>))
;
; prints:
;
;    ** error: symbol <PName> occurring in query <QName>
;              is not a property.
;
; Note: ReportError terminates execution; ReportWarning allows the
;       compiler to continue execution.
;***********************************************************************

(defun ReportError (Msg)
   (patom "** error: " errport)
   (do ((Text
      (explodec (cadr (assq (car Msg) '(
         (CyclicSchema "class schema is cyclic.")
         (UndefVar "undefined variable ? in ? ?.")
         (UndefProp "symbol ? occurring in ? ?/is not a property.")
         (UndefClass "symbol ? occurring in ? ?/is not a class.")
         (NotUserClass "symbol ? occurring in ? ?/is not a user-defined class.")
         (ClassExists "class ? multiply defined.")
         (PropExists "property ? multiply defined.")
         (QueryExists "query ? multiply defined.")
         (TransExists "transaction ? multiply defined.")
         (IndexExists "index ? multiply defined.")
         (StoreExists "store ? multiply defined.")
         (MultipleClassProp "multiply defined property ? in class ?.")
         (MultipleClassStore "multiply defined store for class ?.")
         (UndefClassStore "missing store declaration for class ?.")
         (BadStaticStore "missing subclasses in static store ?.")
         (BadPfdConstraint "bad path function in pfd constraint for class ?.")
         (BadCoverConstraint "illegal class in cover constraint for class ?.")
         (BadPfInExpr "illegal path function in ? ?.")
         (BadVarDecl "mismatched types for variable declaration in ? ?.")
         (BadVarType "undefined variable type declared in ? ?.")
         (BadCreate "creating object for covered class in transaction ?.")
         (BadArithExpr "bad form for arithmetic expression in ? ?.")
         (BadAssign "illegal assignment in transaction ?.")
         (BadIndexDistPF "illegal distributed path function for index ?.")
         (BadIndexPFSort "illegal path function sort for index ?.")
         (BadIndexSCSort "illegal subclass sort for index ?.")
         )))) (cdr Text)))
      ((null Text) (terpri errport))
      (caseq (car Text)
         (?
            (setq Msg (cdr Msg))
            (patom (car Msg) errport))
         (/
            (terpri errport)
            (patom "          " errport))
         (t
            (patom (car Text) errport))))
   (exit))


(defun Diagnostic (Msg)
   (cond
      ((null Msg)
	 (terpri errport)
	 t)
      ((atom Msg)
	 (patom Msg errport)
	 (Diagnostic nil))
      (t
	 (patom (car Msg) errport)
	 (Diagnostic (cdr Msg)))))


(defun ReportWarning (Msg)
   (patom "** warning: " errport)
   (do ((Text
      (explodec (cadr (assq (car Msg) '(
         (NoStrategyFound "no execution strategy for query ? has been found.")
         (SortUsed "a sort operation for query ? has been used.")
         (ProjectionUsed "a projection operation for query ? has been used.")
         )))) (cdr Text)))
      ((null Text) (terpri errport))
      (caseq (car Text)
         (?
            (setq Msg (cdr Msg))
            (patom (car Msg) errport))
         (/
            (terpri errport)
            (patom "          " errport))
         (t
            (patom (car Text) errport)))))
