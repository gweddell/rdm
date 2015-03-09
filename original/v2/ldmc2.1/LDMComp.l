;***********************************************************************
; Copyright (C) 1989, G. E. Weddell.
;***********************************************************************

;***********************************************************************
; Declarations for the lisp compiler.
;***********************************************************************

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
(defvar LDMPort nil)
(defvar DefaultRCntEst nil)
(defvar VarStack nil)
(defvar MatchVarStack nil)
(defvar FreeMatchVars nil)
(defvar MatchVar nil)

(defvar UnitSpace nil)
(defvar UnitTime nil)

;***********************************************************************
; Initial load and semantic pass of LDM source.  Checks for legal
; definitions of classes and properties, and their use in transactions
; and queries.  Variables in transactions and queries are also parsed.
; The function cannot be safely reapplied.
;***********************************************************************

(defun MAIN ()
  (setq LDMPort (open "ldmc.in"))
  (setq Source (LDMIn LDMPort))
  (close LDMPort)
  (InitGlobals)
  (PassOne)
  (Diagnostic "optimizing queries.")
  (PassTwo)
  (PassThree)
  (Diagnostic "compiling transactions.")
  (PassFour)
  (Diagnostic "generating code.")
  (setq PDMPort (open "ldmc.out"
    :direction :output
    :if-does-not-exist :create
    :if-exists :supersede))
  (PassFive)
  (close PDMPort)
)

(defun LoadSource ()
  (load "PatMatch.l")
  (load "RuleUse.l")
  (load "SelCond.l")
  (load "CostProb.l")
  (load "FuncDep.l")
  (load "LDMSchemaAccess.l")
  (load "LDMSchemaMaint.l")
  (load "LDMErrorProcs.l")
  (load "LDMCompLib.l")
  (load "LDMPassOne.l")
  (load "LDMPassTwo.l")
  (load "LDMPassThree.l")
  (load "LDMPassFour.l")
  (load "LDMPassFive.l"))

;***********************************************************************

;***********************************************************************
; Inputs a postfix surface parse of LDM source code, and converts to
; initial parse forms.
;***********************************************************************

(defun LDMIn (Port)
   (do ((F (read Port) (cdr F)) S) ((null F) (car S))
      (if (integerp (car F))
         (prog ((Index (1+ (car F)))) (rplaca S (cons (car S) (reverse (subseq S 1 Index)))) (rplacd S (subseq S Index)))
         (setq S (cons (car F) S)))))

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
   (setq MatchVar (gensym "B")))
