;***********************************************************************
; Copyright (C) 1989, G. E. Weddell.
;***********************************************************************

;********************* PATTERN MATCHER / BUILDER ***********************

(defvar Schema nil)
(defvar Classes nil)
(defvar BuiltInClasses nil)
(defvar Properties nil)
(defvar Queries nil)
(defvar Indices nil)
(defvar Stores nil)
(defvar Transactions nil)
(defvar QueryName? nil)
(defvar QueryOrTransName nil)
(defvar Source nil)
(defvar PDMPort nil)
(defvar DefaultRCntEst nil)
(defvar VarStack nil)
(defvar MatchVarStack nil)
(defvar FreeMatchVars nil)
(defvar MatchVar nil)

;***********************************************************************
; PushMatchVar and PopMatchVar are used to maintain MatchVarStack and
; FreeMatchVars.  The latter are used for encoding matched pattern
; variable values.  NOTE - it is important that PopMatchVar returns nil.
;***********************************************************************

(defun PushMatchVar ()
   (setq MatchVarStack (cons MatchVar MatchVarStack))
   (if (null FreeMatchVars) 
      (setq MatchVar (gensym))
   (progn  
      (setq MatchVar (car FreeMatchVars))
      (setq FreeMatchVars (cdr FreeMatchVars)))))

(defun PopMatchVar ()
   (if (null MatchVarStack) 
      (Diagnostic "Error in maintaining match var stack.")
   (progn 
      (setq FreeMatchVars (cons MatchVar FreeMatchVars))
      (setq MatchVar (car MatchVarStack))
      (setq MatchVarStack (cdr MatchVarStack))
      nil)))

(defun GetBindVal (Var) (get Var MatchVar))

(defun putprop (Var Val Ind) (setf (get Var Ind) Val))
(defun PutBindVal (Var Val) (putprop Var Val MatchVar))

;***********************************************************************
; Match attempts to match its second argument L with a pattern given
; as its first argument.  As a side effect, Bind is invoked to assign
; a value to any pattern variables that permit a match.  Note that all
; search is performed in a left-to-right top-down direction on the
; pattern.  The pattern may contain any of the following special
; symbols:
;
; ! - matches the next atom literally (special symbol escape)
; ? - matches one element
; + - matches one or more elements
; * - matches zero or more elements
; > V - binds V to the next element
; < V - matches iff the next element matches the current binding of V
; >+ V - a list of elements matched by + are bound to V
; >* V - a list of elements matched by * are bound to V
; << V - the current value of V is appended to the pattern
; <> (P1) (P2) - matches either "P1 P2" or "P2 P1"
; or EList - matches if next atom matches any member of EList
; >or EList V same as "or", but binds V to matched element
; where C - succeeds if the form C evaluates to non-null
;
; NOTES:
; 1. << corresponds to >* and >+; < corresponds to >.
; 2. Match returns nil if the match fails; otherwise t.
; 3. In the case of "where C", C is first built by a call to Build
;    (to incorporate variable bindings), and then evaluated.
;***********************************************************************

