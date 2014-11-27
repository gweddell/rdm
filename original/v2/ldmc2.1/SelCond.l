;***********************************************************************
; Copyright (C) 1989, G. E. Weddell.
;***********************************************************************

;********************** Equational Logic Reasoner **********************

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
; A data graph is represented along with a query during join order
; selection, to reason about the case where as a logical consequence
; of some predicates, two given terms must be equal, or a given term
; is equal to some term only dependent on a given list of variable.
; Representation of a data graph:
;
;    ((Q (var.sym) (var.sym) ... (var.sym))
;     (sym (prop.sym) (prop.sym) ... (prop.sym))
;       .      .          .              .
;       .      .          .              .
;     (sym (prop.sym) (prop.sym) ... (prop.sym)))
;
; * BuildDGraph - Accepts a list of predicates and an initial data
;                 graph. Calls UnifyTerms for each equality predicate
;                 and returns the new data graph built.
;   Locate - Finds entry of Term in DGraph, or creates an entry of it
;            does not exists.  Returns symbol for Term.
;   UnifyTerms - Unify Term1 with Term2 in DGraph, and recursively
;               unify any common sons of them.
; * Consequence? - Tests if Term1 is equal to Term2 as a logical
;                  consequence in DGraph.
; * FindTermEqual - Searches for and returns a expression, which is
;                   equal to (car VarArgs) as a logical consequence in
;                   DGraph, and is dependent on (cdr VarArgs) only.
; * FindTermTypeEqual - Similar to FindTermEqual, except that Type of
;                       expression must be one of the SubClasses* of
;                       Type of TargetTerm.
;   CheapestPath - Executes BreadthFirst for each variable in
;                  SourceList = ((source_sym.var)...(source_sym.var))
;                  then selects and returns path of minimum length (> 0).
;   BreadthFirst - Searches in DGraph breadth-first, starting from
;                  Source = (source_sym.var) to Target = (target_sym.var).
;                  Returns shortest path.
;   FindBoundVList - Returns an a-list of VarArgs and its symbols in
;                    DGraphVList.
;   ReplaceAtom - Replaces all occurrences of atom FromAtom in Form by
;                 ToAtom.
; * IsVar - Returns if Term is a simple variable.
; * IsTerm - Returns if Structure is a term.
;
; ('*' denotes external functions)
; Note: Function Locate modifies DGraph, as new node is being created.
;       As a result, functions BuildDGraph, UnifyTerms, Consequence?,
;       FindTermEqual, FindTermTypeEqual all modify DGraph by calling
;       Locate.  Caution.
;
;***********************************************************************

(defun BuildDGraph (DGraph PredList)
   (do ((PredList PredList (cdr PredList))) ((null PredList))
      (if (Match
	    '(EQ > T1 where (IsTerm <q T1)
		 > T2 where (IsTerm <q T2))
	    (car PredList))
	 (UnifyTerms DGraph (GetBindVal 'T1) (GetBindVal 'T2))))
   DGraph)

