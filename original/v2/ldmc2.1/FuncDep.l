;***********************************************************************
; Copyright (C) 1989, G. E. Weddell.
;***********************************************************************

;***************** PATH FUNCTIONAL DEPENDENCY REASONER *****************

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
; "NonKeyVars" determines which of a given set of expression variables
; are sufficiently limited by constraints imposed by selection and join
; conditions (also given) that at most one binding for each is possible
; for any database satisfying all user specified path functional
; dependencies.  The result is a list of those variables not satisfying
; this condition.  The procedure operates by first determining the relevant
; sets of terms and of concrete path function dependencies.  "Reasoning
; about functional dependencies generalized for semantic data models"
; can be used as a reference for this process, and a final construction
; process (using re-write rules) to compute a term closure.  The syntax
; of forms used in this final construction are as follows:
;
; Top Level:
;
;    ((<Term>...) (<CPFD>...) (<CPFD>...)(<ExprVar>...))
;
; Terms in the closure are remembered in the term list.  Argument vars
; are the final list.  The two concrete path function lists are the
; mechanism for path function traversal.
;
;    <Term>
;       <ExprVar>
;       (Apply <ExprVar> <PathFunction>)
;
;    <CPFD>
;       (<Term> (<Term>...))
;
;***********************************************************************

(defun NonKeyVars (Vars JoinList SelList)
   (let* ((N (+ (SumLengthDiff JoinList) (MaxTermLen JoinList SelList)))
	  (TermsAndF1 (GenTermsAndF1 N Vars))
	  (Pat `(
            ,SelList
            (,@(cadr TermsAndF1)
               ,@(GenF2 (car TermsAndF1))
               ,@(GenF3 N JoinList))
            ()
            ,Vars)))
      (ApplyRuleControl '(Call CPFDControl) Pat)
      (cadddr Pat)))

;***********************************************************************
; SumLengthDiff and MaxTermLen compute the maximum length term necessary
; for the construction.
;***********************************************************************

(defun SumLengthDiff (JoinList)
   (if (null JoinList)
      0
      (+ (abs (- (TermLength (cadar JoinList)) (TermLength (caddar JoinList))))
         (SumLengthDiff (cdr JoinList)))))

(defun MaxTermLen (JoinList SelList)
   (if (null JoinList)
      (if (null SelList)
         0
         (max (TermLength (car SelList)) (MaxTermLen () (cdr SelList))))
      (max
         (TermLength (cadar JoinList))
         (TermLength (caddar JoinList))
         (MaxTermLen (cdr JoinList) SelList))))

;***********************************************************************
; GenTermsAndF1 returns a list of two elements: a list of terms used in
; the closure computation, and the set F1 of concrete path function
; dependencies among the terms induced by the schema properties.
;***********************************************************************

(defun GenTermsAndF1 (N NewTerms)
   (prog (NewF1Log NewTerm Terms F1)
      LOOP
      (if (zerop N) (return `(,(append NewTerms Terms) ,F1)))
      (setq
         NewF1Log
            (mapcar (lambda (S) `(,S ,(ClassProps* (ExpressionType S)))) NewTerms)
         Terms (append NewTerms Terms)
         NewTerms nil)
      (do ((NewF1Log NewF1Log (cdr NewF1Log)))
            ((null NewF1Log))
         (do ((PropList (cadar NewF1Log) (cdr PropList)))
               ((null PropList))
            (setq
               NewTerm (AppendPF (caar NewF1Log) (list (car PropList)))
               NewTerms (cons NewTerm NewTerms)
               F1 (cons `(,NewTerm (,(caar NewF1Log))) F1))))
      (setq N (sub1 N))
      (go LOOP)))

;***********************************************************************
; GenF2 computes the list F2 of concrete path function dependencies
; among an argument list of terms that are induced by the abstract
; path function dependencies included in the schema.
;***********************************************************************

