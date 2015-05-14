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

;******************************* PASS TWO ******************************
;***********************************************************************
; PassTwo compiles queries into low level ASL code suitable for final
; code generation in PassFive.  Procedure OptimizeQuery is applied to
; each query.  Compilation is accomplished in three passes:
;
; 1. normalization of the query bodies
; 2. join order selection
; 3. conjunct order selection
;
;***********************************************************************

; (sstatus nofeature TraceRules)   ; normal mode
;(sstatus feature TraceRules)     ; trace application of rewrite rules

(defun PassTwo ()
   ;(mapc 'NormalizeQuery Queries)
   ;(load 'Trace)
   ;(mapc 'JoinOrderQuery Queries)
   ;(untrace)
   ;(mapc 'AndHeapQuery Queries)
   (mapc 'OptimizeQuery Queries)
)

(defun NormalizeQuery (QName)
   (Diagnostic `(" - Normalizing query: " ,QName))
   (ApplyRuleControl
      '(Call NormalizeControl)
      (cadddr (QueryBody QName))))

(defun JoinOrderQuery (QName)
   (Diagnostic `(" - Join Order Selection: " ,QName))
   (ApplyRuleControl
      '(Seq
         PreJoinOrder
         (Call JoinOrderControl))
      (cadddr (QueryBody QName))))

(defun AndHeapQuery (QName)
   (Diagnostic `(" - Conjunction Order Selection: " ,QName))
   (ApplyRuleControl
      '(Call AndHeapControl)
      (cadddr (QueryBody QName))))

(defun OptimizeQuery (QName)
   (Diagnostic `("   query: " ,QName))
   (ApplyRuleControl
      '(Seq
         (Call NormalizeControl)
         PreJoinOrder
         (Call JoinOrderControl)
         (Call AndHeapControl))
      (cadddr (QueryBody QName)))
   (if (Match '(? ? ? (UnOptimizedQuery)) (QueryBody QName))
      (ReportWarning `(NoStrategyFound ,QName)))
   (if (Match '(? ? ? (Find ? (All ? (Sort +)) *)) (QueryBody QName))
      (ReportWarning `(SortUsed ,QName)))
   (if (Match '(? ? ? (Find ? (All (Proj +) ?) *)) (QueryBody QName))
      (ReportWarning `(ProjectionUsed ,QName))))


;******************* Normalization of Query Bodies *********************

(LoadControl
   '(NormalizeControl (Seq
      (If (gNot ?)
         (Env cadr (Call SubNormalizeControl)))
      (If (Find *)
         (Env cdaddddr (Map (Call SubNormalizeControl))))
      (Rep
         (Seq DoubleNeg NegComparison FindCombine VarIntro)))))
 

(LoadControl
   '(SubNormalizeControl (Seq
      (If (gNot ?)
         (Env cadr (Call SubNormalizeControl)))
      (If (Find *)
         (Env cdaddddr (Map (Call SubNormalizeControl))))
      (Rep
         (Seq DoubleNeg NegComparison SinglePred FindCombine VarIntro)))))
 

(LoadRules '(

(DoubleNeg
   (gNot (gNot > P))
   (<< P))

(NegComparison
   (gNot (>or (gEQ LT LE GT GE NE) Comp > T1 > T2))
   (< NewComp < T1 < T2)
   (Bindq NewComp
      (cadr (assoc <q Comp '((gEQ NE) (LT GE) (LE GT) (GT LE) (GE LT) (NE gEQ))))))

(SinglePred
   (Find ? (One) (ScanHeap) (AndHeap > P))
   (<< P))

(FindCombine
   (Find ? > Type
      (ScanHeap >* VList1)
      (AndHeap
         >* PList1
         (Find ? ? (ScanHeap >* VList2) (AndHeap >* PList2))
         >* PList3))
   (Find () < Type
      (ScanHeap << VList1 << VList2)
      (AndHeap << PList1 << PList2 << PList3)))

(VarIntro
   (Find ? > Type
      (ScanHeap >* VList1)
      (AndHeap
         >* PList1
         (gEQ <> ((gApply > V (> P >+ PF))) (> T)) where (Free <q T '(< V))
         >* PList2))
   (Find () < Type
      (ScanHeap < NewV << VList1)
      (AndHeap
         << PList1
         (gEQ (gApply < V (< P)) < NewV)
         (gEQ (gApply < NewV < PF) < T)
         << PList2))
   (Bindq NewV (NewVariable 'EVar (Dom '(< P)))))

))



;********************* Join Order Selection ****************************

;***********************************************************************
; In join order selection, an A*_search is performed on all possible
; ordering of variables.  An initialization phase is needed, followed
; by join order selection in all subqueries.  The state of the search
; is recorded as a 'AltFind' with the following arguments:
;
;   (AltFind (<Goal>...<Goal>) <CurrentGoal> n <SubGoal>...<SubGoal>)
;
; Control strategy JoinOrderControl includes:
;
;   PreJoinOrder - Initialization of parameters.
;   PreSQOptimize - Prepare each subquery for recursive application
;                   of optimization.
;   FailSQOptimize - Some of the subqueries are not optimized.
;   FindEVarProject - Find all EVar's that are not functionally
;                     dependent on the QVar's.  These may result in a
;                     need for project.
;   JoinOrderSelection - Selection of join order, selection of variable
;                        substitution or scanning strategy, recognition
;                        of independent scans, etc.
;
; Strategies guiding an A*_search for a join order.
;
;   PreAltFind - Search initialization.
;   PrepareGoal - Current goal initialized using goal with lowest cost.
;                 Subgoals are generated from the current goal.  Failure
;                 of this strategy is interpreted as search termination.
;   CreateLogicalScan - SubGoal generation by introduction of Log scan.
;   SubstituteIntroControl - Resolve logical scan by substitution or
;                            conditional substitution of variable.
;   IndexIntroControl - Resolve logical scan by some index scan.
;   NoScanPossible - Impossible to resolve logical scan.
;   MergeSubGoals - Subgoals are sorted with current goal list.
;   PostAltFind - Search is completed.
;   FailAltFind - Search ended with no result.
;
; Strategies to resolve logical scan:
;
;   SubstituteIntro - Replace logical scan by substitute.
;   CondSubstituteIntro - Replace logical scan by conditional substitute.
;   CommitSubGoal - Commit subgoal expansion of A*_search to the subgoal
;                   using a substitute or conditional substitute.
;   PreAltScan - Initializes selection of index.
;   QualPFIntro - Add QualPF selection condition.
;   QualSCIntro - Add QualSC selection condition.
;   ExpandIndexScanList - Generate subgoals from index list.
;   MergeIndexSubGoals - Subgoals generated from index list are merged.
;   PostAltScan - Rebuild proper Find statement after selection.
;   PostScanIntroControl - Optimize subgoal.
;
; Strategies to improve individual goals:
;
;   UpdateProjection - Records if a projection will be needed for any
;                      subsequent QVar.
;   ProjectionCheck - Check if projection is needed for current QVar.
;   AndHeapIntro - Introduce AndHeap after Scan.  Also remove predicates
;                  that are logical consequences of the scan or selection
;                  condition and previously verified conditions.
;   ReplaceSubstitute - Replace a Scan Substitute by an actual
;                       substitution if the substitution is by
;                       another variable or if the variable occurs no
;                       more than twice.
;   SelectCondSpecialize - Predicates independent of Scan or ScanHeap
;                          variables are moved to in front of the scan.
;   IndependentScan1 - Imbed independent scans for 'All'-typed queries.
;   IndependentScan2 - Imbed independent scans for 'One'-typed queries.
;   EstimateFindCost - Find lower bound for cost for query.
;
;***********************************************************************

(LoadControl
   '(JoinOrderControl
      (Seq
         (If (gNot ?) (Env cadr
            (Call JoinOrderControl)))
         (If (Find *) (Seq
            PreSQOptimize
            (Env cdaddddr (Map (Call JoinOrderControl)))
            (Or
               FailSQOptimize
               (Seq
                  FindEVarProject
                  (Call JoinOrderSelection))))))))

(LoadControl
   '(JoinOrderSelection
      (Seq
         PreAltFind
         (Rep (And
            PrepareGoal
            (Rep (And
               CreateLogicalScan
               (Or
                  (Call SubstituteIntroControl)
                  (Call IndexIntroControl)
                  NoScanPossible)))
            MergeSubGoals))
         (Or
            PostAltFind
            FailAltFind))))

(LoadControl
   '(SubstituteIntroControl
      (And
         (Env caddddr
            (Or
               SubstituteIntro
               CondSubstituteIntro))
         CommitSubGoal
         (Env caddddr (Call PostScanIntroControl)))))
         
(LoadControl
   '(IndexIntroControl
      (And
         (Env caddddr
            (And
               (Seq PreAltScan
                  (Env cadadr (Map
                     (Rep (Or QualPFIntro QualSCIntro)))))
               (Rep ExpandIndexScanList)
               (Env cddr (Map (And PostAltScan (Call PostScanIntroControl))))))
         MergeIndexSubGoals)))

(LoadControl
   '(PostScanIntroControl
      (Seq
         (Or UpdateProjection ProjectionCheck)
         AndHeapIntro
         (Rep ReplaceSubstitute)
         (Rep SelectCondSpecialize)
         (Rep IndependentScan1)
         (Rep IndependentScan2)
         EstimateFindCost)))


(LoadRules '(

(PreJoinOrder
   (Find ? > Type (ScanHeap >* VList) (AndHeap >* PList))
   (Find (-1 < GlobalDGraph < DGraph < BoundVars nil nil)
      < Type
      (ScanHeap << VList)
      (AndHeap << NewPList))
   (Bindq
      DGraph (copy-tree '((Q)))
      BoundVars (SelectVar <q PList '(PVar Constant)))
   (let ((PListDGraph (RemoveRedundantPred (copy-tree '((Q))) <q PList ())))
      (Bindq
         NewPList (car PListDGraph)
         GlobalDGraph (cdr PListDGraph))))

(PreSQOptimize
   (Find (? > GlobalDGraph > DGraph > BoundVars *)
      > Type
      (ScanHeap >* VList)
      (AndHeap >* PList))
   (Find (-1 < GlobalDGraph < DGraph < BoundVars nil nil)
      < Type
      (ScanHeap << VList)
      (AndHeap << UnOptimizedSQ))
   (Bindq UnOptimizedSQ
      (PrepareSQOpt <q PList <q GlobalDGraph '(<< BoundVars << VList))))

(FailSQOptimize
   (Find ? ? ? (AndHeap * (gNot (UnOptimizedQuery)) *))
   (UnOptimizedQuery))

(FindEVarProject
   (Find (? > GlobalDGraph > DGraph > BoundVars *)
      (All >* AllArgs)
      (ScanHeap >* VList)
      (AndHeap >* PList))
   (Find (-1 < GlobalDGraph < DGraph < BoundVars < EVarList nil)
      (All << AllArgs)
      (ScanHeap << VList)
      (AndHeap << PList))
   (Bindq EVarList (ProjectionRequired <q PList <q VList)))

(PreAltFind
   (Find > QInfo > Type >* FEList)
   (AltFind ((Find < QInfo < Type (AndHeap) << FEList))))

(PrepareGoal
   (AltFind
      ((Find > QInfo > Type >* FEList (ScanHeap >+ VList) > AndHeap)
       >* FList))
   (AltFind
      (<< FList)
      (Find < QInfo < Type << FEList (ScanHeap << VList) < AndHeap)
      < VCount)
   (Bindq VCount (length <q VList)))

(CreateLogicalScan
   (AltFind > GoalList
      (Find (? > GlobalDGraph > DGraph (>* BoundVars) > EVarList > Project)
         > Type
         >* FEList
         (ScanHeap > V >* VList)
         (AndHeap >* PList))
      > N where (greaterp < N 0)
      >* SubGoalList)
   (AltFind < GoalList
      (Find (-1 < GlobalDGraph < DGraph (<< BoundVars) < EVarList < Project)
         < Type
         << FEList
         (ScanHeap << VList < V)
         (AndHeap << PList))
      < NPrev
      (Find (-1 < GlobalDGraph < CopyDGraph (< V << BoundVars)
                < EVarList < Project)
         < Type
         << FEList
         (Scan < V (Log))
         (ScanHeap << VList)
         (AndHeap << PList))
      << SubGoalList)
   (Bindq
      NPrev (sub1 < N)
      CopyDGraph (copy-tree <q DGraph)))

(NoScanPossible
   (AltFind > GoalList > FindProg > N ? >* SubGoalList)
   (AltFind < GoalList < FindProg < N << SubGoalList))

(MergeSubGoals
   (AltFind (>* FList1) ? 0 >* FList2)
   (AltFind (<< FList))
   (Bindq FList
      (sort
         (copy-list '(<< FList1 << FList2))
         #'(lambda (F1 F2) (lessp (caadr F1) (caadr F2))))))

(PostAltFind
   (AltFind ((Find ? > Type >* FEList
      (AndHeap >* PList1)
      (ScanHeap)
      (AndHeap >* PList2)) *))
   (Find () < Type << FEList (AndHeap << PList1 << PList2)))

(FailAltFind
   (*)
   (UnOptimizedQuery))

(SubstituteIntro
   (Find (? > GlobalDGraph > DGraph > BoundVars > EVarList > Project)
      > Type
      >* FEList
      (Scan > V (Log))
      where (Bindq ReplaceBy (FindTermTypeEqual <q GlobalDGraph <q BoundVars))
      > ScanHeap
      > AndHeap)
   (Find (-1 < GlobalDGraph < DGraph < BoundVars < EVarList < Project)
      < Type
      << FEList
      (Scan < V (SubstituteVar < ReplaceBy))
      < ScanHeap
      < AndHeap))

(CondSubstituteIntro
   (Find (? > GlobalDGraph > DGraph > BoundVars > EVarList > Project)
      > Type
      >* FEList
      (Scan > V (Log))
      where (Bindq ReplaceBy (FindTermEqual <q GlobalDGraph <q BoundVars))
      > ScanHeap
      > AndHeap)
   (Find (-1 < GlobalDGraph < DGraph < BoundVars < EVarList < Project)
      < Type
      << FEList
      (Scan < V (CondSubstitute < ReplaceBy))
      < ScanHeap
      < AndHeap))

(CommitSubGoal
   (AltFind > GoalList > FindProg1 ? > FindProg2 >* SubGoalList)
   (AltFind < GoalList < FindProg1 0 < FindProg2))

(PreAltScan
   (Find (? > GlobalDGraph > DGraph (> V >* BoundVars) > EVarList > Project)
      > Type
      >* FEList1
      (Scan < V (Log) where (not (null (SupIndices* (ExpressionType <q V)))))
      >* FEList2)
   (AltIndex (AltScan < IndexScanList
      < DGraph < EVarList < Project < Type < FEList1 < FEList2))
   (Bindq IndexScanList
      (mapcar
         (lambda (I)                   ; function not to be compiled!
            (let* ((IterType (if (eq (ExpressionType <q V) (IndexClass I)) 'Iter 'SCIter))
                   (SearchCond (copy-tree (IndexSearchConds I))))
               (list
                  'IndexScan
                  (list 'Scan <q V (list IterType I))
                  SearchCond
                  <q GlobalDGraph
                  <q BoundVars)))
         (SupIndices* (ExpressionType <q V)))))

(QualPFIntro
   (IndexScan
      (Scan > V (> IterType > I >* SelCondList))
      ((PFCond > PF ?) >* SCList)
      > GlobalDGraph
      > BoundVars
      where (Bindq T (FindTermEqual <q GlobalDGraph
                        (cons (AppendPF <q V <q PF) <q BoundVars))))
   (IndexScan
      (Scan < V (< IterType < I << SelCondList (QualPF < PF < T)))
      < SCList
      < GlobalDGraph
      < BoundVars))

(QualSCIntro
   (IndexScan
      (Scan > V (? > I >* SelCondList))
      ((SCCond > C) >* SCList)
      > GlobalDGraph
      > BoundVars
      where (member <q C (SupClasses* (ExpressionType <q V))))
   (IndexScan
      (Scan < V (< NewIterType < I << SelCondList (QualSC < C)))
      < SCList
      < GlobalDGraph
      < BoundVars)
   (Bindq NewIterType (if (eq <q C (ExpressionType <q V)) 'Iter 'SCIter)))

(ExpandIndexScanList
   (AltIndex
      (AltScan (> IndexScan >* IndexScanList) > DGraph >* OtherDetails)
      >* SubGoalList)
   (AltIndex
      (AltScan (<< IndexScanList) < DGraph << OtherDetails)
      (AltScan < IndexScan < CopyDGraph << OtherDetails)
      << SubGoalList)
   (Bindq
      CopyDGraph (copy-tree <q DGraph)))

(MergeIndexSubGoals
   (AltFind > GoalList > Find > N
      (AltIndex ? >* IndexSubGoalList)
      >* SubGoalList)
   (AltFind < GoalList < Find < N
      << IndexSubGoalList
      << SubGoalList))

(PostAltScan
   (AltScan
      (IndexScan (Scan > V > ScanSpec) ? > GlobalDGraph > BoundVars)
      > DGraph > EVarList > Project > Type > FEList1 > FEList2)
   (Find (-1 < GlobalDGraph < DGraph (< V << BoundVars) < EVarList < Project)
      < Type
      << FEList1
      (Scan < V < ScanSpec)
      << FEList2))

(UpdateProjection
   (Find (? > GlobalDGraph > DGraph > BoundVars > EVarList (>* Project))
      (All >* AllArgs)
      >* FEList
      (Scan (EVar > V > C) > ScanSpec)
         where (member '(EVar < V < C) <q EVarList :test #'equal)
      > ScanHeap
      > AndHeap)
   (Find (-1 < GlobalDGraph < DGraph < BoundVars
             < EVarList ((EVar < V < C) << Project))
      (All << AllArgs)
      << FEList
      (Scan (EVar < V < C) < ScanSpec)
      < ScanHeap
      < AndHeap))

(ProjectionCheck
   (Find (? > GlobalDGraph > DGraph > BoundVars > EVarList > Project)
      (All (Proj >* ProjList) > OrderArg)
      >* FEList
      (Scan (QVar > V > C) > ScanSpec)
         where (and (not (null <q Project))
                    (Free <q ProjList '((QVar < V < C))))
      > ScanHeap
      > AndHeap)
   (Find (-1 < GlobalDGraph < DGraph < BoundVars < EVarList < Project)
      (All (Proj (QVar < V < C) << ProjList) < OrderArg)
      << FEList
      (Scan (QVar < V < C) < ScanSpec)
      < ScanHeap
      < AndHeap))

(AndHeapIntro
   (Find (? > GlobalDGraph > DGraph > BoundVars > EVarList > Project)
      > Type
      >* FEList
      > ScanEntry
      (ScanHeap >* VList)
      (AndHeap >* PList))
   (Find (-1 < GlobalDGraph < NewDGraph < BoundVars < EVarList < Project)
      < Type
      << FEList
      < ScanEntry
      (AndHeap << FreePreds)
      (ScanHeap << VList)
      (AndHeap << BoundPreds))
   (let*
      ((Partition (PartFreePreds <q VList <q PList))
       (PListDGraph
          (RemoveRedundantPred <q DGraph (car Partition) <q ScanEntry)))
      (Bindq
         FreePreds (car PListDGraph)
         BoundPreds (cdr Partition)
         NewDGraph (cdr PListDGraph))))

(ReplaceSubstitute
   (Find (? > GlobalDGraph > DGraph
            (>* BoundVars1 > V where (Match '(EVar ? ?) <q V) >* BoundVars2)
            > EVarList > Project)
      > Type
      >* FEList1
      (AndHeap >* PList1)
      (Scan < V (SubstituteVar > T))
      (AndHeap >* PList2)
      >* FEList2
      where (or
               (IsVar <q T)
               (lessp
                  (add
                     (CountOccurrence <q V <q FEList2)
                     (CountOccurrence <q V <q PList2))
                  2)))
   (Find (-1 < GlobalDGraph < DGraph
             (<< BoundVars1 << BoundVars2)
             < NewEVarList < NewProject)
      < Type
      << FEList1
      (AndHeap << PList1 << NewPList2)
      << NewFEList2)
   (Bindq
      NewEVarList (remove <q V <q EVarList :test #'equal)
      NewProject (remove <q V <q Project :test #'equal)
      NewPList2 (SubstituteVar <q PList2 <q V <q T)
      NewFEList2 (SubstituteVar <q FEList2 <q V <q T)))

(SelectCondSpecialize
   (Find > QInfo > Type
      >* FEList1
      (AndHeap >* PList1)
      (Scan > V > ScanSpec)
      (AndHeap >* PList2 > Pred where (Free <q Pred '(< V)) >* PList3)
      >* FEList2)
   (Find < QInfo < Type
      << FEList1
      (AndHeap < Pred << PList1)
      (Scan < V < ScanSpec)
      (AndHeap << PList2 << PList3)
      << FEList2))

(IndependentScan1
   (Find (? > GlobalDGraph > DGraph > BoundVars > EVarList > Project)
      (All >* AllArgs)
      >* FEList1
      (AndHeap >* PList)
      (Scan > V where (Match '(EVar ? ?) <q V) > ScanSpec)
      > AndHeap
      > ScanEntry where (Free <q ScanEntry '(< V))
      >* FEList2 where (Free <q FEList2 '(< V)))
   (Find (? < GlobalDGraph < DGraph < BoundVars < EVarList < NewProject)
      (All << AllArgs)
      << FEList1
      (AndHeap
         << PList
         (Find () (One) (AndHeap) (Scan < V < ScanSpec) < AndHeap))
      < ScanEntry
      << FEList2)
   (Bindq NewProject (remove <q V '(<< Project) :test #'equal)))

(IndependentScan2
   (Find > QInfo (One)
      >* FEList1
      (AndHeap >* PList)
      (Scan > V > ScanSpec)
      > AndHeap
      > ScanEntry where (not (equal <q ScanEntry '(ScanHeap)))
                  where (Free <q ScanEntry '(< V))
      >* FEList2 where (Free <q FEList2 '(< V)))
   (Find < QInfo (One)
      << FEList1
      (AndHeap
         << PList
         (Find () (One) (AndHeap) (Scan < V < ScanSpec) < AndHeap))
      < ScanEntry
      << FEList2))

(EstimateFindCost
   (Find (? >* RestQInfo) > Type >* FEList)
   (Find (< Cost << RestQInfo) < Type << FEList)
   (Bindq Cost (CostQuery '(Find () < Type << FEList))))

))


;***********************************************************************
; Return a list of all variables of the given types occurring in Form.
;***********************************************************************

(defun SelectVar (Form VTypeList)
   (cond
      ((null Form) nil)
      ((atom Form) nil)
      ((member (car Form) VTypeList)
         (list Form))
      (t (SetUnion
            (SelectVar (car Form) VTypeList)
            (SelectVar (cdr Form) VTypeList)))))


;***********************************************************************
; Preparation of Find's for sub-query optimization.
;***********************************************************************

(defun PrepareSQOpt (PredList DGraph BoundVList)
   (PushMatchVar)
   (prog1
      (PrepareSubQuery PredList DGraph BoundVList)
      (PopMatchVar)))

(defun PrepareSubQuery (PredList DGraph BoundVList)
   (cond
      ((null PredList) nil)
      ((Match
            '(gNot (Find ? ? > ScanHeap (AndHeap >* PList)))
            (car PredList))
         (Bindq
            GlobalDGraph (BuildDGraph (copy-tree DGraph) (car (Build '(< PList))))
            DGraph (copy-tree DGraph)
            BoundVars BoundVList)
         (cons
            (Build
               '(gNot (Find (-1 < GlobalDGraph < DGraph < BoundVars)
                        (One) < ScanHeap (AndHeap << PList))))
            (PrepareSubQuery (cdr PredList) DGraph BoundVList)))
      (t (cons
            (car PredList)
            (PrepareSubQuery (cdr PredList) DGraph BoundVList)))))


;***********************************************************************
; Existentially quantified variables with query variables within their
; scope for FindAll queries can imply the need for a projection
; operation.
;***********************************************************************

(defun ProjectionRequired (PredList VarList &aux JoinList SelList)
   (PushMatchVar)
   (do ((PredList PredList (cdr PredList))) ((null PredList))
      (if (or (Match
                  '(gEQ (gApply (EVar *) *) (gApply (EVar *) *))
                  (car PredList))
              (Match
                  '(gEQ <> ((gApply (EVar *) *)) ((EVar *)))
                  (car PredList))
              (Match
                  '(gEQ (EVar *) (EVar *))
                  (car PredList))) 
         (setq JoinList
            (cons (car PredList) JoinList))
       (if (Match
                  '(gEQ <> ((gApply (EVar > V > C) > PF)) (*))
                  (car PredList))
         (setq SelList
            (cons (Build '(gApply (EVar < V < C) < PF)) SelList))
       (if (Match
                  '(gEQ <> ((EVar > V > C)) (*))
                  (car PredList))
         (setq SelList
            (cons (Build '(EVar < V < C)) SelList))))))
   (PopMatchVar)
   ;#+TraceRules (untrace)
   (prog1
      (NonKeyVars (SelectVar VarList '(EVar)) JoinList SelList)
      ;#+TraceRules (load 'Trace)
   ))


;***********************************************************************
; Given ScanEntry and DGraph, finds a sublist of PredList which are
; not consequencies of DGraph and selection conditions expressed in
; ScanEntry.  Also updates DGraph.  Returns (sublist.new_dgraph).
;***********************************************************************

(defun RemoveRedundantPred (DGraph PredList ScanEntry &aux EqList NewPList)
   (PushMatchVar)
   (setq DGraph (BuildDGraph DGraph (InterpretScan ScanEntry)))
   (do ((PList PredList (cdr PList))) ((null PList))
      (if (Match
            '(gEQ > T1 where (IsTerm <q T1)
                 > T2 where (IsTerm <q T2))
            (car PList))
         (setq EqList (cons (car PList) EqList))
         (setq NewPList (cons (car PList) NewPList))))
   (do ((PList (PredCostSort EqList) (cdr PList))) ((null PList))
      (if (not (Consequence? DGraph (cadar PList) (caddar PList)))
         (progn (setq NewPList (cons (car PList) NewPList))
         (setq DGraph (BuildDGraph DGraph (list (car PList)))))))
   (PopMatchVar)
   (cons NewPList DGraph))


;***********************************************************************
; Sort PredList into ascending costs.
;***********************************************************************

(defun PredCostSort (PredList)
   (let* ((PredCostList
            (mapcar
               #'(lambda (Pred)
                  (cons (CostQuery Pred) Pred))
               PredList)))
      (mapcar 'cdr
         (sort PredCostList #'lessp :key #'car))))


;***********************************************************************
; Separate PList into two: predicates free and not free of VList.
;***********************************************************************

(defun PartFreePreds (VList PList)
   (do ((PList PList (cdr PList))
        (FreePreds nil)
        (BoundPreds nil))
       ((null PList) (cons FreePreds BoundPreds))
      (if (Free (car PList) VList)
         (setq FreePreds (cons (car PList) FreePreds))
         (setq BoundPreds (cons (car PList) BoundPreds)))))


;***********************************************************************
; Count the number of occurrence of Term in Form.
;***********************************************************************

(defun CountOccurrence (Term Form)
   (cond
      ((null Form) 0)
      ((atom Form) 0)
      ((equal Term Form) 1)
      (t (add
            (CountOccurrence Term (car Form))
            (CountOccurrence Term (cdr Form))))))

   
(defun Mincar (List)
   (cond
      ((null (cdr List)) (car List))
      ((greaterp (caar List) (caadr List))
         (Mincar (cdr List)))
      (t (Mincar (cons (car List) (cddr List))))))



;***************** Post Join Order Selection Optimization **************

(LoadControl
   '(AndHeapControl
      (Or
         (If (gNot ?) (Env cadr (Call AndHeapControl)))
         (If (Find *) (Seq
            (Env cdddr (Map
               (If (AndHeap *) (Seq
                  (Env cdr (Map (Call AndHeapControl)))
                  OrderAndHeap))))
            RemoveSort
            (Rep AndHeapDelete)
            (Rep SCIterDel)
            InsertCuts
            FindOneCuts
            (Rep LookUpIntro)
            (Rep FindExpand))))))


(LoadRules '(

(RemoveSort
   (Find ? (All (Proj) (Sort ((gApply > V > PF) > Dir)))
      > AndHeap
      (Scan < V (>or (Iter SCIter) IterType > I >* SCList))
         where (Match '(PFCond < PF < Dir)
                      (nth (length <q SCList) (IndexSearchConds <q I)))
      >* FEList)
   (Find () (All (Proj) (Sort))
      < AndHeap
      (Scan < V (< IterType < I << SCList))
      << FEList))

(OrderAndHeap
   (AndHeap >* PList)
   (AndHeap << OrderedPList)
   (Bindq OrderedPList (PredCostSort <q PList)))

(AndHeapDelete
   (Find ? > Type >* FEList1 (AndHeap >* PList) >* FEList2)
   (Find () < Type << FEList1 << PList << FEList2))

(InsertCuts
   (Find ? > Type >* FEList)
   (Find () < Type << NewFEList)
   (Bindq NewFEList (CutInsert <q FEList)))

(FindOneCuts
   (Find ? (One) >* FEList)
   (Find () (One) << FEList << CutList)
   (Bindq CutList (FindOneCutList <q FEList)))

(LookUpIntro
   (Find ? > Type >* FEList1
      (Scan > V (Iter >* ScanSpec)) (Cut < V) >* FEList2)
   (Find () < Type << FEList1
      (Scan < V (LookUp << ScanSpec)) << FEList2))

(SCLookUpIntro
   (Find ? > Type >* FEList1
      (Scan > V (SCIter >* ScanSpec)) (Cut < V) >* FEList2)
   (Find () < Type << FEList1
      (Scan < V (SCLookUp << ScanSpec)) << FEList2))

(FindExpand
   (Find ? > Type >* FEList1 (Find ? (One) >* FEList2) >* FEList3)
   (Find () < Type << FEList1 << FEList2 << FEList3))

(SCIterDel
   (Find ? > Type >* FEList1
      (Scan > V (SCIter > IName >* SelCond))
      >* FEList2)
   (Find () < Type << FEList1
      (Scan < NewV (Iter < IName << SelCond))
      (Scan < V (CondSubstitute < NewV)) << FEList2)
   (Bindq NewV (NewVariable 'EVar (IndexClass <q IName))))

(SCLookUpDel
   (Find ? > Type >* FEList1
      (Scan > V (SCLookUp > IName >* SelCond))
      >* FEList2)
   (Find () < Type << FEList1
      (Scan < NewV (LookUp < IName << SelCond))
      (Scan < V (CondSubstitute < NewV)) << FEList2)
   (Bindq NewV (NewVariable 'EVar (IndexClass <q IName))))

))


;***********************************************************************
; The following two functions perform automatic cut insertion in Find
; lists.  The PFD reasoner is called to determine one solution cases.
;***********************************************************************

(defun CutInsert (FEList)
   (PushMatchVar)
   ;#+TraceRules (untrace)
   (prog1
      (CutInsertPass FEList)
      (PopMatchVar)
      ;#+TraceRules (load 'Trace)
   ))

(defun CutInsertPass (FEList)
   (cond
      ((null FEList) nil)
      ((Match
            '(Scan > V (or (Iter SCIter) ? >* SelCondList))
            (car FEList))
         (cons
            (car FEList)
            (CutInsertCheck (QualTerms (car FEList)) (cdr FEList))))
      (t (cons
            (car FEList)
            (CutInsertPass (cdr FEList))))))

(defun CutInsertCheck (QualTerms FEList)
   (cond
      ((null (NonKeyVars (Build '(< V)) nil QualTerms))
         (cons
            (Build '(Cut < V))
            (CutInsertPass FEList)))
      ((null FEList) nil)
      ((Match
            '(Scan ? (or (Iter SCIter) *))
            (car FEList))
         (CutInsertPass FEList))
      ((Match
            '(gEQ <> ((gApply < V > PF)) (> T) where (Free <q T '(< V)))
            (car FEList))
         (cons
            (car FEList)
            (CutInsertCheck
               (cons (Build '(gApply < V < PF)) QualTerms)
               (cdr FEList))))
      (t (cons
            (car FEList)
            (CutInsertCheck QualTerms (cdr FEList))))))

(defun QualTerms (ScanEntry)
   (mapcan
      #'(lambda (Pred)
         (if (eq (car Pred) 'gEQ) (list (cadr Pred))))
      (InterpretScan ScanEntry)))

;***********************************************************************
; The following return a list of cut clauses for scanned variables.
;***********************************************************************

(defun FindOneCutList (FEList)
   (mapcar
      #'(lambda (Var)
	 `(Cut ,Var))
      (reverse (UnCutScanVariable FEList))))

(defun UnCutScanVariable (FEList)
   (SetDifference (ScanVariables FEList) (CutVariables FEList)))

(defun CutVariables (FEList)
   (if (null (car FEList))
      nil
    (if (Match '(Cut > ExprVar) (car FEList)) 
      (cons (GetBindVal 'ExprVar) (CutVariables (cdr FEList)))
      (CutVariables (cdr FEList)))))

(defun ScanVariables (FEList)
   (if (null (car FEList))
      nil
    (if (Match
	 '(Scan > ExprVar (or (LookUp SCLookUp Iter SCIter) *))
	 (car FEList))
      (cons (GetBindVal 'ExprVar) (ScanVariables (cdr FEList)))
      (ScanVariables (cdr FEList)))))

