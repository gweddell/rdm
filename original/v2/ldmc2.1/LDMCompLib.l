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

;************************* GENERAL ROUTINES ****************************

(defun SetUnion (L1 L2)
   (if (null L1)
      L2
      (if (member (car L1) L2)
         (SetUnion (cdr L1) L2)
         (SetUnion (cdr L1) (cons (car L1) L2)))))

(defun SetIntersection (L1 L2)
   (if (null L1)
      nil
      (if (member (car L1) L2)
         (cons (car L1) (SetIntersection (cdr L1) L2))
         (SetIntersection (cdr L1) L2))))

(defun SetDifference (L1 L2)
   (if (null L1)
      nil
      (if (member (car L1) L2)
	 (SetDifference (cdr L1) L2)
	 (cons (car L1) (SetDifference (cdr L1) L2)))))

(defun NewVariable (Type Class) `(,Type ,(gensym Class) ,Class))

(defun Dom (PF) (ClassOf (car (last PF))))

(defun Type (E &aux T1 T2)
   (caseq (car E)
      (Constant (caddr E))
      ((QVar PVar LVar EVar ReType) (ClassOf (caddr E)))
      (UnMinusOp (Type (cadr E)))
      ((TimesOp DivOp AddOp SubOp)
         (setq T1 (Type (cadr E)) T2 (Type (caddr E)))
         (caseq T1
            (Integer T2)
            (Real (if (eq T2 'Integer) T1 T2))
            (t (if (memq T2 '(Integer Real DoubleReal)) then T1 else T2))))
      (Apply
         (setq T1 (Type (cadr E)))
         (do PList (caddr E) (cdr PList) (or (null PList) (eq (car PList) 'Id))
            (setq T1 (ClassOf (car PList))))
         T1)))

(defun Free (Form VList)
   (cond
      ((null Form) t)
      ((atom Form) t)
      ((member Form VList) nil)
      ((Free (car Form) VList) (Free (cdr Form) VList))
      (t nil)))

(defun AppendPF (Term PF)
   (cond
      ((null PF) Term)
      ((equal PF '(Id)) Term)
      ((eq (car Term) 'Apply) `(Apply ,(cadr Term) (,@(caddr Term) ,@PF)))
      (t `(Apply ,Term ,PF))))

(defun RemoveLastProp (TermWithApply)
   (if (= (length (caddr TermWithApply)) 1)
      (cadr TermWithApply)
      `(Apply
	 ,(cadr TermWithApply)
	 ,(reverse (cdr (reverse (caddr TermWithApply)))))))

(defun Substitute (Form Var Term)
   (cond
      ((null Form) nil)
      ((atom Form) Form)
      ((and (eq (car Form) 'Apply) (equal (cadr Form) Var))
         (if (memq (Type Term) (SubClasses* (Type Var)))
            (AppendPF Term (caddr Form))
            Form))
      ((equal Form Var) Term)
      (t (cons (Substitute (car Form) Var Term)
            (Substitute (cdr Form) Var Term)))))

(defun ReplaceVar (Form Var NewVar)
   (cond
      ((null Form) nil)
      ((atom Form) Form)
      ((equal Form Var) NewVar)
      (t (cons (ReplaceVar (car Form) Var NewVar)
            (ReplaceVar (cdr Form) Var NewVar)))))

(defun TermLength (Term)
   (if (eq (car Term) 'Apply) (length (caddr Term)) 0))

