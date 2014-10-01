;***********************************************************************
; Copyright (C) 1989, G. E. Weddell.
;***********************************************************************

;*************************** SCHEMA ACCESS *****************************

(declare
   (special DefaultQueryFreqEst)
   (special DefaultTransFreqEst))

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

;***********************************************************************
; The routines in this file non-destructively access schema information.
;***********************************************************************

(defun Valof (Constant) (readlist (exploden (cadr Constant))))

(defun ClassOf (PName) (PropType PName))

(defun SupClasses (CName) (get CName 'SupClasses))

(defun SupUserClasses (CName) (get CName 'SupUserClasses))

(defun SupClasses* (CName) (get CName 'SupClasses*))

(defun SupClasses+ (CName) (remq CName (SupClasses* CName)))

(defun SubClasses (CName) (get CName 'SubClasses))

(defun SubClasses+ (CName) (get CName 'SubClasses+))

(defun SubClasses* (CName) (cons CName (get CName 'SubClasses+)))

(defun Class? (CName) (get CName 'Class?))

(defun UserClass? (CName) (get CName 'UserClass?))

(defun ClassProps (CName) (get CName 'ClassProps))

(defun ClassUserProps (CName) (get CName 'ClassUserProps))

(defun ClassProps* (CName)
   (prog (PropList)
      (do ClassList (SupClasses* CName) (cdr ClassList)
            (null ClassList)
         (setq PropList (SetUnion (ClassProps (car ClassList)) PropList)))
      (return PropList)))

(defun ClassConstraints (CName) (get  CName 'ClassConstraints))

(defun ClassCovers (CName)
   (mapcan
      #'(lambda (E)
	 (if (eq (car E) 'Cover) (list (cadr E)) nil))
      (ClassConstraints CName)))

(defun ClassPfds (CName)
   (mapcan
      #'(lambda (E)
	 (if (eq (car E) 'Pfd) (list (cdr E)) nil))
      (ClassConstraints CName)))

(defun ClassMscVal (CName) (get CName 'ClassMscVal))

(defun ClassMscSumVal (CName) (get CName 'ClassMscSumVal))

(defun ClassReference (CName) (get CName 'ClassReference))

(defun ClassExtension (CName) (get CName 'ClassExtension))

(defun ClassIndices (CName) (get CName 'ClassIndices))

(defun ClassDistIndices (CName) (get CName 'ClassDistIndices))

(defun ClassStore (CName) (get CName 'ClassStore))

(defun Prop? (PName) (get PName 'Prop?))

(defun UserProp? (PName) (get PName 'UserProp?))

(defun Updated? (PF)
   (if (null PF) t (if (get (car PF) 'Updated?) (Updated? (cdr PF)) nil)))

(defun PropType (PName) (get PName 'PropType))

(defun PropConstraint (PName) (get PName 'PropConstraint))

(defun Query? (Q) (get Q 'Query?))

(defun QueryBody (Q) (get Q 'QueryBody))

(defun Trans? (T) (get T 'Trans?))

(defun TransBody (T) (get T 'TransBody))

(defun Index? (I) (get I 'Index?)) 

(defun IndexType (I) (get I 'IndexType)) 

(defun IndexSearchConds (I) (get I 'IndexSearchConds)) 

(defun Distributed? (I) (get I 'Distributed?))

(defun DistPF (I) (get I 'DistPF))

(defun StaticIndex? (I) (get I 'StaticIndex?))

(defun IndexSize (I) (get I 'IndexSize))

(defun IndexClass (I) (get I 'IndexClass))

(defun Store? (S) (get S 'StoreDesc))

(defun StoreClasses (S) (get S 'StoreClasses))

(defun StoreType (S) (get S 'StoreType))

(defun StoreSize (S) (get S 'StoreSize))

(defun RCntEst (C)
   (let ((Covers? (ClassCovers C)) (RCnt (get C 'RCntEst)))
      (if Covers?
         0
         (if RCnt RCnt DefaultRCntEst))))

(defun QueryFreqEst (Q)
   (let ((Freq (get Q 'QueryFreqEst)))
      (if (null Freq) DefaultQueryFreqEst Freq)))

(defun TransFreqEst (T)
   (let ((Freq (get T 'TransFreqEst)))
      (if (null Freq) DefaultTransFreqEst Freq)))


;***********************************************************************
; Additional schema access routines for computing various index name
; lists.
;***********************************************************************

(defun SupIndices* (CName)
   (mapcan
      #'(lambda (CName) (copy (ClassIndices CName)))
      (SupClasses* CName)))


;(defun SupIndicesOnP* (CName PName)
;   (mapcan
;      #'(lambda (IName)
;         (if (Match `(* (PFCond (,PName *) ?) *) (IndexSearchConds IName))
;            (list IName)
;            nil))
;      (SupIndices* CName)))


(defun SubSupClasses* (CName &aux CList)
   (setq CList (SupClasses* CName))
   (do SubCList (SubClasses+ CName) (cdr SubCList) (null SubCList)
      (setq CList (SetUnion CList (SupClasses* (car SubCList)))))
   CList)


(defun SubSupIndices* (CName)
   (mapcan
      #'(lambda (CName) (copy (ClassIndices CName)))
      (SubSupClasses* CName)))


(defun SubSupIndicesOnP* (CName PName)
   (mapcan
      #'(lambda (IName)
         (if (Match `(* (PFCond (,PName *) ?) *) (IndexSearchConds IName))
            (list IName)
            nil))
      (SubSupIndices* CName)))


(defun SupDistIndices* (CName)
   (mapcan
      #'(lambda (CName) (copy (ClassDistIndices CName)))
      (SupClasses* CName)))


(defun SubSupDistIndices* (CName)
   (mapcan
      #'(lambda (CName) (copy (ClassDistIndices CName)))
      (SubSupClasses* CName)))


(defun SubStore* (CName &aux CList SList)
   (setq SList nil)
   (do CList (SubClasses* CName) (cdr CList) (null CList)
      (if (not (memq (ClassStore (car CList)) SList))
         (setq SList (cons (ClassStore (car CList)) SList))))
   SList)
