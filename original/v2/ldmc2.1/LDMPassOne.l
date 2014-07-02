;***********************************************************************
; Copyright (C) 1989, G. E. Weddell.
;***********************************************************************

;***************************** PASS ONE ********************************

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
(defvar DefaultRCntEst nil)
(defvar VarStack nil)
(defvar MatchVarStack nil)
(defvar FreeMatchVars nil)
(defvar MatchVar nil)

;***********************************************************************
; This file contains the procedures to perform the initial parse
; of LDM source.  Semantic checks that are performed:
; 
; 1. single schema statement.
; 2. acyclicity in "isa" hierarchy.
; 3. user property types ok.
; 4. constraint forms for classes ok.
; 5. variable declarations for queries and transactions ok.
; 6. classes and path functions in index declarations ok.
; 7. classes in store declarations ok.
; 8. each class in one and only one store declaration.
; 9. static store declarations include complete family.
;***********************************************************************

(defun PassOne ()
   (eval Source)
   (setq Queries (reverse Queries))
   (setq Transactions (reverse Transactions))
   (setq Indices (reverse Indices))
   (setq Stores (reverse Stores))
   (ValidateStores))

;***********************************************************************
; Utility routines for flattening various lists.
;***********************************************************************

(defun IdList (P)
   (if (atom P)
      (list P)
      (cons (cadr P) (IdList (caddr P)))))

(defun ClassConList (P)
   (caseq (car P)
      ('Pfd `((Pfd ,(PathFunc (cadr P)) ,(PathFuncList (caddr P)))))
      ('Cover `((Cover ,(IdList (cadr P)))))
      (t `(,@(ClassConList (cadr P)) ,@(ClassConList (caddr P))))))

(defun PathFuncList (P)
   (caseq (car P)
      ('PathFuncList `(,(PathFunc (cadr P)) ,@(PathFuncList (caddr P))))
      (t (list (PathFunc P)))))

(defun PathFunc (P)
   (caseq (car P)
      ('SimpPF (cdr P))
      ('CompPF (cons (cadr P) (PathFunc (caddr P))))))

(defun AsOpList (V P)
   (caseq (car P)
      ('AsOp `((EQ ,(ParseTerm (cadr P))
                ,(ValidateApply (AppendPF V (PathFunc (caddr P)))))))
      ('AsOpList
         (cons `(EQ ,(ParseTerm (cadr P))
                  ,(ValidateApply (AppendPF V (PathFunc (caddr P)))))
            (AsOpList V (cadddr P))))))

(defun InitList (P)
   (caseq (car P)
      ('Init
         (list (ValidateInit `(Assign ,(ValidateApply
               (AppendPF (ParseTerm (cadr P)) (PathFunc (caddr P))))
            ,(ParseTerm (cadddr P))))))
      ('InitList
         (cons (ValidateInit `(Assign ,(ValidateApply
                  (AppendPF (ParseTerm (cadr P)) (PathFunc (caddr P))))
               ,(ParseTerm (cadddr P))))
            (InitList (caddddr P))))))

;***********************************************************************
; Utility routines for access and maintenance of variable
; definitions on VarStack.
;***********************************************************************

(defun VarDecl (Type L &aux VList)
   (setq VList (VarDeclList Type (cadr L) (caddr L)))
   (mapc #'(lambda (Var)
         (if (null (Class? (Type Var))) then
            (ReportError `(BadVarType
                         ,(if QueryName? then 'query else 'transaction)
                         ,QueryOrTransName))))
      VList)
   VList)

(defun VarDeclList (Type L1 L2)
   (if (and (atom L1) (atom L2)) then
      `((,Type ,L1 ,L2))
    elseif (and (listp L1) (listp L2)) then
      (cons `(,Type ,(cadr L1) ,(cadr L2))
            (VarDeclList Type (caddr L1) (caddr L2)))
    else
      (ReportError `(BadVarDecl
                   ,(if QueryName? then 'query else 'transaction)
                   ,QueryOrTransName))))
      
(defun PushVars (Vars)
   (setq VarStack (cons '(**frame**) VarStack))
   (mapc '(lambda (Var) 
         (setq VarStack (cons `(,(cadr Var) ,Var) VarStack)))
      Vars))