(defun Match (Pat L)
   (cond
      ((not (listp Pat)) nil)
      ((not (listp L)) nil)
      ((null Pat) (null L))
      ((listp (car Pat))
	 (and
	    (listp (car L))
	    (Match (car Pat) (car L))
	    (Match (cdr Pat) (cdr L))))
      ((eq (car Pat) '*)
         (or
            (null (cdr Pat))
            (Match (cdr Pat) L)
            (Match (cons '+ (cdr Pat)) L)))
      ((eq (car Pat) '>*)
         (cond
            ((null (cddr Pat))
               (PutBindVal (cadr Pat) (TopCopy L)) t)
            ((and (eq (caddr Pat) 'where) (null (cddddr Pat)))
               (PutBindVal (cadr Pat) (TopCopy L))
               (Match (cddr Pat) nil))
            (t
               (PutBindVal (cadr Pat) nil)
               (Match (cons '>++ (cdr Pat)) L))))
      ((eq (car Pat) '<<)
         (Match (append (GetBindVal (cadr Pat)) (cddr Pat)) L))
      ((eq (car Pat) '<)
         (Match (cons (GetBindVal (cadr Pat)) (cddr Pat)) L))
      ((eq (car Pat) '<>)
         (let ((t1 (cadr Pat)) (t2 (caddr Pat)))
            (or
               (Match (append t1 t2 (cdddr Pat)) L)
               (Match (append t2 t1 (cdddr Pat)) L))))
      ((eq (car Pat) 'where) 
         (if (eval (Build (cadr Pat))) (Match (cddr Pat) L) nil))
      ((eq (car Pat) '>++)
         (cond
            ((null L) (Match (cddr Pat) L))
            ((Match (cddr Pat) L))
            (t
               (let ((BVal (GetBindVal (cadr Pat))) (EList (list (car L))))
                  (if (null BVal)
                     (PutBindVal (cadr Pat) EList)
                     (rplacd (last BVal) EList))
                  (Match Pat (cdr L))))))
      ((null L) nil)
      ((eq (car Pat) '!)
	 (and
	    (eq (cadr Pat) (car L))
	    (Match (cddr Pat) (cdr L))))
      ((eq (car Pat) '?) (Match (cdr Pat) (cdr L)))
      ((eq (car Pat) '+)
         (or (Match (cdr Pat) (cdr L)) (Match Pat (cdr L))))
      ((eq (car Pat) '>)
         (PutBindVal (cadr Pat) (car L))
         (Match (cddr Pat) (cdr L))) 
      ((eq (car Pat) '>+)
         (PutBindVal (cadr Pat) (list (car L)))
         (Match (cons '>++ (cdr Pat)) (cdr L)))
      ((eq (car Pat) 'or)
         (if (member (car L) (cadr Pat))
            (Match (cddr Pat) (cdr L))
            nil))
      ((eq (car Pat) '>or)
         (if (member (car L) (cadr Pat))
            (progn
               (PutBindVal (caddr Pat) (car L))
               (Match (cdddr Pat) (cdr L)))
            nil))
      (t
	 (and
	    (eq (car Pat) (car L))
	    (Match (cdr Pat) (cdr L))))))

(defun TopCopy (L) (if (null L) nil (cons (car L) (TopCopy (cdr L)))))

;***********************************************************************
; Build translates an input pattern into a result form resembling the
; input pattern, but with pattern variables replaced by their bound
; values (set by a previous invocation of Match).  The special atoms
; interpreted by Build and their semantics are as follows:
;
; < V - produces the binding of V
; << V - the list-valued binding of V is spliced into the pattern
; <q V - equivalent to the pattern "(quote < V)"
; ! A - produces the value A (special character escape)
;***********************************************************************

(defun Build (P)
   (cond
      ((atom P) P)
      ((eq (car P) '<) (cons (GetBindVal (cadr P)) (Build (cddr P))))
      ((eq (car P) '<q) (cons (kwote (GetBindVal (cadr P))) (Build (cddr P))))
      ((eq (car P) '<<) (append (GetBindVal (cadr P)) (Build (cddr P))))
      ((eq (car P) '!) (cons (cadr P) (Build (cddr P))))
      (t (cons (Build (car P)) (Build (cdr P))))))

;***********************************************************************
; Bindq is invoked with the form:
;
;    (Bindq A1 F1 A2 F2 ... An Fn)
;
; It evaluates each Fi in sequence, and assigns the resulting values
; to the corresponding atom Ai.  Returns that last Fi.
;***********************************************************************

;(defun Bindq fexpr (BList)
;   (do ((BList BList (cddr BList)) (Fn nil))
;       ((null BList) Fn)
;      (PutBindVal (car BList) (setq Fn (eval (cadr BList))))))

;***********************************************************************
; Bind is equivalent to Bindq, except that it evaluates each Ai.
;***********************************************************************

;(defun Bind fexpr (BList)
;   (do ((BList BList (cddr BList)) (Fn nil))
;       ((null BList) Fn)
;      (PutBindVal (eval (car BList)) (setq Fn (eval (cadr BList))))))
