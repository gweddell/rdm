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

;***********************************************************************
; Initial load and semantic pass of LDM source.  Checks for legal
; definitions of classes and properties, and their use in transactions
; and queries.  Variables in transactions and queries are also parsed.
; The function cannot be safely reapplied.
;***********************************************************************

(defun MAIN ()
   (setq LDMPort (open "ldmc.in"))
   (setq Source (LDMIn LDMPort))
  ;(setq Source (SourceTrans Source)) 
   (setq PDMPort (open "ldmc.out"))
   (InitGlobals)
   (PassOne)
  ; (Diagnostic "optimizing queries.")
  ; (PassTwo)
  ; (PassThree)
  ; (Diagnostic "compiling transactions.")
  ; (PassFour)
  ; (Diagnostic "generating code.")
  ; (PassFive)
)

;*************************************************************************
;TODO: 
; 1. runable function, but we should come back to verify the output and further
;    debug it
; 2. Create a full list of TOKENS
; 3. Remove fexpr's in LDMPassOne.l
; 4. Place these functions in suitable places
; 5. Stay happy :)

(setq TokenList '(SCHEMA) )

(defun SourceTrans (Source)
  (if (eq nil Source)
      Source
      (progn
         (setq head (list (car Source)))
         (setq tail (map 'list' (lambda (SubSource) (SourceTrans SubSource))
                                (list (cdr Source))))
         (if (eq nil (member head TokenList)) 
           ; Id not a token
           (append head tail)
           ; Id is a token
           (append head '(tail))
         )
      )
  )
 )


;***********************************************************************

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
      (case (car F)
         (0 (rplaca S (list (car S))))
         (1 (rplaca S (list (car S) (cadr S))) (rplacd S (cddr S)))
         (2 (rplaca S (list (car S) (caddr S) (cadr S)))
            (rplacd S (cdddr S)))
         (3 (rplaca S (list (car S) (cadddr S) (caddr S) (cadr S)))
            (rplacd S (cddddr S)))
         (4 (rplaca S (list (car S) (car (cddddr S)) (cadddr S) (caddr S)
               (cadr S)))
            (rplacd S (cdr (cddddr S))))
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
   (setq MatchVar (gensym "B")))