(defun Locate (DGraph Term)
   (if (IsVar Term)			; case: Term variable or const
      (or
	 (cdr (assoc Term (cdar DGraph)))	;  subcase var or const existing
	 (let* ((VarSym (gensym 'T)))		;  otherwise generate new symbol
	    (rplacd (car DGraph)
	       (cons (cons Term VarSym) (cdar DGraph)))
	    (rplacd DGraph
	       (cons (cons VarSym nil) (cdr DGraph)))
	    VarSym))
    					; case: Term Apply PF
      (let* ((Prop (car (last (caddr Term))))
	     (SubTerm (assoc (Locate DGraph (RemoveLastProp Term)) DGraph)))
	 (or
	    (cdr (assoc Prop (cdr SubTerm)))	;  subcase existing
	    (let* ((TermSym (gensym 'T)))	;  otherwise generate new symbol
	       (rplacd SubTerm
		  (cons (cons Prop TermSym) (cdr SubTerm)))
	       (rplacd DGraph
		  (cons (cons TermSym nil) (cdr DGraph)))
	       TermSym)))))

(defun UnifyTerms (DGraph Term1 Term2)
   (do ((UnifyList (list (cons (Locate DGraph Term1) (Locate DGraph Term2)))
       (cdr UnifyList))) ((null UnifyList))
      (if (neq (caar UnifyList) (cdar UnifyList))
	 (let* ((FromLoc (assoc (caar UnifyList) DGraph))
		(ToLoc (assoc (cdar UnifyList) DGraph))
		(Temp))
	    (do ((PropList (cdr FromLoc)		; Merge out-edge lists
		(cdr PropList))) ((null PropList))
	       (if (setq Temp (assoc (caar PropList) (cdr ToLoc)))
		  (rplacd UnifyList		;   duplicate prop values
		     (cons			;   to be recursively unified
			(cons (cdar PropList) (cdr Temp))
			(cdr UnifyList)))
		  (rplacd ToLoc			;   insert unique prop value
		     (cons			;   into prop list
			(car PropList)
			(cdr ToLoc)))))
	    (rplacd DGraph			; Delete extra node
	       (delete FromLoc (cdr DGraph)))
	    (ReplaceAtom DGraph			; Redirect in-edges
	       (caar UnifyList) (cdar UnifyList))
	    (ReplaceAtom (cdr UnifyList)	; Replace symbol in UnifyList
	       (caar UnifyList) (cdar UnifyList))))))

(defun Consequence? (DGraph Term1 Term2)
   (let* ((Sym1 (Locate DGraph Term1))
	  (Sym2 (Locate DGraph Term2)))
      (eq Sym1 Sym2)))

(defun FindTermEqual (DGraph VarArgs)
   (let* ((TargetSym (Locate DGraph (car VarArgs)))
	  (BoundVList (FindBoundVList (cdar DGraph) (cdr VarArgs))))
      (or
	 ; Case Target = T, TermLength of T = 0
	 (do ((BVList BoundVList (cdr BVList)))
	     ((null BVList) nil)
	    (if (eq (caar BVList) TargetSym)
	       (return (cdar BVList))))

	 ; Case Target = T, TermLength of T > 0
	 (CheapestPath DGraph
	    BoundVList (cons TargetSym (car VarArgs))
	    nil nil))))

(defun FindTermTypeEqual (DGraph VarArgs)
   (let* ((TargetSubClasses (SubClasses* (Type (car VarArgs))))
	  (TargetSym (Locate DGraph (car VarArgs)))
	  (BoundVList (FindBoundVList (cdar DGraph) (cdr VarArgs))))
      (or
	 ; Case Target = T, T in TargetSubClasses, TermLength of T = 0
	 (do ((BVList BoundVList (cdr BVList)))
	     ((null BVList) nil)
	    (if (and
		  (eq (caar BVList) TargetSym)
		  (member (Type (cdar BVList)) TargetSubClasses))
	       (return (cdar BVList))))

	 ; Case Target = T, T in TargetSubClasses, TermLength of T > 0
	 (CheapestPath DGraph
	    BoundVList (cons TargetSym (car VarArgs))
	    TargetSubClasses t))))

(defun CheapestPath (DGraph SourceList Target TargetSubClasses SubClassFlag)
   (if (null SourceList)
      nil
      (let* ((CurrentP (BreadthFirst DGraph
			   (car SourceList) Target
			   TargetSubClasses SubClassFlag))
	     (BestRest (CheapestPath DGraph
			   (cdr SourceList) Target
			   TargetSubClasses SubClassFlag)))
	 (cond ((and (null BestRest) (null CurrentP)) nil)
	  ((null BestRest) CurrentP)
	  ((null CurrentP) BestRest)
	  ((lessp (TermLength CurrentP)
			(TermLength BestRest)) CurrentP)
	  (t BestRest)))))

(defun BreadthFirst (DGraph Source Target TargetSubClasses SubClassFlag)
   (let* ((NodesQueue (tconc nil Source)))
      (do ((OpenList (car NodesQueue) (cdr OpenList))
	   (PathReturn nil))
	  ((null OpenList) nil)			; no path found
	 (do ((PropList
	     (cdr (assoc (caar OpenList) DGraph))
	     (cdr PropList)))
	     ((null PropList))
	    (cond
	       ((assoc				; if son is not new, do nothing
		  (cdar PropList)
		  (car NodesQueue)))
	       ((and				; if...
		     (eq (cdar PropList) (car Target))	; ...target sym matched
		     (or
			(null SubClassFlag)	; ...no subclass constraint
			(member			; ...subclass constraint met
			   (Dom (list (caar PropList)))
			   TargetSubClasses)))
		  (setq PathReturn		; then path found
		     (AppendPF
			(cdar OpenList)
			(list (caar PropList))))
		  (return))
	       ((member				; if combined path well defined
		     (caar PropList)
		     (ClassProps* (Type (cdar OpenList))))
		  (tconc NodesQueue		; then append son to OpenList
		     (cons
			(cdar PropList)
			(AppendPF
			   (cdar OpenList)
			   (list (caar PropList))))))))
	 (if PathReturn
	    (return PathReturn)))))

(defun FindBoundVList (DGraphVList VarArgs)
   (if (null VarArgs)
      nil
      (cons
	 (cons
	    (cdr (assoc (car VarArgs) DGraphVList))
	    (car VarArgs))
	 (FindBoundVList DGraphVList (cdr VarArgs)))))

(defun ReplaceAtom (Form FromAtom ToAtom)
   (cond
      ((null (car Form)))
      ((atom (car Form))
	 (if (eq (car Form) FromAtom) (rplaca Form ToAtom)))
      (t (ReplaceAtom (car Form) FromAtom ToAtom)))
   (cond
      ((null (cdr Form)))
      ((atom (cdr Form))
	 (if (eq (cdr Form) FromAtom) (rplacd Form ToAtom)))
      (t (ReplaceAtom (cdr Form) FromAtom ToAtom)))
   Form)

(defun IsVar (Term)
   (member (car Term) '(EVar QVar PVar Constant)))

(defun IsTerm (Structure)
   (member (car Structure) '(Apply EVar QVar PVar Constant)))

