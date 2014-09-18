;***********************************************************************
; Copyright (C) 1989, G. E. Weddell.
;***********************************************************************

;******************************* PASS TWO ******************************

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
   #+TraceRules (mapc 'NormalizeQuery Queries)
   #+TraceRules (load 'Trace)
   #+TraceRules (mapc 'JoinOrderQuery Queries)
   #+TraceRules (untrace)
   #+TraceRules (mapc 'AndHeapQuery Queries)
   #-TraceRules (mapc 'OptimizeQuery Queries)
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
   (if (Match '(? ? ? (UnOptimizedQuery)) (QueryBody QName)) then
      (ReportWarning `(NoStrategyFound ,QName)))
   (if (Match '(? ? ? (Find ? (All ? (Sort +)) *)) (QueryBody QName)) then
      (ReportWarning `(SortUsed ,QName)))
   (if (Match '(? ? ? (Find ? (All (Proj +) ?) *)) (QueryBody QName)) then
      (ReportWarning `(ProjectionUsed ,QName))))


;******************* Normalization of Query Bodies *********************

(LoadControl
   '(NormalizeControl (Seq
      (If (Not ?)
         (Env cadr (Call SubNormalizeControl)))
      (If (Find *)
         (Env cdaddddr (Map (Call SubNormalizeControl))))
      (Rep
         (Seq DoubleNeg NegComparison FindCombine VarIntro)))))
 

(LoadControl
   '(SubNormalizeControl (Seq
      (If (Not ?)
         (Env cadr (Call SubNormalizeControl)))
      (If (Find *)
         (Env cdaddddr (Map (Call SubNormalizeControl))))
      (Rep
         (Seq DoubleNeg NegComparison SinglePred FindCombine VarIntro)))))
 

(LoadRules '(

(DoubleNeg
   (Not (Not > P))
   (<< P))

(NegComparison
   (Not (>or (EQ LT LE GT GE NE) Comp > T1 > T2))
   (< NewComp < T1 < T2)
   (Bindq NewComp
      (cadr (assq <q Comp '((EQ NE) (LT GE) (LE GT) (GT LE) (GE LT) (NE EQ))))))

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
         (EQ <> ((Apply > V (> P >+ PF))) (> T)) where (Free <q T '(< V))
         >* PList2))
   (Find () < Type
      (ScanHeap < NewV << VList1)
      (AndHeap
         << PList1
         (EQ (Apply < V (< P)) < NewV)
         (EQ (Apply < NewV < PF) < T)
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
;   FindMinCostI - Selection index and selection condition with which
;                  the least cost is incurred.
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
         (If (Not ?) (Env cadr
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
       (Env caddddr
          (And
             PreAltScan
             (Seq
                (Env cadr (Map
                   (Rep (Or QualPFIntro QualSCIntro))))
                FindMinCostI)
             PostAltScan
             (Call PostScanIntroControl)))))

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
      DGraph (copy '((Q)))
      BoundVars (SelectVar <q PList '(PVar Constant)))
   (let ((PListDGraph (RemoveRedundantPred (copy '((Q))) <q PList ())))
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
   (Find ? ? ? (AndHeap * (Not (UnOptimizedQuery)) *))
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
      CopyDGraph (copy <q DGraph)))

(NoScanPossible
   (AltFind > GoalList > FindProg > N ? >* SubGoalList)
   (AltFind < GoalList < FindProg < N << SubGoalList))

(MergeSubGoals
   (AltFind (>* FList1) ? 0 >* FList2)
   (AltFind (<< FList))
   (Bindq FList
      (sort
         '(<< FList1 << FList2)
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
      (Scan < V (Substitute < ReplaceBy))
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
      (Scan < V (Log) where (not (null (SupIndices* (Type <q V)))))
      >* FEList2)
   (AltScan < IndexScanList
      < DGraph < EVarList < Project < Type < FEList1 < FEList2)
   (Bindq IndexScanList
      (mapcar
         '(lambda (I)                   ; function not to be compiled!
            (let* ((IterType (if (eq (Type <q V) (IndexClass I)) 'Iter 'SCIter))
                   (SearchCond (copy (IndexSearchConds I))))
               (list
                  'IndexScan
                  (list 'Scan <q V (list IterType I))
                  SearchCond
                  <q GlobalDGraph
                  <q BoundVars)))
         (SupIndices* (Type <q V)))))

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
      where (memq <q C (SupClasses* (Type <q V))))
   (IndexScan
      (Scan < V (< NewIterType < I << SelCondList (QualSC < C)))
      < SCList
      < GlobalDGraph
      < BoundVars)
   (Bindq NewIterType (if (eq <q C (Type <q V)) 'Iter 'SCIter)))

(FindMinCostI
   (AltScan (>+ IndexScanList) >* OtherDetails)
   (AltScan < BestIndexScan << OtherDetails)
   (Bindq BestIndexScan (FindMinCost <q IndexScanList)))

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
         where (member '(EVar < V < C) <q EVarList)
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
      (Scan < V (Substitute > T))
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
      NewEVarList (remove <q V <q EVarList)
      NewProject (remove <q V <q Project)
      NewPList2 (Substitute <q PList2 <q V <q T)
      NewFEList2 (Substitute <q FEList2 <q V <q T)))

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
   (Bindq NewProject (remove <q V '(<< Project))))

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
      ((memq (car Form) VTypeList)
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
            '(Not (Find ? ? > ScanHeap (AndHeap >* PList)))
            (car PredList))
         (Bindq
            GlobalDGraph (BuildDGraph (copy DGraph) (car (Build '(< PList))))
            DGraph (copy DGraph)
            BoundVars BoundVList)
         (cons
            (Build
               '(Not (Find (-1 < GlobalDGraph < DGraph < BoundVars)
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
   (do PredList PredList (cdr PredList) (null PredList)
      (if (or (Match
                  '(EQ (Apply (EVar *) *) (Apply (EVar *) *))
                  (car PredList))
              (Match
                  '(EQ <> ((Apply (EVar *) *)) ((EVar *)))
                  (car PredList))
              (Match
                  '(EQ (EVar *) (EVar *))
                  (car PredList))) then
         (setq JoinList
            (cons (car PredList) JoinList))
       elseif (Match
                  '(EQ <> ((Apply (EVar > V > C) > PF)) (*))
                  (car PredList)) then
         (setq SelList
            (cons (Build '(Apply (EVar < V < C) < PF)) SelList))
       elseif (Match
                  '(EQ <> ((EVar > V > C)) (*))
                  (car PredList)) then
         (setq SelList
            (cons (Build '(EVar < V < C)) SelList))))
   (PopMatchVar)
   #+TraceRules (untrace)
   (prog1
      (NonKeyVars (SelectVar VarList '(EVar)) JoinList SelList)
      #+TraceRules (load 'Trace)
   ))


;***********************************************************************
; Given ScanEntry and DGraph, finds a sublist of PredList which are
; not consequencies of DGraph and selection conditions expressed in
; ScanEntry.  Also updates DGraph.  Returns (sublist.new_dgraph).
;***********************************************************************

(defun RemoveRedundantPred (DGraph PredList ScanEntry &aux EqList NewPList)
   (PushMatchVar)
   (setq DGraph (BuildDGraph DGraph (InterpretScan ScanEntry)))
   (do PList PredList (cdr PList) (null PList)
      (if (Match
            '(EQ > T1 where (IsTerm <q T1)
                 > T2 where (IsTerm <q T2))
            (car PList))
         (setq EqList (cons (car PList) EqList))
         (setq NewPList (cons (car PList) NewPList))))
   (do PList (PredCostSort EqList) (cdr PList) (null PList)
      (if (not (Consequence? DGraph (cadar PList) (caddar PList))) then
         (setq NewPList (cons (car PList) NewPList))
         (setq DGraph (BuildDGraph DGraph (list (car PList))))))
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
         (sortcar PredCostList 'lessp))))


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

   
;***********************************************************************
; Finding the index to scan a variable incurring minimal cost.
; Format of IndexStruct:
;  (IndexScan <ScanEntry> <SCList> <GlobalDGraph> <BoundVars>)
;***********************************************************************

(defun FindMinCost (IndexStList)
   (if (null IndexStList)
      nil
      (cdr (Mincar (mapcar
         #'(lambda (IndexStruct)
            (cons
               (CostQuery
                  `(Find () (All) ,(cadr IndexStruct)))
               IndexStruct))
         IndexStList)))))

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
         (If (Not ?) (Env cadr (Call AndHeapControl)))
         (If (Find *) (Seq
            (Env cdddr (Map
               (If (AndHeap *) (Seq
                  (Env cdr (Map (Call AndHeapControl)))
                  OrderAndHeap))))
            RemoveSort
            (Rep AndHeapDelete)
            InsertCuts
            FindOneCuts
            (Rep LookUpIntro)
            (Rep SCLookUpIntro)
            (Rep FindExpand)
            (Rep SCIterDel)
            (Rep SCLookUpDel))))))


