;***********************************************************************
; Copyright (C) 1989, G. E. Weddell.
;***********************************************************************

;*********************** REWRITE RULE CONTROL  *************************

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
; ApplyRuleControl applies the rule control strategy specified as its
; first argument to its second argument form.   Control can be specified
; using the following constructs:
;
; <RuleName> - the rule called <RuleName> is applied.  Let the rule
;    be (<RuleName> <LeftHandSide> <RightHandSide> <Form>...)
;    If the given form matches with <LeftHandSide>, then
;    (1) each <Form> are built,
;    (2) each of the built forms are evaluated,
;    (3) <RightHandSide> is built, which replaces the given form.
;    However, if <RightHandSide> builds to nil, the given form
;    is not replaced by nil, but (nil) !!!
;    Returns t if rule applied, nil otherwise.
; (Call <StrategyName>) - the control strategy with the given name is
;    applied on the argument form.  Returns result of applying
;    <StrategyName>.
; (Not <Strategy>...) - <Strategy> is applied.  Returns logical negation
;    of result.
; (Or <Strategy>...) - each <Strategy> is applied in sequence, until
;    the first that successfully applies a rule.  Returns logical
;    disjunction of results.
; (And <Strategy>...) - each <Strategy> is applied in sequence,
;    until the first that fails to apply.  Returns logical conjunction
;    of results.
; (Seq <Strategy>...) - each <Strategy> is applied in sequence.  Returns
;    t if any of the <Strategy>'s is applied (i.e. logical disjuction).
; (Rep <Strategy>) - the argument <Strategy> is repetitively applied
;    until it no longer returns t.  Returns t if <Strategy> is applied
;    one or more than one time, nil if it is not applied.
; (If <Pattern> <Strategy>) - <Strategy> is applied if <Pattern>
;    matches the given form.  Returns t if <Pattern> is matched and
;    <Strategy> is applied.
; (Env c[ad]+r <Strategy>) - <Strategy> is applied on the c[ad]+r of
;    the given form.  Returns result of applying <Strategy>.
; (Map <Strategy>) - <Strategy> is applied on each element of the
;    given form.  Returns t only if <Strategy> is applied to each of
;    the elements (i.e. logical disjunction).
;***********************************************************************

(defun ApplyRuleControl (Control Form)
   (cond
      ((atom Control)
         (PushMatchVar)
         (let ((Rule (get Control 'RWRule)))
            (if (Match (car Rule) Form)
               (prog (NewForm)
                  (mapc 'eval (mapcar 'Build (cddr Rule)))
                  (setq NewForm (Build (cadr Rule)))
                  (rplaca Form (car NewForm))
                  (rplacd Form (cdr NewForm))
                  (PopMatchVar)
                  (return t))
               (PopMatchVar))))
      ((eq (car Control) 'Call)
         (ApplyRuleControl (get (cadr Control) 'RuleControl) Form))
      ((eq (car Control) 'Not)
         (not (ApplyRuleControl (cadr Control) Form)))
      ((eq (car Control) 'Or)
	 (do ((RuleList (cdr Control) (cdr RuleList)))
	     ((null RuleList) nil)
	    (if (ApplyRuleControl (car RuleList) Form) (return t))))
      ((eq (car Control) 'And)
	 (do ((RuleList (cdr Control) (cdr RuleList)))
	     ((null RuleList) t)
	    (if (not (ApplyRuleControl (car RuleList) Form)) (return nil))))
      ((eq (car Control) 'Seq)
	 (do ((RuleList (cdr Control) (cdr RuleList))
	      (Result nil))
	     ((null RuleList) Result)
	    (if (ApplyRuleControl (car RuleList) Form) (setq Result t))))
      ((eq (car Control) 'Rep)
	 (do ((Result nil t))
	     ((null (ApplyRuleControl (cadr Control) Form)) Result)))
      ((eq (car Control) 'If)
         (if (Match (cadr Control) Form)
            (ApplyRuleControl (caddr Control) Form)
            nil))
      ((eq (car Control) 'Env)
         (ApplyRuleControl (caddr Control) (funcall (cadr Control) Form)))
      ((eq (car Control) 'Map)
         (do ((FormList Form (cdr FormList))
	      (Result nil))
	     ((null FormList) Result)
	    (if (ApplyRuleControl (cadr Control) (car FormList))
	       (setq Result t))))))
         
;***********************************************************************
; LoadRules accepts a list of rules of the form:
;
; (<RuleName> <LeftHandSide> <RightHandSide> <Form>...)
;***********************************************************************

(defun LoadRules (RList)
   (mapc (function (lambda (Rule) (putprop (car Rule) (cdr Rule) 'RWRule))) RList))

;***********************************************************************
; LoadControl loads a rule control stategy for subsequent reference.
;***********************************************************************

(defun LoadControl (Control)
   (putprop (car Control) (cadr Control) 'RuleControl))