(defun GenF2 (TermList)
   (prog (F2 CList)
      (do ((TermList TermList (cdr TermList)))
            ((null TermList))
         (setq CList (SupClasses* (ExpressionType (car TermList))))
         (do ((CList CList (cdr CList)))
               ((null CList))
            (do ((PfdList (ClassPfds (car CList)) (cdr PfdList)))
                  ((null PfdList))
               (setq F2 (cons
                  `(,(AppendPF (car TermList) (caar PfdList))
                     ,(mapcar (lambda (PF) (AppendPF (car TermList) PF))
                        (cadar PfdList)))
                  F2)))))
      (return F2)))
               
;***********************************************************************
; GenF3 computes the list F3 of concrete path function dependencies
; induced by the join conditions of a query.  This includes subpart
; dependencies (computed by function GenSubPartDep below).
;***********************************************************************

(defun GenF3 (N JoinList)
   (prog (F3 PropList Term1 Term2)
      (do ((JoinList JoinList (cdr JoinList)))
            ((null JoinList))
         (setq
            Term1 (cadar JoinList)
            Term2 (caddar JoinList)
            F3 (append `((,Term1 (,Term2)) (,Term2 (,Term1))) F3)
            PropList nil)
         (do ((CList
               (SetUnion (SupClasses* (ExpressionType Term1)) (SupClasses* (ExpressionType Term2)))
               (cdr CList)))
               ((null CList))
            (setq PropList (SetUnion (ClassProps (car CList)) PropList)))
         (setq F3 (append
            (GenSubPartDep 
               (min (- N (TermLength Term1)) (- N (TermLength Term2)))
               Term1
               Term2
               PropList)
            F3)))
      (return F3)))

(defun GenSubPartDep (N Term1 Term2 PropList)
   (if (zerop N)
      nil
      (prog (NewSubPartDep NewTerm1 NewTerm2)
         (do ((PropList PropList (cdr PropList)))
               ((null PropList))
            (setq
               NewTerm1 (AppendPF Term1 (list (car PropList)))
               NewTerm2 (AppendPF Term2 (list (car PropList)))
               NewSubPartDep (append `(
                  (,NewTerm1 (,NewTerm2))
                  (,NewTerm2 (,NewTerm1))
                  ,@(GenSubPartDep (sub1 N) NewTerm1 NewTerm2
                     (ClassProps* (Dom (list (car PropList))))))
                  NewSubPartDep)))
         (return NewSubPartDep))))

;***********************************************************************
; Rule control and re-write rules for computing the closure of a
; given set of terms.  Pattern forms are described above.
;***********************************************************************

(LoadControl
   '(CPFDControl
      (Rep
         (If (? ? ? (+)) (Seq
            (Rep (Or NewTerm ReduceCPFD PassCPFD))
            (Or ExprVarFound ExprVarNotFound))))))

(LoadRules '(

(NewTerm
   ((> Term1 >* TermList) ((> Term2 (< Term1)) >* CPFDList1)
      > CPFDList2 > VarList)
   ((< Term1 < Term2 << TermList) < CPFDList1 < CPFDList2 < VarList))

(ReduceCPFD
   ((> Term1 >* TermList1)
      ((> Term2 (>* TermList2 < Term1 >* TermList3)) >* CPFDList1)
      > CPFDList2
      > VarList)
   ((< Term1 << TermList1)
      < CPFDList1
      ((< Term2 (<< TermList2 << TermList3)) << CPFDList2)
      < VarList))

(PassCPFD
   (> TermList1 (> CPFD >* CPFDList1) > CPFDList2 > VarList)
   (< TermList1 < CPFDList1 (< CPFD << CPFDList2) < VarList))

(ExprVarFound
   ((> Var >* TermList) () > CPFDList (>* VarList1 < Var >* VarList2))
   (< TermList < CPFDList () (<< VarList1 << VarList2)))

(ExprVarNotFound
   ((> Term >* TermList) () > CPFDList > VarList)
   (< TermList < CPFDList () < VarList))

))
