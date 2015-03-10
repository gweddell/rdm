;***********************************************************************
; Copyright (C) 1989, G. E. Weddell.
;***********************************************************************

;***************************** PASS FOUR *******************************
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
   (Block > VList >* SList1 (Assign (gApply > V (Id)) > T) >* SList2)
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
                   (SubSupDistIndices* (ExpressionType <q V))
                   (SubSupDistIndices* (ExpressionType <q T))))
      FreeList (GenFree <q T)
      AsExpr (AsGen <q T (ExpressionType <q V))))


(AssignChk
   (Block > VList >* SList1 (Assign (gApply > V (> P)) > T) >* SList2)
   (Block < VList
      << SList1
      << SubList
      (AssignChecked (gApply < V (< P)) < T)
      << AddList
      << SList2)
   (Bindq
      SubList (GenSubList <q V (SubSupIndicesOnP* (ExpressionType <q V) <q P))
      AddList (GenAddList <q V (SubSupIndicesOnP* (ExpressionType <q V) <q P))))


(IndAssignChk
   (Block > VList >* SList1 (Assign (gApply > V (>+ PF > P)) > T) >* SList2)
   (Block < VList
      << SList1
      << SubList
      (AssignChecked (gApply < V < PF) < T)
      << AddList
      << SList2)
   (Bindq
      SubList
         (GenSubList '(gApply < V < PF) (SubSupIndicesOnP* (Dom <q PF) <q P))
      AddList 
         (GenAddList '(gApply < V < PF) (SubSupIndicesOnP* (Dom <q PF) <q P))))


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
   (Block > VList >* SList1 (gDelete > TList) >* SList2)
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
            #'(lambda (S) (GenAddList S (SupIndices* (ExpressionType S))))
            <q TList)))


(Cre*Expand
   (Block > VList >* SList1 (Cre* >* TList) >* SList2)
   (Block < VList << SList1 << CreList << SList2)
   (Bindq
      CreList
         (mapcan
            #'(lambda (S) (GenCreList S (SupDistIndices* (ExpressionType S))))
            <q TList)))


(Sub*Expand
   (Block > VList >* SList1 (Sub* >* TList) >* SList2)
   (Block < VList << SList1 << SubList << SList2)
   (Bindq
      SubList
         (mapcan
            #'(lambda (S) (GenSubList S (SubSupIndices* (ExpressionType S))))
            <q TList)))


(Des*Expand
   (Block > VList >* SList1 (Des* >* TList) >* SList2)
   (Block < VList << SList1 << DesList << SList2)
   (Bindq
      DesList
         (mapcan
            #'(lambda (S) (GenDesList S (SubSupDistIndices* (ExpressionType S))))
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
   (setq CName (ExpressionType V))
   (if (member (ClassReference CName) '(IndPointer IndOffset))
      `((AllocId ,V) (IndirectAlloc ,(ClassStore CName) ,V))
      `((Alloc ,(ClassStore CName) ,V))))


(defun GenFree (S &aux StoreList FreeType)
   (setq StoreList (SubStore* (ExpressionType S)))
   (setq FreeType
      (if (member (ClassReference (ExpressionType S)) '(IndPointer IndOffset))
	 'IndirectFree
	 'Free))
   (if (null (cdr StoreList))
      `((,FreeType ,(car StoreList) ,S))
      (NestedFreeGen FreeType S (SubClasses* (ExpressionType S)))))


(defun GenFreeId (S)
   (if (member (ClassReference (ExpressionType S)) '(IndPointer IndOffset))
      `((FreeId ,S))
      nil))


(defun NestedFreeGen (FreeType S CList)
   (if (null CList)
      nil
      (if (ClassCovers (car CList))
         (NestedFreeGen FreeType S (cdr CList))
         `((If (Is ,S ,(car CList))
            (,FreeType ,(ClassStore (car CList)) ,(AsGen S (car CList)))
            ,@(NestedFreeGen FreeType S (cdr CList)))))))


(defun AsGen (S CName) 
   (if (member CName (SupClasses* (ExpressionType S))) S `(As ,S ,CName)))


(defun GenAddList (S IList)
   (mapcar
      #'(lambda (IName)
         (if (member (IndexClass IName) (SupClasses* (ExpressionType S)))
            `(Add ,IName ,S)
            `(If (In ,S ,(IndexClass IName))
               (Add ,IName ,(AsGen S (IndexClass IName))))))
      IList))


(defun GenCreList (S IList)
   (mapcar #'(lambda (IName) `(Cre ,IName ,S)) IList))


(defun GenSubList (S IList)
   (mapcar
      #'(lambda (IName)
         (if (member (IndexClass IName) (SupClasses* (ExpressionType S)))
            `(Sub ,IName ,S)
            `(If (In ,S ,(IndexClass IName))
               (Sub ,IName ,(AsGen S (IndexClass IName))))))
      IList))


(defun GenDesList (S IList)
   (mapcar
      #'(lambda (IName)
         (if (member (Dom (DistPF IName)) (SupClasses* (ExpressionType S)))
            `(Des ,IName ,S)
            `(If (In ,S ,(Dom (DistPF IName)))
               (Des ,IName ,(AsGen S (Dom (DistPF IName)))))))
      IList))


(defun GenCopyList (V S IList)
   (mapcar
      #'(lambda (IName)
         (let ((C (Dom (DistPF IName))))
            (if (member C (SupClasses* (ExpressionType V)))
               (if (member C (SupClasses* (ExpressionType S)))
                  `(Copy ,IName ,V ,S)
                  `(If (In ,S ,C) (Copy ,IName ,V ,(AsGen S C))))
               (if (member C (SupClasses* (ExpressionType S)))
                  `(If (In ,V ,C) (Copy ,IName ,(AsGen V C) ,S))
                  `(If (In ,V ,C) (If (In ,S ,C)
                     (Copy ,IName ,(AsGen V C) ,(AsGen S C))))))))
      IList))
