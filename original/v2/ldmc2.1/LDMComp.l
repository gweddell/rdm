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
  (setq Source (SourceTrans Source))
  (setq PDMPort (open "ldmc.out"
    :if-does-not-exist :create
    :if-exists :supersede))
  (InitGlobals)
  (PassOne)
  ;(Diagnostic "optimizing queries.")
  ;(PassTwo)
  ;(PassThree)
  ;(Diagnostic "compiling transactions.")
  ;(PassFour)
  ;(Diagnostic "generating code.")
  ;(PassFive)
)

;*************************************************************************
;TODO: 
; 1. Debug test1.ldm in TopoSort folder, progressively remove content from
;    TopoSort
; 2. Place these functions in suitable places

(defvar TokenList '(IMPLIES OR AND NOT LE GE NE HAS MAX MIN AS ASC DESC MOD ASSIGN
                  SIZE SELECTIVITY OVERLAP FREQUENCY UNIT TIME SPACE STORE
                  STORING DYNAMIC STATIC OF TYPE ORDERED BY INDEX LIST ARRAY
                  BINARY TREE DISTRIBUTED POINTER IDENTIFIER RDMCLASS ISA
                  PROPERTIES CONSTRAINTS PROPERTY ON DETERMINED COVER QUERY
                  GIVEN FROM SELECT WHERE ORDER PRECOMPUTED ONE EXIST FOR ALL
                  TRANSACTION INTCLASS STRCLASS INTEGER REAL DOUBLEREAL STRING
                  MAXLEN RANGE TO INSERT END CHANGE DELETE DECLARE RETURN
                  SCHEMA SUBCLASS CLASSWCON CLASSWPROPS SUBCLASSWPROPS
                  SUBCLASSWCON CLASSWPROPSCON SUBCLASSWPROPSCON PROP STRINGPROP
                  INTPROP QUERY PARAMQUERY ALLBODY ALLBODYPRED ALLBODYORDER
                  ALLBODYPREDORDER ALLBODYPROJ ALLBODYPREDPROJ ALLBODYORDERPROJ
                  ALLBODYPREDORDERPROJ ONEBODYVAR ONEBODYPRED ONEBODYVARPRED
                  EXIST EXISTPRED FORALL IMPLIES EQ LT GT LE GE NE
                  HASMAX HASMIN HASMAXPRED HASMINPRED PRED ORDERASC ORDERDESC
                  ORDERASCLIST ORDERDESCLIST ADDOP SUBOP MODOP TIMESOP DIVOP
                  UNMINUSOP CONSTANT APPLY TRANS PARAMTRANS BODY BODYWLOCVARS
                  RETURNBODY RETURNBODYWLOCVARS INSERT INSERTWINITS DELETE
                  ASSIGN DEFSIZEEST DEFSELECTEST DEFOVERLAPEST DEFFREQEST
                  DEFUNITTIME DEFUNITSPACE INDEX LIST ARRAY BINARYTREE DISTLIST
                  DISTPOINTER DISTBINARYTREE SEARCHCONDLIST ASCSEARCHCOND 
                  DESCSEARCHCOND SCSEARCHCOND STORE))

(defun SourceTrans (Source)
  (if (listp Source)
     (if (member (car Source) TokenList)
       (cons (car Source) 
        (list
          (cons 'quote (list (mapcar 'SourceTrans (cdr Source))))))
          (cons (car Source) (mapcar 'SourceTrans (cdr Source))))
     Source))
          

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
