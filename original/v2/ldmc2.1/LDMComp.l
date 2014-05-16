;***********************************************************************
; Copyright (C) 1989, G. E. Weddell.
;***********************************************************************

;***********************************************************************
; Declarations for the lisp compiler.
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
   (special LDMPort)
   (special DefaultRCntEst)
   (special VarStack)
   (special MatchVarStack)
   (special FreeMatchVars)
   (special MatchVar))

;***********************************************************************
; Initial load and semantic pass of LDM source.  Checks for legal
; definitions of classes and properties, and their use in transactions
; and queries.  Variables in transactions and queries are also parsed.
; The function cannot be safely reapplied.
;***********************************************************************

(defun MAIN ()
   (setq LDMPort (fileopen "ldmc.in" "r"))
   (setq Source (LDMIn LDMPort))
   (setq PDMPort (fileopen "ldmc.out" "w"))
   (InitGlobals)
   (PassOne)
   (Diagnostic "optimizing queries.")
   (PassTwo)
   (PassThree)
   (Diagnostic "compiling transactions.")
   (PassFour)
   (Diagnostic "generating code.")
   (PassFive))

;***********************************************************************
; Inputs a postfix surface parse of LDM source code, and converts to
; initial parse forms.
;***********************************************************************

(defun LDMIn (Port)
   (prog (F S)
      (setq F (read Port))
      (setq S ())
      loop
      (if (null F) (return (car S)))
      (caseq (car F)
         (0 (rplaca S (list (car S))))
         (1 (rplaca S (list (car S) (cadr S))) (rplacd S (cddr S)))
         (2 (rplaca S (list (car S) (caddr S) (cadr S)))
            (rplacd S (cdddr S)))
         (3 (rplaca S (list (car S) (cadddr S) (caddr S) (cadr S)))
            (rplacd S (cddddr S)))
         (4 (rplaca S (list (car S) (caddddr S) (cadddr S) (caddr S)
               (cadr S)))
            (rplacd S (cdddddr S)))
         (**error** (exit))
         (t (setq S (cons (car F) S))))
      (setq F (cdr F))
      (go loop)))

;***********************************************************************
; Initialize global variables. Also initializes SuperClass/SubClass
; properties for Integer/String Classes.
;***********************************************************************

(defun InitGlobals ()
   (setq Schema ())
   (setq Classes ())
   (setq Properties ())
   (setq Queries ())
   (setq Transactions ())
   (setq Indices ())
   (setq Stores ())
   (setq VarStack ())
   (setq BuiltInClasses '(String Integer Real DoubleReal))
   (setq DefaultRCntEst 100)
   (setq MatchVarStack ())
   (setq FreeMatchVars ())
   (setq MatchVar (gensym 'B)))
