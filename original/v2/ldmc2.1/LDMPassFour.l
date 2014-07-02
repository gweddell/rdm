;***********************************************************************
; Copyright (C) 1989, G. E. Weddell.
;***********************************************************************

;***************************** PASS FOUR *******************************

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
; PassFour compiles transactions into PDM level code indicating index
; and store maintenance operations.
;***********************************************************************

(defun PassFour ()
   (mapc 'CompileTransaction Transactions))


(defun CompileTransaction (TName)
   (Diagnostic `("   transaction: " ,TName))
   (ApplyRuleControl
      '(Call TransCompileControl)
      (cadddr (TransBody TName))))


;*************** Rule Control for Transaction Compilation  *************

(LoadControl
   '(TransCompileControl
      (Seq
         (Rep IndAssignChk)
         (Rep AssignIdChk)
         (Rep AssignChk)
         (Rep InsertChk)
         (Rep DeleteChk)
         (Rep Add*Sub*Rem)
         (Rep Add*Expand)
         (Rep Sub*Expand)
         (Rep Cre*Expand)
         (Rep Des*Expand)
         (Rep DelAssignChecked))))


;*************** Index and Store Maintenance Check Rules ***************

(LoadRules '(

(AssignIdChk
   (Block > VList >* SList1 (Assign (Apply > V (Id)) > T) >* SList2)
   (Block < VList
      << SList1
      (Sub* < V)
      (Sub* < T)
      << CopyList
      (Des* < T)
      << FreeList
      (AssignId < T < V)
      (FreeId < V)
      (Assign < V < AsExpr)
      (Add* < V)
      << SList2)
   (Bindq
      CopyList
         (GenCopyList <q V <q T
               (SetIntersection
                   (SubSupDistIndices* (Type <q V))
                   (SubSupDistIndices* (Type <q T))))
      FreeList (GenFree <q T)
      AsExpr (AsGen <q T (Type <q V))))


(AssignChk
   (Block > VList >* SList1 (Assign (Apply > V (> P)) > T) >* SList2)
   (Block < VList
      << SList1
      << SubList
      (AssignChecked (Apply < V (< P)) < T)
      << AddList
      << SList2)
   (Bindq
      SubList (GenSubList <q V (SubSupIndicesOnP* (Type <q V) <q P))
      AddList (GenAddList <q V (SubSupIndicesOnP* (Type <q V) <q P))))


(IndAssignChk
   (Block > VList >* SList1 (Assign (Apply > V (>+ PF > P)) > T) >* SList2)
   (Block < VList
      << SList1
      << SubList
      (AssignChecked (Apply < V < PF) < T)
      << AddList
      << SList2)
   (Bindq
      SubList
         (GenSubList '(Apply < V < PF) (SubSupIndicesOnP* (Dom <q PF) <q P))
      AddList 
         (GenAddList '(Apply < V < PF) (SubSupIndicesOnP* (Dom <q PF) <q P))))


(InsertChk
   (Block > VList1 >* SList1 (Insert > VList2 >* SList2) >* SList3)
   (Block < VList1
      << SList1
      << AllocList
      << SList2
      (Cre* << VList2)
      (Add* << VList2)
      << SList3)
   (Bindq
      AllocList (mapcan 'GenAlloc <q VList2)))


(DeleteChk
   (Block > VList >* SList1 (Delete > TList) >* SList2)
   (Block
      < VList
      << SList1
      (Sub* << TList)
      (Des* << TList)
      << FreeList
      << FreeIdList
      << SList2)
   (Bindq
      FreeList (mapcan 'GenFree <q TList)
      FreeIdList (mapcan 'GenFreeId <q TList)))
   

(Add*Sub*Rem
   (Block > VList >* SList1 (Add* > T) (Sub* < T) >* SList2)
   (Block < VList << SList1 << SList2))

; will this be optimized?
;  (Block ? * (Add* > T1) (Add* > T2) (Sub* < T1) (Sub* < T2) *)
;  and so on?
 
(Add*Sub*RemAlternative
   (Block > VList >* SList1 (Add* > T)
      >* SList2 where (Add*Sub*Only <q SList2)
      (Sub* < T) >* SList3)
   (Block < VList << SList1 << SList2 << SList3))

;(defun Add*Sub*Only (SList)
;  (if (null SList) then
;     t
;   else if (memq (caar SList) '(Add* Sub*)) then
;     (Add*Sub*Only (cdr SList))
;   else
;     nil))


(Add*Expand
   (Block > VList >* SList1 (Add* >* TList) >* SList2)
   (Block < VList << SList1 << AddList << SList2)
   (Bindq
      AddList
         (mapcan
            '(lambda (T) (GenAddList T (SupIndices* (Type T))))
            <q TList)))


(Cre*Expand
   (Block > VList >* SList1 (Cre* >* TList) >* SList2)
   (Block < VList << SList1 << CreList << SList2)
   (Bindq
      CreList
         (mapcan
            '(lambda (T) (GenCreList T (SupDistIndices* (Type T))))
            <q TList)))


(Sub*Expand
   (Block > VList >* SList1 (Sub* >* TList) >* SList2)
   (Block < VList << SList1 << SubList << SList2)
   (Bindq
      SubList
         (mapcan
            '(lambda (T) (GenSubList T (SubSupIndices* (Type T))))
            <q TList)))


(Des*Expand
   (Block > VList >* SList1 (Des* >* TList) >* SList2)
   (Block < VList << SList1 << DesList << SList2)
   (Bindq
      DesList
         (mapcan
            '(lambda (T) (GenDesList T (SubSupDistIndices* (Type T))))
            <q TList)))

))

   
;***************** Repair Rule for AssignChecked **********************

(LoadRules '(

(DelAssignChecked
   (Block > VList >* SList1 (AssignChecked > T1 > T2) >* SList2)
   (Block < VList << SList1 (Assign < T1 < T2) << SList2))

))


;**********************************************************************
; Functions for generating appropriate lists of index and store
; maintenance operations.
;**********************************************************************

(defun GenAlloc (V &aux CName)
   (setq CName (Type V))
   (if (memq (ClassReference CName) '(IndPointer IndOffset))
      `((AllocId ,V) (IndirectAlloc ,(ClassStore CName) ,V))
      `((Alloc ,(ClassStore CName) ,V))))


(defun GenFree (T &aux StoreList FreeType)
   (setq StoreList (SubStore* (Type T)))
   (setq FreeType
      (if (memq (ClassReference (Type T)) '(IndPointer IndOffset))
	 'IndirectFree
	 'Free))
   (if (null (cdr StoreList))
      `((,FreeType ,(car StoreList) ,T))
      (NestedFreeGen FreeType T (SubClasses* (Type T)))))


(defun GenFreeId (T)
   (if (memq (ClassReference (Type T)) '(IndPointer IndOffset)) then
      `((FreeId ,T))
    else
      nil))


(defun NestedFreeGen (FreeType T CList)
   (if (null CList) then
      nil
    else
      (if (ClassCovers (car CList)) then
         (NestedFreeGen FreeType T (cdr CList))
       else
         `((If (Is ,T ,(car CList))
            (,FreeType ,(ClassStore (car CList)) ,(AsGen T (car CList)))
            ,@(NestedFreeGen FreeType T (cdr CList)))))))


(defun AsGen (T CName) 
   (if (memq CName (SupClasses* (Type T))) T `(As ,T ,CName)))


(defun GenAddList (T IList)
   (mapcar
      #'(lambda (IName)
         (if (memq (IndexClass IName) (SupClasses* (Type T))) then
            `(Add ,IName ,T)
          else
            `(If (In ,T ,(IndexClass IName))
               (Add ,IName ,(AsGen T (IndexClass IName))))))
      IList))


(defun GenCreList (T IList)
   (mapcar #'(lambda (IName) `(Cre ,IName ,T)) IList))


(defun GenSubList (T IList)
   (mapcar
      #'(lambda (IName)
         (if (memq (IndexClass IName) (SupClasses* (Type T))) then
            `(Sub ,IName ,T)
          else
            `(If (In ,T ,(IndexClass IName))
               (Sub ,IName ,(AsGen T (IndexClass IName))))))
      IList))


(defun GenDesList (T IList)
   (mapcar
      #'(lambda (IName)
         (if (memq (Dom (DistPF IName)) (SupClasses* (Type T))) then
            `(Des ,IName ,T)
          else
            `(If (In ,T ,(Dom (DistPF IName)))
               (Des ,IName ,(AsGen T (Dom (DistPF IName)))))))
      IList))


(defun GenCopyList (V T IList)
   (mapcar
      #'(lambda (IName)
         (let ((C (Dom (DistPF IName))))
            (if (memq C (SupClasses* (Type V))) then
               (if (memq C (SupClasses* (Type T))) then
                  `(Copy ,IName ,V ,T)
                else
                  `(If (In ,T ,C) (Copy ,IName ,V ,(AsGen T C))))
             else
               (if (memq C (SupClasses* (Type T))) then
                  `(If (In ,V ,C) (Copy ,IName ,(AsGen V C) ,T))
                else
                  `(If (In ,V ,C) (If (In ,T ,C)
                     (Copy ,IName ,(AsGen V C) ,(AsGen T C))))))))
      IList))