(LoadRules '(

(RemoveSort
   (Find ? (All (Proj) (Sort ((Apply > V > PF) > Dir)))
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
   #+TraceRules (untrace)
   (prog1
      (CutInsertPass FEList)
      (PopMatchVar)
      #+TraceRules (load 'Trace)
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
            '(EQ <> ((Apply < V > PF)) (> T) where (Free <q T '(< V)))
            (car FEList))
         (cons
            (car FEList)
            (CutInsertCheck
               (cons (Build '(Apply < V < PF)) QualTerms)
               (cdr FEList))))
      (t (cons
            (car FEList)
            (CutInsertCheck QualTerms (cdr FEList))))))

(defun QualTerms (ScanEntry)
   (mapcan
      #'(lambda (Pred)
         (if (eq (car Pred) 'EQ) (list (cadr Pred))))
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
   (if (null (car FEList)) then
      nil
    elseif (Match '(Cut > ExprVar) (car FEList)) then
      (cons (GetBindVal 'ExprVar) (CutVariables (cdr FEList)))
    else
      (CutVariables (cdr FEList))))

(defun ScanVariables (FEList)
   (if (null (car FEList)) then
      nil
    elseif (Match
	 '(Scan > ExprVar (or (LookUp SCLookUp Iter SCIter) *))
	 (car FEList)) then
      (cons (GetBindVal 'ExprVar) (ScanVariables (cdr FEList)))
    else
      (ScanVariables (cdr FEList))))