(defun PopVars ()
   (caseq (caar VarStack) ('**frame** (PopVar)) (t (PopVar) (PopVars))))

(defun PopVar () (setq VarStack (cdr VarStack)))

(defun ParseTerm (T &aux Term)
   (if (atom T) then
      (cond ((cadr (assq T VarStack)))
            (t (ReportError `(UndefVar ,T
                            ,(if QueryName? then 'query else 'transaction)
                            ,QueryOrTransName)) T))
    else
      (setq Term (eval T))
      (caseq (car Term)
         ((UnMinusOp ModOp TimesOp DivOp AddOp SubOp)
            (if (not (memq (Type Term) '(Integer Real DoubleReal))) then
               (ReportError `(BadArithExpr
                            ,(if QueryName? then 'query else 'transaction)
                            ,QueryOrTransName))))
         (Apply (ValidateApply Term)))
      Term))

(defun ParseIdList (L)
   (if (atom L) then
      (list (ParseTerm L))
    else
      (cons (ParseTerm (cadr L)) (ParseIdList (caddr L)))))

;***********************************************************************
; Non-terminal symbol functions.
;***********************************************************************

(defun SpecList (I L) ())

(defun Schema (fexpr L)
   (setq Schema (car L))
   (eval (cadr L))
   (ValidateSchema)
   (eval (caddr L))) 

(defun Class (fexpr L) (NewClass (car L)))

(defun SubClass (fexpr L)
   (NewClass (car L))
   (AddSupClasses (car L) (IdList (cadr L))))
  
(defun ClassWCon (fexpr L)
   (NewClass (car L))
   (AddClassConstraints (car L) (ClassConList (cadr L))))
  
(defun ClassWProps (fexpr L)
   (NewClass (car L))
   (AddClassProps (car L) (IdList (cadr L))))
  
(defun SubClassWProps (fexpr L)
   (NewClass (car L))
   (AddSupClasses (car L) (IdList (cadr L)))
   (AddClassProps (car L) (IdList (caddr L))))
  
(defun SubClassWCon (fexpr L)
   (NewClass (car L))
   (AddSupClasses (car L) (IdList (cadr L)))
   (AddClassConstraints (car L) (ClassConList (caddr L))))
  
(defun ClassWPropsCon (fexpr L)
   (NewClass (car L))
   (AddClassProps (car L) (IdList (cadr L)))
   (AddClassConstraints (car L) (ClassConList (caddr L))))
  
(defun SubClassWPropsCon (fexpr L)
   (NewClass (car L))
   (AddSupClasses (car L) (IdList (cadr L)))
   (AddClassProps (car L) (IdList (caddr L)))
   (AddClassConstraints (car L) (ClassConList (cadddr L))))
  
(defun Prop (fexpr L) (NewProp (car L) (cadr L)))

(defun StringProp (fexpr L)
   (NewProp (car L) 'String)
   (AddPropConstraint (car L) `(Maxlen ,(Valof (cadr L)))))

(defun IntProp (fexpr L)
   (NewProp (car L) 'Integer)
   (AddPropConstraint (car L) `(Range ,(Valof (cadr L)) ,(Valof (caddr L)))))
  
(defun Query (fexpr L)
   (setq QueryName? t)
   (setq QueryOrTransName (car L))
   (NewQuery (car L) (eval `(,(caadr L) ,(car L) () ,@(cdadr L)))))

(defun ParamQuery (fexpr L)
   (setq QueryName? t)
   (setq QueryOrTransName (car L))
   (let ((Vars (VarDecl 'PVar (cadr L))))
      (PushVars Vars)
      (NewQuery (car L) (eval `(,(caaddr L) ,(car L) ,Vars ,@(cdaddr L))))
      (PopVars)))

(defun AllBody (fexpr L)
   (let ((Vars (VarDecl 'QVar (caddr L))))
      `(AllQuery ,(car L) (,@(cadr L) ,@Vars)
         (Find () (All (Proj) (Sort)) (ScanHeap ,@Vars) (AndHeap)))))

(defun AllBodyPred (fexpr L)
   (let ((Vars (VarDecl 'QVar (caddr L))) Pred)
      (PushVars Vars) (setq Pred (eval (cadddr L))) (PopVars) 
      `(AllQuery ,(car L) (,@(cadr L) ,@Vars)
         (Find () (All (Proj) (Sort)) (ScanHeap ,@Vars) (AndHeap ,Pred)))))

(defun AllBodyOrder (fexpr L)
   (let ((Vars (VarDecl 'QVar (caddr L))) Ord)
      (PushVars Vars) (setq Ord (eval (cadddr L))) (PopVars) 
      `(AllQuery ,(car L) (,@(cadr L) ,@Vars)
         (Find () (All (Proj) (Sort ,@Ord)) (ScanHeap ,@Vars) (AndHeap)))))

(defun AllBodyPredOrder (fexpr L)
   (let ((Vars (VarDecl 'QVar (caddr L))) Pred Ord)
      (PushVars Vars)
      (setq Pred (eval (cadddr L)))
      (setq Ord (eval (caddddr L)))
      (PopVars) 
      `(AllQuery ,(car L) (,@(cadr L) ,@Vars)
         (Find () (All (Proj) (Sort ,@Ord))
            (ScanHeap ,@Vars) (AndHeap ,Pred)))))

(defun AllBodyProj (fexpr L)
   (let ((Vars (VarDecl 'QVar (caddr L))))
      `(AllQuery ,(car L) (,@(cadr L) ,@Vars)
         (Find () (All (Proj ,@Vars) (Sort)) (ScanHeap ,@Vars) (AndHeap)))))

(defun AllBodyPredProj (fexpr L)
   (let ((Vars (VarDecl 'QVar (caddr L))) Pred)
      (PushVars Vars) (setq Pred (eval (cadddr L))) (PopVars) 
      `(AllQuery ,(car L) (,@(cadr L) ,@Vars)
         (Find () (All (Proj ,@Vars) (Sort))
            (ScanHeap ,@Vars) (AndHeap ,Pred)))))

(defun AllBodyOrderProj (fexpr L)
   (let ((Vars (VarDecl 'QVar (caddr L))) Ord)
      (PushVars Vars) (setq Ord (eval (cadddr L))) (PopVars) 
      `(AllQuery ,(car L) (,@(cadr L) ,@Vars)
         (Find () (All (Proj ,@Vars) (Sort ,@Ord))
            (ScanHeap ,@Vars) (AndHeap)))))

(defun AllBodyPredOrderProj (fexpr L)
   (let ((Vars (VarDecl 'QVar (caddr L))) Pred Ord)
      (PushVars Vars)
      (setq Pred (eval (cadddr L)))
      (setq Ord (eval (caddddr L)))
      (PopVars) 
      `(AllQuery ,(car L) (,@(cadr L) ,@Vars)
         (Find () (All (Proj ,@Vars) (Sort ,@Ord))
            (ScanHeap ,@Vars) (AndHeap ,Pred)))))

(defun OneBodyVar (fexpr L)
   (let ((Vars (VarDecl 'QVar (caddr L))))
      `(OneQuery ,(car L)
         (,@(cadr L) ,@Vars)
         (Find () (One) (ScanHeap ,@Vars) (AndHeap)))))

(defun OneBodyPred (fexpr L)
   `(OneQuery ,(car L) (,@(cadr L)) 
				  (Find () (One) (ScanHeap) (AndHeap ,(eval (caddr L))))))

(defun OneBodyVarPred (fexpr L)
   (let ((Vars (VarDecl 'QVar (caddr L))) Pred)
      (PushVars Vars) (setq Pred (eval (cadddr L))) (PopVars) 
      `(OneQuery ,(car L) (,@(cadr L) ,@Vars)
         (Find () (One) (ScanHeap ,@Vars) (AndHeap ,Pred)))))

(defun Exist (fexpr L)
   `(Find () (One) (ScanHeap ,@(VarDecl 'EVar (car L))) (AndHeap)))

(defun ExistPred (fexpr L)
   (let ((Vars (VarDecl 'EVar (car L))) Pred)
      (PushVars Vars) (setq Pred (eval (cadr L))) (PopVars)
      `(Find () (One) (ScanHeap ,@Vars) (AndHeap ,Pred))))

(defun Forall (fexpr L)
   (let ((Vars (VarDecl 'EVar (car L))) Pred)
      (PushVars Vars) (setq Pred (eval (cadr L))) (PopVars)
      `(Not (Find () (One) (ScanHeap ,@Vars) (AndHeap (Not ,Pred))))))

(defun Implies (fexpr L)
   `(Not (Find () (One)
      (ScanHeap) (AndHeap ,(eval (car L)) (Not ,(eval (cadr L)))))))

(defun Or (fexpr L)
   `(Not (Find () (One)
      (ScanHeap) (AndHeap (Not ,(eval (car L))) (Not ,(eval (cadr L)))))))

(defun And (fexpr L)
   `(Find () (One) (ScanHeap) (AndHeap ,(eval (car L)) ,(eval (cadr L)))))

(defun Not (fexpr L) `(Not ,(eval (car L))))

(defun EQ (fexpr L) `(EQ ,(ParseTerm (car L)) ,(ParseTerm (cadr L))))

(defun LT (fexpr L) `(LT ,(ParseTerm (car L)) ,(ParseTerm (cadr L))))

(defun GT (fexpr L) `(GT ,(ParseTerm (car L)) ,(ParseTerm (cadr L))))

(defun LE (fexpr L) `(LE ,(ParseTerm (car L)) ,(ParseTerm (cadr L))))

(defun GE (fexpr L) `(GE ,(ParseTerm (car L)) ,(ParseTerm (cadr L))))

(defun NE (fexpr L) `(Not (EQ ,(ParseTerm (car L)) ,(ParseTerm (cadr L)))))

(defun HasMax (fexpr L)
   (let ((Var (ParseTerm (car L)))
         (PF (PathFunc (cadr L)))
         NewVar)
      (setq NewVar (NewVariable 'EVar (caddr Var)))
      `(Not (Find () (One) (ScanHeap ,NewVar)
         (AndHeap (GT (Apply ,NewVar ,PF) (Apply ,Var ,PF)))))))

(defun HasMin (fexpr L)
   (let ((Var (ParseTerm (car L)))
         (PF (PathFunc (cadr L)))
         NewVar)
      (setq NewVar (NewVariable 'EVar (caddr Var)))
      `(Not (Find () (One) (ScanHeap ,NewVar)
         (AndHeap (LT (Apply ,NewVar ,PF) (Apply ,Var ,PF)))))))

(defun HasMaxPred (fexpr L)
   (let ((Var (ParseTerm (car L)))
         (PF (PathFunc (cadr L)))
         (Pred (eval (caddr L)))
         NewVar)
      (setq NewVar (NewVariable 'EVar (caddr Var)))
      `(Find () (One) (ScanHeap) (AndHeap ,Pred
         (Not (Find () (One) (ScanHeap ,NewVar) (AndHeap
            ,(ReplaceVar Pred Var NewVar)
            (GT (Apply ,NewVar ,PF) (Apply ,Var ,PF)))))))))

(defun HasMinPred (fexpr L)
   (let ((Var (ParseTerm (car L)))
         (PF (PathFunc (cadr L)))
         (Pred (eval (caddr L)))
         NewVar)
      (setq NewVar (NewVariable 'EVar (caddr Var)))
      `(Find () (One) (ScanHeap) (AndHeap ,Pred
         (Not (Find () (One) (ScanHeap ,NewVar) (AndHeap
            ,(ReplaceVar Pred Var NewVar)
            (LT (Apply ,NewVar ,PF) (Apply ,Var ,PF)))))))))

(defun Pred (fexpr L)
   (let ((NewVar (NewVariable 'EVar (car L))))
      `(Find () (One) (ScanHeap ,NewVar)
         (AndHeap ,@(AsOpList NewVar (cadr L))))))

(defun OrderAsc (fexpr L) `((,(ParseTerm (car L)) Asc)))

(defun OrderDesc (fexpr L) `((,(ParseTerm (car L)) Desc)))

(defun OrderAscList (fexpr L)
   (cons `(,(ParseTerm (car L)) Asc) (eval (cadr L))))

(defun OrderDescList (fexpr L)
   (cons `(,(ParseTerm (car L)) Desc) (eval (cadr L))))

(defun AddOp (fexpr L) `(AddOp ,(ParseTerm (car L)) ,(ParseTerm (cadr L))))

(defun SubOp (fexpr L) `(SubOp ,(ParseTerm (car L)) ,(ParseTerm (cadr L))))

(defun ModOp (fexpr L) `(ModOp ,(ParseTerm (car L)) ,(ParseTerm (cadr L))))

(defun TimesOp (fexpr L) `(TimesOp ,(ParseTerm (car L)) ,(ParseTerm (cadr L))))

(defun DivOp (fexpr L) `(DivOp ,(ParseTerm (car L)) ,(ParseTerm (cadr L))))

(defun UnMinusOp (fexpr L) `(UnMinusOp ,(ParseTerm (car L))))

(defun Constant (fexpr L) (cons 'Constant L))

(defun Apply (fexpr L) `(Apply ,(ParseTerm (car L)) ,(PathFunc (cadr L))))

(defun Trans (fexpr L)
   (setq QueryName? nil)
   (setq QueryOrTransName (car L))
   (NewTrans (car L) (eval `(,(caadr L) ,(car L) () ,@(cdadr L)))))

(defun ParamTrans (fexpr L)
   (setq QueryName? nil)
   (setq QueryOrTransName (car L))
   (let ((Vars (VarDecl 'PVar (cadr L))))
      (PushVars Vars)
      (NewTrans (car L) (eval `(,(caaddr L) ,(car L) ,Vars ,@(cdaddr L))))
      (PopVars)))

(defun Body (fexpr L)
   `(StmtTrans ,(car L) ,(cadr L) (Block () ,@(eval (caddr L)))))

(defun BodyWLocVars (fexpr L)
   (let ((Vars (VarDecl 'QVar (caddr L))) StmtList)
      (PushVars Vars)
      (setq StmtList (eval (cadddr L)))
      (PopVars)
      `(StmtTrans ,(car L) ,(cadr L) (Block ,Vars ,@StmtList))))

(defun ReturnBody (fexpr L)
   `(ExprTrans
      ,(car L) ,(cadr L) (Block () ,@(eval (caddr L))) ,(ParseTerm (cadddr L))))

(defun ReturnBodyWLocVars (fexpr L)
   (let ((Vars (VarDecl 'QVar (caddr L))) StmtList Term)
      (PushVars Vars)
      (setq StmtList (eval (cadddr L)))
      (setq Term (ParseTerm (caddddr L)))
      (PopVars)
      `(ExprTrans ,(car L) ,(cadr L) (Block ,Vars ,@StmtList) ,Term)))

(defun StmtList (StmtList1 StmtList2) (append StmtList1 StmtList2))

(defun Insert (fexpr L) `((Insert ,(ValidateInsert (ParseIdList (car L))))))

(defun InsertWInits (fexpr L)
   (let ((Vars (ValidateInsert (ParseIdList (car L)))) IList)
      (PushVars Vars) (setq IList (InitList (cadr L))) (PopVars)
      `((Insert ,Vars ,@IList))))

(defun Delete (fexpr L) `((Delete ,(ParseIdList (car L)))))

(defun Assign (fexpr L)
   (let ((LHS (ParseTerm (car L))) Prop)
      (if (eq (car LHS) 'Apply) then
         (setq Prop (car (last (caddr LHS))))
         (if (not (eq Prop 'Id)) then (putprop Prop t 'Updated?)))
      (list (ValidateAssign `(Assign ,LHS ,(ParseTerm (cadr L)))))))

(defun DefSizeEst (fexpr L) (putprop (car L) (Valof (cadr L)) 'RCntEst))

(defun DefSelectEst (fexpr L) (putprop (car L) (Valof (cadr L)) 'SelectEst))

(defun DefOverlapEst (fexpr L)
   (let ((P (car L)))
      (putprop P (cons `(,(cadr L) ,(Valof (caddr L)))
         (get P 'OverlapEst)) 'OverlapEst)))

(defun DefFreqEst (fexpr L)
   (cond ((Query? (car L))
            (putprop (car L) (Valof (cadr L)) 'QueryFreqEst))
         ((Trans? (car L))
            (putprop (car L) (Valof (cadr L)) 'TransFreqEst))))

(defun DefUnitTime (fexpr L) (setq UnitTime (Valof (car L))))

(defun DefUnitSpace (fexpr L) (setq UnitSpace (Valof (car L))))

(defun Index (fexpr L)
   (let ((IName (car L)) (IClass (cadr L)))
      (if (Index? IName) then (ReportError `(IndexExists ,IName)))
      (putprop IName t 'Index?)
      (eval `(,(caaddr L) ,IName ,IClass ,(cadaddr L) ,(caddaddr L)))
      (if (not (UserClass? IClass)) then
         (ReportError `(UndefClass ,IClass index ,IName)))
      (AddClassIndex IClass IName)
      (if (Distributed? IName) then
         (if (or (not (CheckPF IClass (DistPF IName)))
                 (not (UserClass? (Dom (DistPF IName))))) then
            (ReportError `(BadIndexDistPF ,IName))))
      (do SCondList (IndexSearchConds IName) (cdr SCondList) (null SCondList)
         (caseq (caar SCondList)
            (PFCond
               (if (not (CheckPF IClass (cadar SCondList))) then
                  (ReportError `(BadIndexPFSort ,IName))))
            (SCCond
               (if (not (memq (cadar SCondList) (SubClasses+ IClass))) then
                  (ReportError `(BadIndexSCSort ,IName)))
               (setq IClass (cadar SCondList)))))
      (setq Indices (cons IName Indices))))


(defun List (fexpr L)
   (putprop (car L) (cadr L) 'IndexClass)
   (putprop (car L) 'List 'IndexType))

(defun Array (fexpr L)
   (putprop (car L) (cadr L) 'IndexClass)
   (putprop (car L) 'Array 'IndexType)
   (putprop (car L) (eval (cadddr L)) 'IndexSearchConds)
   (putprop (car L) t 'StaticIndex?)
   (putprop (car L) (Valof (caddr L)) 'IndexSize))
 
(defun BinaryTree (fexpr L)
   (putprop (car L) (cadr L) 'IndexClass)
   (putprop (car L) 'BinaryTree 'IndexType)
   (putprop (car L) (eval (caddr L)) 'IndexSearchConds))

(defun DistList (fexpr L)
   (let ((PF (PathFunc (caddr L))))
      (putprop (car L) (cadr L) 'IndexClass)
      (AddClassDistIndex (Dom PF) (car L))
      (putprop (car L) 'DistList 'IndexType)
      (putprop (car L) `((PFCond ,PF NoOrder)) 'IndexSearchConds)
      (putprop (car L) t 'Distributed?)
      (putprop (car L) PF 'DistPF)))

(defun DistPointer (fexpr L)
   (let ((PF (PathFunc (caddr L))))
      (putprop (car L) (cadr L) 'IndexClass)
      (AddClassDistIndex (Dom PF) (car L))
      (putprop (car L) 'DistPointer 'IndexType)
      (putprop (car L) `((PFCond ,PF NoOrder)) 'IndexSearchConds)
      (putprop (car L) t 'Distributed?)
      (putprop (car L) PF 'DistPF)))

(defun DistBinaryTree (fexpr L)
   (let ((PF (PathFunc (caddr L))))
      (putprop (car L) (cadr L) 'IndexClass)
      (AddClassDistIndex (Dom PF) (car L))
      (putprop (car L) 'DistBinaryTree 'IndexType)
      (putprop (car L)
         `((PFCond ,PF NoOrder) ,@(eval (cadddr L))) 'IndexSearchConds)
      (putprop (car L) t 'Distributed?)
      (putprop (car L) PF 'DistPF)))

(defun SearchCondList (fexpr L) `(,@(eval (car L)) ,@(eval (cadr L))))

(defun AscSearchCond (fexpr L) `((PFCond ,(PathFunc (car L)) Asc)))

(defun DescSearchCond (fexpr L) `((PFCond ,(PathFunc (car L)) Desc)))

(defun SCSearchCond (fexpr L) `((SCCond ,(car L))))

(defun Store (fexpr L)
   (let ((SName (car L)))
      (if (Store? SName) then (ReportError `(StoreExists ,SName)))
      (putprop SName t 'Store?)
      (do CList (IdList (caddr L)) (cdr CList) (null CList)
         (if (null (UserClass? (car CList))) then
            (ReportError `(UndefClass ,(car CList) store ,SName)))
         (if (ClassStore (car CList)) then
            (ReportError `(MultipleClassStore ,(car CList))))
         (putprop SName (cons (car CList) (StoreClasses SName)) 'StoreClasses)
         (putprop (car CList) SName 'ClassStore))
      (caseq (caadr L)
         (Dynamic
            (putprop SName 'Dynamic 'StoreType))
         (Static
            (let ((Family nil))
               (do CList (StoreClasses SName) (cdr CList) (null CList)
                  (setq Family (SetUnion Family (SubClasses* (car CList)))))
               (do CList Family (cdr CList) (null CList)
                  (if (and (null (ClassCovers (car CList)))
                           (not (memq (car CList) (StoreClasses SName))))
                     (ReportError `(BadStaticStore ,SName)))))
            (putprop SName t 'StaticStore?)
            (putprop SName (Valof (cadadr L)) 'StoreSize)))
      (setq Stores (cons SName Stores))))


;***********************************************************************
; The following functions validate various semantic constraints on
; LDM source.
;***********************************************************************

(defun ValidateInsert (VList)
   (mapc #'(lambda (V)
         (if (ClassCovers (Type V)) then
             (ReportError `(BadCreate ,QueryOrTransName))))
      VList)
   VList)
      

(defun ValidateSchema (&aux CProps)
   (mapc #'(lambda (C) (if (not (Prop? C)) then (NewProp C C))) Classes)
   (mapc #'(lambda (C)
         (putprop C t 'UserClass?)
         (putprop C (ClassProps C) 'ClassUserProps)
         (putprop C (SupClasses C) 'SupUserClasses))
      Classes)
   (mapc #'(lambda (P) (putprop P t 'UserProp?)) Properties)
   (mapc 'NewClass BuiltInClasses)
   (IsaClose)
   (mapc #'(lambda (PName)
         (if (not (Class? (PropType PName))) then
            (ReportError
               `(UndefClass ,(PropType PName) property ,PName))))
      Properties)
   (mapc #'(lambda (CName)
         (do SCList (SupClasses CName) (cdr SCList) (null SCList)
            (if (not (UserClass? (car SCList))) then
               (ReportError `(NotUserClass
                            ,(car SCList) class ,CName))))
         (do PList (ClassProps CName) (cdr PList) (null PList)
            (if (not (Prop? (car PList))) then
               (ReportError `(UndefProp
                            ,(car PList) class ,CName))))
         (do SCList (SupClasses+ CName) (cdr SCList) (null SCList)
            (setq CProps (SetIntersection (ClassProps CName)
                  (ClassProps (car SCList))))
            (if CProps then
               (ReportError `(MultipleClassProp ,(car CProps) ,CName))))
         (do CoverList (ClassCovers CName) (cdr CoverList) (null CoverList)
            (if (SetDifference (car CoverList) (SubClasses CName)) then
               (ReportError `(BadCoverConstraint ,CName))))
         (do PfdList (ClassPfds CName) (cdr PfdList) (null PfdList)
            (CheckClassPF CName (caar PfdList))
            (do PFList (cadar PfdList) (cdr PFList) (null PFList) 
               (CheckClassPF CName (car PFList)))))
      Classes))


(defun CheckClassPF (CName PF)
   (if (null (CheckPF CName PF)) then
      (ReportError `(BadPfdConstraint ,CName))))


(defun ValidateStores ()
   (mapc #'(lambda (CName)
         (if (and (UserClass? CName) (not (ClassCovers CName))) then
            (if (null (ClassStore CName)) then
               (ReportError `(UndefClassStore ,CName)))))
      Classes))


(defun ValidateApply (Term)
   (if (or (neq (car Term) 'Apply)
           (CheckPF (Type (cadr Term)) (caddr Term))) then
      Term
    else
      (ReportError `(BadPfInExpr
                   ,(if QueryName? then 'query else 'transaction)
                   ,QueryOrTransName))))


(defun ValidateInit (Init)
   (if (memq (Type (cadr Init)) (SupClasses* (Type (caddr Init)))) then
      Init
    else
      (ReportError `(BadAssign ,QueryOrTransName))))


(defun ValidateAssign (Assign)
   (if (Match '(Assign (Apply ? (Id)) ?) Assign) then
      Assign
    else
      (ValidateInit Assign)))


(defun CheckPF (CName PF)
   (if (null PF) then t
    else (or (equal PF '(Id))
             (and (memq (car PF) (ClassProps* CName))
                  (CheckPF (PropType (car PF)) (cdr PF))))))
