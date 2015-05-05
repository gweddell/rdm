;***********************************************************************
; Copyright (C) 1989, G. E. Weddell.
;
; This file is part of RDM.
;
; RDM is free software: you can redistribute it and/or modify
; it under the terms of the GNU General Public License as published by
; the Free Software Foundation, either version 3 of the License, or
; (at your option) any later version.
;
; RDM is distributed in the hope that it will be useful,
; but WITHOUT ANY WARRANTY; without even the implied warranty of
; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
; GNU General Public License for more details.
;
; You should have received a copy of the GNU General Public License
; along with RDM.  If not, see <http://www.gnu.org/licenses/>.
;
;***********************************************************************

;***********************************************************************
; Declarations for the lisp compiler.
;***********************************************************************

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
  (quit)
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
