;***********************************************************************
;***********************************************************************

(defvar InfoList)
(defvar InlineFlag)
(defvar LevelCounter)
(defvar CurrentQuery)
(defvar SchemaName)
(defvar SchemaVarName)
(defvar ScopeList)
(defvar SubstitutionMatch)
(defvar CompareFuncCode)
(defvar Refer)
(defvar @SchemaVar)
(defvar @Dummy)
(defvar @Label)
(defvar @Compare)

(setq MatchVar (gensym "B") MatchVarStack nil FreeMatchVars nil)

;***********************************************************************************************************************************
;***********************************************************************************************************************************


(defun MAIN ()
  (prog (HeaderCode PDMCode Port)
	(setq InfoList '((Reference |StoreTemplate| Direct)))
        (setq InlineFlag 1
              @SchemaVar 0
              @Dummy 0
              @Compare 0
              @Label 0)
        (setq Port (open "pdmc.schemaname"))
        (setq SchemaName (read Port))
        (close Port)
        (setq CompareFuncCode nil)
        (setq PDMCode (PhaseOne "pdmc.pdm.input"))
        (setq HeaderCode (PhaseTwo PDMCode))
        (PhaseThree HeaderCode "pdmc.output")))


(defun LoadSource ()
   (load "PatMatch.l")
   (load "RuleUse.l")
   (load "PDMCompLib.l")
   (load "PDMGenCCode.l"))


;***********************************************************************************************************************************
;***********************************************************************************************************************************



(defun PhaseOne (PDMFile)
  (prog (PDMCode Port)
        (setq Port (open PDMFile))
        (setq PDMCode (read Port))
        (close Port)
        (setq PDMCode (FixInput PDMCode))
        (return PDMCode)))


(defun PhaseTwo (PDMCode)
  (prog () 
        (PrintMsg "processing PDM code.")
        (return (ProcessPDMCode PDMCode))))


(defun PhaseThree (HeaderCode OutputFile)
  (PrintMsg "code generation.")
  (GenCode HeaderCode OutputFile))


;***********************************************************************************************************************************
;***********************************************************************************************************************************


(defun ProcessPDMCode (PDMCode) 
  (prog (Code QueryCode PDMClass PDMProp PDMIndex PDMStore PDMCQuery PDMTrans FieldList) 
        (setq PDMCode (caddr PDMCode))
        (do ((PDMCode PDMCode (caddr PDMCode))) ((null PDMCode))
            (cond ((equal (caadr PDMCode) 'ClassSpec) 
                   (setq PDMClass (append PDMClass (list (cadr PDMCode))) 
                         InfoList (append InfoList `((Reference ,(cadadadr PDMCode) ,(caadaddddadr PDMCode))
                                                     ,(append (list 'Msc (cadadadr PDMCode)) (cdadddadr PDMCode))
                                                     (IsA ,(cadadadr PDMCode) ,(caddadadr PDMCode)))))
                   (do ((Temp (RestoreList (cadaddadr PDMCode)) (cdr Temp))) ((null Temp))
                       (setq InfoList (append1 InfoList `(Property ,(cadadadr PDMCode) ,(car Temp)))))

                   (setq FieldList nil)
                   (cond ((not (null (cadadddddadr PDMCode)))
                          (CMatch `(* (FieldList ,(cadadddddadr PDMCode) > P1) *) InfoList)
                          (setq FieldList (Build '(<< P1)))))

                   (setq FieldList (append FieldList (RestoreList (cadaddddddadr PDMCode))))
                   (setq InfoList (append1 InfoList `(FieldList ,(cadadadr PDMCode) ,FieldList)))


                   (do ((Temp FieldList (cdr Temp))) ((null Temp))
                       (setq InfoList (append1 InfoList `(Field ,(cadadadr PDMCode) ,(car Temp))))))

                  ((equal (caadr PDMCode) 'PropertySpec) 
                   (setq PDMProp (cons (cadr PDMCode) PDMProp)
                         InfoList (append1 InfoList (append '(Type) (cdadr PDMCode))))) 

                  ((equal (caadr PDMCode) 'IndexSpec) 
                   (setq InfoList (append1 InfoList (cadr PDMCode))
                         PDMIndex (cons (cadr PDMCode) PDMIndex)))
                  ((equal (caadr PDMCode) 'StoreSpec) 
                   (setq PDMStore (append1 PDMStore (cadr PDMCode)))
                   (do ((Temp (RestoreList (cadddadr PDMCode)) (cdr Temp))) ((null Temp))
                       (setq InfoList (append1 InfoList (list 'StoreSpec (cadadr PDMCode) (caddadr PDMCode) (car Temp))))))

                  ((equal (caadr PDMCode) 'QuerySpec)
                   (setq PDMCQuery (append PDMCQuery (list (cadr PDMCode)))))
                  ((equal (caadr PDMCode) 'TransSpec)
                   (setq PDMTrans (append1 PDMTrans (cadr PDMCode))))))

        (setq Code (SetClassDecl PDMClass PDMProp)) 
        (setq Code (SetAccessFunctions Code))
        (setq Code (SetStoreDecl Code PDMStore))
        (setq Code (SetQueryStruct Code PDMCQuery))

        (SetBasicCompareFuncs PDMIndex)
        (setq QueryCode (SetQuery PDMCQuery))
        (if (not (null CompareFuncCode)) (setq Code `(File ,Code ,CompareFuncCode)))

        (setq Code (SetIndex Code PDMIndex))
        (setq Code (SetTransaction Code PDMTrans))

        (setq Code `(File ,Code ,QueryCode))


        (return Code)))


;***********************************************************************************************************************************
;***********************************************************************************************************************************

(defun SetClassDecl (PDMClass PDMProp)
  (prog (ReturnCode Fields Temp)
        (PrintMsg "   generating class structures.")

        (do ((PDMClass PDMClass (cdr PDMClass))) ((null PDMClass))
            (cond ((equal 1 (length (cadddddar PDMClass))) 
                   (setq Fields nil))
                  (t
                   (CMatch  `(* (DeclSpec (StructWIdDecl (Id ,(cadadddddar PDMClass)) >* P)) *)  ReturnCode)
                   (setq Fields (Build '(<< P)))))
            (setq Fields (append Fields (RestoreFieldList (cadaddddddar PDMClass))))
            (setq ReturnCode 
                  (append1 ReturnCode (list 'DeclSpec (append (list 'StructWIdDecl (list 'Id (cadadar PDMClass))) Fields))))
            (setq Temp nil)
            (do ((Fields Fields (cdr Fields))) ((null Fields))
                (setq Temp (append1 Temp (cadar Fields)))))
        (do ((PDMProp PDMProp (cdr PDMProp))) ((null PDMProp))
            (setq ReturnCode (subst (GenStructDeclCode (cadar PDMProp) (cadar PDMProp) 'StructDecl) 
                                    (list 'Field (cadar PDMProp)) ReturnCode :test #'equal)))
        (do ((ReturnCode ReturnCode (cdr ReturnCode))) ((null ReturnCode))
            (ApplyRuleControl '(Call BodyControl1) (cddadar ReturnCode))) 
        (ApplyRuleControl '(Call BodyControl) ReturnCode) 


        (return `(File (Comment "==== Class structures ===================================") ,(car ReturnCode)))))


(LoadRules 
  '((FileRule1 (> V1 > V2 >* V3) ((File < V1 < V2) << V3))
    (FileRule2 ((File >* V1) > V2 >* V3) ((File (File << V1) < V2) << V3))
    (SDLrule1 (> V1 > V2 >* V3) ((StructDeclList < V1 < V2) << V3))
    (SDLrule2 ((StructDeclList >* V1) > V2 >* V3) ((StructDeclList (StructDeclList << V1) < V2) << V3))))


(LoadControl
  '(BodyControl
    (Seq FileRule1 (Rep FileRule2))))


(LoadControl
  '(BodyControl1
    (Seq SDLrule1 (Rep SDLrule2))))


;***********************************************************************************************************************************
;***********************************************************************************************************************************

(defun SetAccessFunctions (Code)
  (prog (TempCode1 TempCode2 Class Property Reference Type)
        (PrintMsg "   generating Access and Assign functions.")
        (do ((Temp InfoList (cdr Temp))) ((null Temp))
            (cond ((equal (caar Temp) 'Field)
                   (setq Class (cadar Temp) Property (caddar Temp))
                   (CMatch `(* (Reference ,Class > P1) *) InfoList)
                   (CMatch `(* (Type ,Property > P2 *) *) InfoList)
                   (setq Reference (car (Build '(< P1))) Type (car (Build '(< P2))))
                   (setq TempCode1 `(FuncVarWPIdList (Id ,(concat '|Access| Class Property)) (Id P)))
                   (setq TempCode1 (GenStructDeclCode TempCode1 Property 'InlineFuncDefnWDeclSpec))
                   (cond ((equal Reference 'Direct)
                          (setq TempCode2 `(CompndStmtWSList (ReturnWExp (PrimExp (FieldAcc (Id P) (Id ,Property)))))))
                         (t
                          (setq TempCode2 
                                `(CompndStmtWSList (ReturnWExp (PrimExp (FieldAcc (PrimExp (BangOp (Id P))) (Id ,Property))))))))
                   (setq TempCode2 `(FuncBodyWDeclList ,(GenStructDeclCode 'P Class 'DeclSpecWVars) ,TempCode2))
                   (setq Code `(File ,Code ,(append1 TempCode1 TempCode2)))
                   (setq TempCode1 
                         `(DeclList ,(GenStructDeclCode 'P Class 'DeclSpecWVars) ,(GenStructDeclCode '|Val| Property 'DeclSpecWVars)))
                   (cond ((equal Reference 'Direct)
                          (cond ((equal Type 'String)
                                 (setq TempCode2 
                                       `(CompndStmtWSList  
                                         (ExprStmt 
                                          (FuncCallP (Id |strcpy|) (ArgExpList (FieldAcc (Id P) (Id ,Property)) (Id |Val|)))))))
                                (t
                                 (setq TempCode2 
                                       `(CompndStmtWSList (ExprStmt (AssignOp (FieldAcc (Id P) (Id ,Property)) (Id |Val|))))))))
                         (t
                          (cond ((equal Type 'String)
                                 (setq TempCode2 
                                       `(CompndStmtWSList  
                                         (ExprStmt 
                                          (FuncCallP (Id |strcpy|) 
                                                     (ArgExpList (FieldAcc (PrimExp (BangOp (Id P))) (Id ,Property)) (Id |Val|)))))))
                                (t
                                 (setq TempCode2 
                                       `(CompndStmtWSList 
                                         (ExprStmt (AssignOp (FieldAcc (PrimExp (BangOp (Id P))) (Id ,Property)) (Id |Val|)))))))))
                   (setq Code `(File ,Code
                                     (InlineFuncDefnWDeclSpec
                                      (VoidType)
                                      (FuncVarWPIdList (Id ,(concat '|Assign| Class Property)) (IdList (Id P) (Id |Val|)))
                                      (FuncBodyWDeclList ,TempCode1 ,TempCode2)))))))
        (return Code)))






;***********************************************************************************************************************************
;***********************************************************************************************************************************



(defun SetStoreDecl (Code StoreList)
  (prog ()
        (setq Code 
              `(File ,Code (File 
                            (File
                             (Comment "Structure for Store") 
                             (DeclSpecWVars (VoidType) (InitDecl (PtrVar (Ptr) (Id |PDMCellStore|)) (Const "0"))))
                            (DeclSpec (StructWIdDecl (Id |StoreTemplate|) 
                                                     (StructDecl (StructWId (Id |StoreTemplate|)) (PtrVar (Ptr) (Id |Next|))))))))
        (do ((StoreList StoreList (cdr StoreList))) ((null StoreList))
            (setq Code `(File ,Code (DefineStore ,(concat (cadar StoreList) '|Size|) ,(RestoreList (cadddar StoreList))))))
        (return Code)))



;***********************************************************************************************************************************
;***********************************************************************************************************************************


(defun SetQueryStruct (Code Query)
  (prog (Temp Name G1 G2 S1 S2 D1 D2)
        (PrintMsg "   generating query structures.")
        (setq Code `(File ,Code (Comment "==== Structure for Queries ======================")))
        (do ((Query Query (cdr Query))) ((null Query))
            (setq Name (cadadar Query)
                  G1 (RestoreList (cadaddar Query)) 
                  G2 (RestoreList (caddaddar Query)) 
                  S1 (RestoreList (cadadddar Query)) 
                  S2 (RestoreList (caddadddar Query))
                  D1 (RestoreList (cadaddddar Query)) 
                  D2 (RestoreList (caddaddddar Query))
                  Temp `(StructDeclList (StructDecl (IntType) (Id |First|)) (StructDecl (IntType) (Id |Result|))))
            (do ((CutList (FindCutVar (cadddddar Query)) (cdr CutList))) ((null CutList))
                (setq Temp `(StructDeclList ,Temp (StructDecl (IntType) (Id ,(concat (car CutList) '|Cut|))))))
            (do ((G1 (append G1 S1 D1) (cdr G1)) (G2 (append G2 S2 D2) (cdr G2))) ((null G1))
                (setq Temp `(StructDeclList ,Temp ,(GenStructDeclCode (car G1) (car G2) 'StructDecl))))
            (setq Code `(File ,Code (DeclSpec (StructWIdDecl (Id ,(concat Name '|Struct|)) ,Temp)))))
        (return Code)))


(defun FindCutVar (Query)
  (prog ()
        (cond ((equal (car Query) 'Join)
               (return (append (FindCutVar (cadr Query)) (FindCutVar (caddr Query)))))
              ((equal (car Query) 'Compliment)
               (return (FindCutVar (cadr Query))))
              ((member (car Query) '(Select Cut))
               (return (FindCutVar (caddr Query))))
              ((member (car Query) '(AssignIndexEach AssignIndexFirst AssignIndexFirstCond AssignIndexEachCond))
               (return (cdadr Query)))
              ((member (car Query) '(NullTuple Assign))
               (return nil))
              (t
               (PrintMsg "****Warning from FindCutVar")))))



;***********************************************************************************************************************************
;***********************************************************************************************************************************


(defun SetTransaction (Code PDMTrans)
  (prog (FuncHead ParaDecl LocalDecl Body List1 List2 Temp Temp1)
        (PrintMsg "   processing transactions.")
        (setq Code (list 'File Code (list 'Comment "==== Function Decl ====")))

        (do ((PDMTrans PDMTrans (cdr PDMTrans))) ((null PDMTrans))
            (princ "      transaction: " *error-output*)
            (PrintMsg (cadar PDMTrans))

            ;function header
            (cond ((null (cadaddar PDMTrans))
                   (setq FuncHead `(FuncVarWPIdList (Id ,(cadar PDMTrans)) (Id |PDMCSchema|))))
                  (t
                   (setq FuncHead `(FuncVarWPIdList (Id ,(cadar PDMTrans)) (IdList (Id |PDMCSchema|) ,(cadaddar PDMTrans))))))
            (cond ((equal (caaddddar PDMTrans) 'Procedure)
                   (setq FuncHead `(InlineFuncDefnWDeclSpec (VoidType) ,FuncHead)))
                  (t
                   (setq Temp (cadaddaddddar PDMTrans))
                   (setq List1 (append (RestoreList (cadaddar PDMTrans)) (RestoreList (cadadddar PDMTrans)))) 
                   (setq List2 (append (RestoreList (caddaddar PDMTrans)) (RestoreList (caddadddar PDMTrans)))) 
                   (do ((List1 List1 (cdr List1)) (List2 List2 (cdr List2))) ((null List1)) 
                       (cond ((equal Temp (car List1))
                              (setq Temp1 (car List2))
                              (setq List1 nil))))
                   (setq FuncHead (GenStructDeclCode FuncHead Temp1 'InlineFuncDefnWDeclSpec))))

            ;parameter declarations
            (setq ParaDecl `(DeclSpecWVars (StructWId (Id ,(concat SchemaName '|Struct|))) (PtrVar (Ptr) (Id |PDMCSchema|))))
            (setq List1 (RestoreList (cadaddar PDMTrans)))
            (setq List2 (RestoreList (caddaddar PDMTrans)))
            (do ((List1 List1 (cdr List1)) (List2 List2 (cdr List2))) ((null List1))
                (setq ParaDecl (list 'DeclList ParaDecl (GenStructDeclCode (car List1) (car List2) 'DeclSpecWVars)))) 

            ;local declaration
            (cond ((equal (cadddar PDMTrans) '(Declare))
                   (setq LocalDecl nil))
                  (t
                   (setq LocalDecl nil) 
                   (setq List1 (RestoreList (cadadddar PDMTrans))) 
                   (setq List2 (RestoreList (caddadddar PDMTrans))) 
                   (do ((List1 List1 (cdr List1)) (List2 List2 (cdr List2))) ((null List1))
                       (cond ((null LocalDecl)
                              (setq LocalDecl (GenStructDeclCode (car List1) (car List2) 'DeclSpecWVars)))
                             (t
                              (setq LocalDecl `(DeclList ,LocalDecl ,(GenStructDeclCode (car List1)(car List2) 'DeclSpecWVars))))))))
            
            ;function body
            (setq Body '(NullStmt))
            (setq List1 (append (RestoreList (cadaddar PDMTrans)) (RestoreList (cadadddar PDMTrans)))) 
            (setq List2 (append (RestoreList (caddaddar PDMTrans)) (RestoreList (caddadddar PDMTrans)))) 
            
            (setq ScopeList nil)
            (do ((List1 List1 (cdr List1)) (List2 List2 (cdr List2))) ((null List1))
                (setq ScopeList (cons (list (car List1) (car List2)) ScopeList)))
            (setq ScopeList (list ScopeList))

            (cond ((equal (caaddddar PDMTrans) 'Procedure)
                   (setq Body (ProcessTransAction (cadaddddar PDMTrans) List1 List2)))
                  (t
                   (setq Body (list 'StmtList (ProcessTransAction (cadaddddar PDMTrans) List1 List2) 
                                    (list 'ReturnWExp (list 'PrimExp (list 'Id (cadaddaddddar PDMTrans))))))))

            ;combinations
            (cond ((null LocalDecl) 
                   (setq Temp (append  FuncHead (list (list 'FuncBodyWDeclList ParaDecl (list 'CompndStmtWSList Body))))))
                  (t
                   (setq Temp 
                         (append  FuncHead 
                                  (list (list 'FuncBodyWDeclList ParaDecl (list 'CompndStmtWDListSList LocalDecl Body)))))))

            (setq Code (list 'File Code Temp)))

        (return Code)))





(defun ProcessTransAction (Action List1 List2)
  (prog () 
        (cond ((equal (car Action) 'StmtList)
               (return (list 'StmtList (ProcessTransAction (cadr Action) List1 List2)
                             (ProcessTransAction (caddr Action) List1 List2))))
              ((equal (car Action) 'INSERT)
               (return (TransInsert Action)))
              ((equal (car Action) 'REMOVE)
               (return (TransRemove Action)))
              ((equal (car Action) 'CREATE)
               (return (TransCreate Action)))
              ((equal (car Action) 'DESTROY)
               (return (TransDestroy Action)))
              ((equal (car Action) 'COLONEQ)
               (return (TransColonEq (cdr Action) List1 List2)))
              ((equal (car Action) 'COLONEQID)
               (return (TransColonEqId (cdr Action) List1 List2)))
              ((equal (car Action) 'ALLOCATE)
               (return (TransAllocate Action List1 List2)))
              ((equal (car Action) 'ALLOCATEINDIRECT)
               (return (TransAllocateIndirect Action List1 List2)))
              ((equal (car Action) 'ALLOCID)
               (return (TransAllocId Action List1 List2)))
              ((equal (car Action) 'FREEID)
               (return (TransFreeId Action)))
              ((equal (car Action) 'FREE)
               (return (TransFree Action)))
              ((equal (car Action) 'FREEINDIRECT)
               (return (TransFreeIndirect Action)))
              ((equal (car Action) 'COPY)
               (return (TransCopy Action)))
              ((equal (car Action) 'IF)
               (return (TransIf Action List1 List2)))
              ((equal (car Action) 'INITINDEX)
               (return (TransInitIndex Action)))
              ((equal (car Action) 'INITSTORE)
               (return (TransInitStore Action)))
					)))


(defun TransInitIndex (Action)
  (prog ()
		  (return
			`(ExprStmt (AssignOp (FieldAcc (Id |PDMCSchema|) (Id ,(concat (cadadr Action) '|Head|))) (Const "0"))))))
	

(defun TransInitStore (Action)
  (prog ()
		  (return
			`(ExprStmt (AssignOp (FieldAcc (Id |PDMCSchema|) (Id ,(cadadr Action))) (Const "0"))))))


(defun TransCopy (Action) 
  (prog ()
        (cond ((equal (caadr Action) 'AS)
               (setq Action (list (car Action) (cadadr Action) (caddr Action) (cadddr Action)))))

        (return 
         `(ExprStmt 
           (FuncCallP (Id ,(concat '|Copy| (cadadddr Action))) (ParamList (Id |PDMCSchema|) (ParamList ,(cadr Action) ,(caddr Action))))))))





(defun TransInsert (Action) 
  (prog ()
        (cond ((equal (caadr Action) 'AS)
               (setq Action (list (car Action) (cadadr Action) (caddr Action)))))

        (CMatch `(* (IndexSpec ,(cadaddr Action) ? ? ? ? > P1) *) InfoList)
        (cond ((null (car (Build '(< P1))))
               (return `(ExprStmt (FuncCallP (Id ,(concat '|Add| (cadaddr Action))) (ParamList (Id |PDMCSchema|) ,(cadr Action))))))
              (t
               (return `(ExprStmt (FuncCallP (Id ,(concat '|Add| (cadaddr Action))) 
                                             (ParamList (ParamList (Id |PDMCSchema|) ,(cadr Action))
                                                        (Id ,(concat (cadaddr Action) '|Compare|))))))))))


(defun TransRemove (Action) 
  (prog ()
        (cond ((equal (caadr Action) 'AS)
               (setq Action (list (car Action) (cadadr Action) (caddr Action)))))

        (CMatch `(* (IndexSpec ,(cadaddr Action) ? ? ? ? > P1) *) InfoList)
        (cond ((null (car (Build '(< P1))))
               (return `(ExprStmt (FuncCallP (Id ,(concat '|Sub| (cadaddr Action))) (ParamList (Id |PDMCSchema|) ,(cadr Action))))))
              (t
               (return `(ExprStmt (FuncCallP (Id ,(concat '|Sub| (cadaddr Action))) 
                                             (ParamList (ParamList (Id |PDMCSchema|) ,(cadr Action))
                                                        (Id ,(concat (cadaddr Action) '|Compare|))))))))))


(defun TransCreate (Action)
  (cond ((equal (caadr Action) 'AS)
         (setq Action (list (car Action) (cadadr Action) (caddr Action)))))

  `(ExprStmt (FuncCallP (Id ,(concat '|Create| (cadaddr Action))) (ParamList (Id |PDMCSchema|) ,(cadr Action)))))

               
(defun TransDestroy (Action)
  (cond ((equal (caadr Action) 'AS)
         (setq Action (list (car Action) (cadadr Action) (caddr Action)))))

  `(ExprStmt (FuncCallP (Id ,(concat '|Destroy| (cadaddr Action))) (ParamList (Id |PDMCSchema|) ,(cadr Action)))))


(defun TransAllocate (Action List1 List2)
  (prog (Temp Var Store StructName)
        (cond ((equal (caadr Action) 'AS)
               (setq Action (list (car Action) (cadadr Action) (caddr Action)))))

        (do ((List1 List1 (cdr List1))) ((null List1))
            (if (equal (car List1) (cadadr Action))
                (setq Temp (car List2)))
            (setq List2 (cdr List2)))
        (setq Var (cadr Action) Store (cadaddr Action) StructName Temp)
        (CMatch `(* (Msc ,Temp > P2 > P3) *) InfoList)
        (return `(StmtList
                  (IfElse (EqPred (FieldAcc (Id |PDMCSchema|) (Id ,Store)) (Const "0"))
                          (ExprStmt (AssignOp ,Var (CastExp (TypeSpecListWAbsDecl (StructWId (Id ,StructName)) (Ptr)) 
                                                            (FuncCallP (Id |malloc|) (Id ,(concat Store '|Size|))))))
                          (CompndStmtWSList
                           (StmtList
                            (ExprStmt (AssignOp ,Var (CastExp (TypeSpecListWAbsDecl (StructWId (Id ,StructName)) (Ptr)) 
                                                              (PrimExp (FieldAcc (Id |PDMCSchema|) (Id ,Store))))))
                            (ExprStmt (AssignOp (FieldAcc (Id |PDMCSchema|) (Id ,Store)) 
                                                (FieldAcc (Id |PDMCSchema|) (FieldAcc (Id ,Store) (Id |Next|))))))))
                  (ExprStmt (FuncCallP (Id ,(concat '|Assign| StructName '|Msc|)) (ParamList ,Var (Const ,(car (Build '(< P2)))))))))))




(defun TransAllocateIndirect (Action List1 List2)
  (prog (Temp Var Store StructName)
        (cond ((equal (caadr Action) 'AS)
               (setq Action (list (car Action) (cadadr Action) (caddr Action)))))

        (do ((List1 List1 (cdr List1))) ((null List1))
            (if (equal (car List1) (cadadr Action))
                (setq Temp (car List2)))
            (setq List2 (cdr List2)))
        (setq Var (cadr Action) Store (cadaddr Action) StructName Temp)
        (CMatch `(* (Msc ,Temp > P2 > P3) *) InfoList)
        (return `(StmtList
                  (IfElse (EqPred (FieldAcc (Id |PDMCSchema|) (Id ,Store)) (Const "0"))
                          (ExprStmt (AssignOp (PrimExp (BangOp ,Var)) (CastExp (TypeSpecListWAbsDecl (StructWId (Id ,StructName)) (Ptr)) 
                                                            (FuncCallP (Id |malloc|) (Id ,(concat Store '|Size|))))))
                          (CompndStmtWSList
                           (StmtList
                            (ExprStmt 
									  (AssignOp (PrimExp (BangOp ,Var)) (CastExp (TypeSpecListWAbsDecl (StructWId (Id ,StructName)) (Ptr)) 
                                                              (PrimExp (FieldAcc (Id |PDMCSchema|) (Id ,Store))))))
                            (ExprStmt (AssignOp (FieldAcc (Id |PDMCSchema|) (Id ,Store)) 
                                                (FieldAcc (Id |PDMCSchema|) (FieldAcc (Id ,Store) (Id |Next|))))))))
                  (ExprStmt (FuncCallP (Id ,(concat '|Assign| StructName '|Msc|)) (ParamList ,Var (Const ,(car (Build '(< P2)))))))))))


(defun TransAllocId (Action List1 List2)
  (prog (Temp Var StructName)
        (cond ((equal (caadr Action) 'AS)
               (setq Action (list (car Action) (cadadr Action) (caddr Action)))))

        (do ((List1 List1 (cdr List1))) ((null List1))
            (if (equal (car List1) (cadadr Action))
                (setq Temp (car List2)))
            (setq List2 (cdr List2)))

        (setq Var (cadr Action) StructName Temp)

        (return  `(IfElse (EqPred (Id |PDMCellStore|) (Const "0"))
                          (ExprStmt 
									(AssignOp ,Var (CastExp (TypeSpecListWAbsDecl (StructWId (Id ,StructName)) (PtrPtr (Ptr))) 
																	(FuncCallP (Id |malloc|) (SizeTypeOp (TypeSpecListWAbsDecl (VoidType) (Ptr))))))) 
                          (CompndStmtWSList
                           (StmtList
                            (ExprStmt (AssignOp ,Var (CastExp (TypeSpecListWAbsDecl (StructWId (Id ,StructName)) (PtrPtr (Ptr)))
                                                              (Id |PDMCellStore|))))
                            (ExprStmt (AssignOp (Id |PDMCellStore|) 
																(BangOp (CastExp (TypeSpecListWAbsDecl (VoidType) (PtrPtr (Ptr))) (Id |PDMCellStore|)))))))))))


(defun TransFree (Action)
  (prog ()
        (cond ((equal (caadr Action) 'Id)
               (return (TransFreeCode (cadr Action) (caddr Action))))
              (t
               (return (TransFreeCode (cadadr Action) (caddr Action)))))))



(defun TransFreeCode (Var Store)
  `(StmtList
    (ExprStmt (AssignOp (FieldAcc (PrimExp (CastExp (TypeSpecListWAbsDecl (StructWId (Id |StoreTemplate|)) (Ptr)) ,Var)) (Id |Next|)) 
                        (FieldAcc (Id |PDMCSchema|) ,Store)))
    (ExprStmt (AssignOp (FieldAcc (Id |PDMCSchema|) ,Store) 
								(CastExp (TypeSpecListWAbsDecl (StructWId (Id |StoreTemplate|)) (Ptr)) ,Var)))))



(defun TransFreeIndirect (Action)
  (prog ()
        (cond ((equal (caadr Action) 'Id)
               (return (TransFreeIndirectCode (cadr Action) (caddr Action))))
              (t
               (return (TransFreeIndirectCode (cadadr Action) (caddr Action)))))))



(defun TransFreeIndirectCode (Var Store)
  `(StmtList
    (ExprStmt 
     (AssignOp (FieldAcc 
					 (PrimExp (CastExp (TypeSpecListWAbsDecl (StructWId (Id |StoreTemplate|)) (Ptr)) (PrimExp (BangOp ,Var)))) (Id |Next|)) 
					(FieldAcc (Id |PDMCSchema|) ,Store)))
	 (ExprStmt 
	  (AssignOp 
		(FieldAcc (Id |PDMCSchema|) ,Store) 
		(CastExp (TypeSpecListWAbsDecl (StructWId (Id |StoreTemplate|)) (Ptr)) (PrimExp (BangOp ,Var)))))))



(defun TransFreeId (Action)
  (prog ()
        (cond ((equal (caadr Action) 'Id)
               (return
                `(StmtList (ExprStmt 
									 (AssignOp (BangOp ,(cadr Action))
												  (CastExp 
													(TypeSpecListWAbsDecl (StructWId (Id ,(PathFuncClass (cadr Action)))) (Ptr)) 
													(Id |PDMCellStore|))))
									(ExprStmt (AssignOp (Id |PDMCellStore|) (CastExp (TypeSpecListWAbsDecl (VoidType) (Ptr)) ,(cadr Action)))))))
              (t
               (return
                `(StmtList 
						(ExprStmt
						 (AssignOp (BangOp ,(cadadr Action))
									  (CastExp (TypeSpecListWAbsDecl (StructWId (Id ,(PathFuncClass (cadadr Action)))) (Ptr)) 
												  (Id |PDMCellStore|))))
						(ExprStmt 
						 (AssignOp (Id |PDMCellStore|) (CastExp (TypeSpecListWAbsDecl (VoidType) (Ptr)) ,(cadadr Action))))))))))


(defun TransIf (Action List1 List2)
  (prog ()
        (cond ((equal (caadddr Action) 'ENDIF)
               (return 
                (list 'IfStmt 
                      (CheckMscPred (cadr Action)) 
                      (list 'CompndStmtWSList
                            (ProcessTransAction (caddr Action) List1 List2)))))
              ((equal (caadddr Action) 'ELSE)
               (return
                (list 'IfElse
                      (CheckMscPred (cadr Action))
                      (list 'CompndStmtWSList 
                            (ProcessTransAction (caddr Action) List1 List2))
                      (list 'CompndStmtWSList
                            (ProcessTransAction (cadadddr Action) List1 List2)))))
              (t
               (return
                (list 'IfElse
                      (CheckMscPred (cadr Action))
                      (list 'CompndStmtWSList 
                            (ProcessTransAction (caddr Action) List1 List2)) 
                      (TransIf (cadddr Action) List1 List2)))))))


(defun CheckMscPred (Pred)
  (prog ()
        (CMatch (list '* (list 'Msc (cadaddr Pred) '> 'P1 '> 'P2) '*) InfoList)
        (cond ((equal (car Pred) 'INPred)
               (return 
               (ProcessIndexSpecCode (list 'BitAndOp 
                      (list 'At (cadr Pred) '(Id |Msc|)) 
                      (cons 'Constant (cons 'Integer (Build '(< P2))))))))
              ((equal (car Pred) 'ISPred)
               (return 
              (ProcessIndexSpecCode  (list 'EqPred 
                      (list 'At (cadr Pred) '(Id |Msc|)) 
                      (cons 'Constant (cons 'Integer (Build '(< P1))))))))
              (t
               (PrintMsg "*****warning: from CheckMscPred")))))




(defun TransColonEq (Code L1 L2)
  (prog (Temp In1 In2 Cast)

        (setq In1 (car Code) In2 (cadr Code))

        (cond ((equal (car In2) 'AS)
               (setq Cast (caddr In2))
               (setq In2 (cadr In2))))

        (cond ((equal (car In1) 'Id)
               (setq In2 (ProcessIndexSpecCode In2))

               (cond ((not (null Cast))
                      (CMatch `(* (Reference ,(cadr Cast) > P1) *) InfoList)
                      (cond ((equal (car (Build '(< P1))) 'Direct)
                             (setq In2 `(CastExp (TypeSpecListWAbsDecl (StructWId ,Cast) (Ptr)) ,In2)))
                            (t
                             (setq In2 `(CastExp (TypeSpecListWAbsDecl (StructWId ,Cast) (PtrPtr (Ptr))) ,In2))))))
               (return
                `(ExprStmt (AssignOp ,In1 ,In2))))

              (t 
               (do ((L1 L1 (cdr L1)) (L2 L2 (cdr L2))) ((null L1))
                   (cond ((equal (cadadar Code) (car L1)) (setq Temp (car L2)))))

               (return `(ExprStmt (FuncCallP (Id ,(concat '|Assign| Temp (cadaddar Code))) 
                                             (ParamList ,(cadar Code) ,(ProcessIndexSpecCode (cadr Code))))))))))



(defun TransColonEqId (Code L1 L2)
  L1
  L2
  (prog (In1 In2)


        (setq In1 (car Code) In2 (ProcessIndexSpecCode (cadr Code)))

        (cond ((equal (caadr Code) 'Id)
               (return `(ExprStmt (AssignOp (PrimExp (BangOp ,In1)) 
                                            (CastExp 
                                             (TypeSpecListWAbsDecl (StructWId (Id ,(PathFuncClass In1))) (Ptr))
                                             (PrimExp (BangOp ,In2)))))))
              (t
               (return `(ExprStmt (AssignOp (PrimExp (BangOp ,In1)) 
                                            (CastExp 
                                             (TypeSpecListWAbsDecl (StructWId (Id ,(PathFuncClass In1))) (Ptr))
                                             (PrimExp (BangOp (PrimExp ,In2)))))))))))


;***********************************************************************************************************************************
;***********************************************************************************************************************************


(defun SetQuery (PDMCQuery)
  (prog (Code CurrentQuery BodyList BodyCode Temp NodeList Refer ExternalPoints LevelCounter Num1 Num2)
       (setq Code `(Comment "========== Queries ====================="))
       (PrintMsg "   processing queries.")

       (do ((PDMCQuery PDMCQuery (cdr PDMCQuery))) ((null PDMCQuery))
           (princ "      query: " *error-output*)
           (PrintMsg (cadadar PDMCQuery))

            (setq CurrentQuery (cadadar PDMCQuery)) 
            
            ;; set up the ScopeList for variables in the query
            ;; put Given in ScopeList
            (setq Temp nil)
            (do ((L1 (RestoreList (cadaddar PDMCQuery)) (cdr L1)) (L2 (RestoreList (caddaddar PDMCQuery)) (cdr L2))) ((null L1))
                (setq Temp (append1 Temp (list (car L1) (car L2)))))
            (setq ScopeList Temp)

            ;; put Select in ScopeList
            (setq Temp nil)
            (do ((L1 (RestoreList (cadadddar PDMCQuery)) (cdr L1)) (L2 (RestoreList (caddadddar PDMCQuery)) (cdr L2))) ((null L1))
                (setq Temp (append1 Temp (list (car L1) (car L2)))))
            (setq ScopeList (append ScopeList Temp))

            ;; put Declare in ScopeList
            (setq Temp nil)
            (do ((L1 (RestoreList (cadaddddar PDMCQuery)) (cdr L1)) (L2 (RestoreList (caddaddddar PDMCQuery)) (cdr L2))) ((null L1))
                (setq Temp (append1 Temp (list (car L1) (car L2)))))
            (setq ScopeList (list (append ScopeList Temp)))


            ;; set up the NodeList (set up number labels for boxes)
            (setq LevelCounter 5)
            (setq NodeList (cons '(ExternalPoints 1 2 3 4) (TravelQueryBody 1 2 3 4 (cadddddar PDMCQuery) nil)))
            (do () ((not (Match '(>* Front (Connect > P1 > P2) >* Back) NodeList)))
                (setq NodeList (Build '(<< Front << Back))
                      Num1 (car (Build '(< P1))) 
                      Num2 (car (Build '(< P2))))
                (and (> Num1 0) (> Num2 0) (setq NodeList (subst (min Num1 Num2) (max Num1 Num2) NodeList)))) 



           (setq Refer nil)
           (SetRefer 1 'Put)

           ;;set up BodyList (produce actual code for each operation like "IndexInit", "Select"....)
           (setq BodyList (list (list 3 (SetRefer 2 'Put) '(2) 
                                      `(StmtList 
                                        (ExprStmt (AssignOp (FieldAcc (Id |PDMCQStruct|) (Id |Result|)) (Const "1")))
                                        (ReturnStmt)))))

           (do ((NodeList NodeList (cdr NodeList))) ((null NodeList))
               (cond ((equal (caar NodeList) 'ExternalPoints)
                      (setq ExternalPoints (car NodeList)))

                     ((equal (caar NodeList) 'Assignment)
                      (SetRefer (cadadar NodeList) 'Put)
                      (setq BodyList (append1 BodyList (cadar NodeList))))

                     ((equal (caar NodeList) 'AssignmentIn)
                      (SetRefer (caddar NodeList) 'Put)
                      (SetRefer (cadddar NodeList) 'Put)
                      (setq BodyList (append1 BodyList `( ,(cadar NodeList)
                                                          ,(cadddar NodeList)
                                                          (,(caddar NodeList) ,(cadddar NodeList))
                                                          ,(caddddar NodeList)))))

                     ((equal (caar NodeList) 'IndexInit)
                      (setq BodyList (append1 BodyList (QueryIndexInitNext (car NodeList) '|Init|))))
                     ((equal (caar NodeList) 'IndexNext)
                      (setq BodyList (append1 BodyList (QueryIndexInitNext (car NodeList) '|Next|))))
                     ((equal (caar NodeList) 'Select)
                      (SetRefer (caddar NodeList) 'Put)
                      (SetRefer (cadddar NodeList) 'Put)
                      (setq BodyList (append1 BodyList (list (cadar NodeList) (cadddar NodeList) 
                                                             (list (caddar NodeList) (cadddar NodeList)) (caddddar NodeList)))))
                     ((equal (caar NodeList) 'Cut)
                      (SetRefer (caddar NodeList) 'Put)
                      (setq BodyList (append1 BodyList (list (cadar NodeList) (caddar NodeList)
                                                             (list (caddar NodeList)) (cadddar NodeList)))))))

           (SetRefer (caddddr ExternalPoints) 'Remove)


           ;;rearrange code to reduce the total number of "goto"s and "label"s
           (setq BodyCode (ArrangeQueryBody BodyList 1))


           (setq BodyCode `(StmtList 
                            (StmtList 
                             (IfStmt (EqPred (FieldAcc (Id |PDMCQStruct|) (Id |First|)) (Const "0")) (Goto (Id 2)))
                             (ExprStmt (AssignOp (FieldAcc (Id |PDMCQStruct|) (Id |First|)) (Const "0"))))
                            ,BodyCode))

           (setq BodyCode `(StmtList ,BodyCode 
                                    (LabeledStmt (Id ,(caddddr ExternalPoints)) 
                                                 (StmtList (ExprStmt (AssignOp (FieldAcc (Id |PDMCQStruct|) (Id |Result|)) (Const "0")))
                                                           (ReturnStmt)))))

           ;;change number labels to actual labels
           (do ((Num 1 (add1 Num))) ((equal Num LevelCounter))
               (setq BodyCode (subst (GenerateName 'Label) Num BodyCode)))
        
           (setq Code `(File ,Code
                             (InlineFuncDefnWDeclSpec 
                              (VoidType) (FuncVarWPIdList (Id ,CurrentQuery) (IdList (Id |PDMCSchema|) (Id |PDMCQStruct|)))
                              (FuncBodyWDeclList 
                               (DeclList 
                                (DeclSpecWVars (StructWId (Id ,(concat SchemaName '|Struct|))) (PtrVar (Ptr) (Id |PDMCSchema|)))
                                (DeclSpecWVars (StructWId (Id ,(concat CurrentQuery '|Struct|))) (PtrVar (Ptr) (Id |PDMCQStruct|))))
                               (CompndStmtWSList ,BodyCode))))))
       (return Code)))



(defun TravelQueryBody (In1 In2 In3 In4 QueryBody NodeList)
  (prog (Temp1 Temp2)
        (cond ((equal 'Join (car QueryBody))
               (setq Temp1 LevelCounter)
               (setq LevelCounter (add1 LevelCounter))
               (setq Temp2 LevelCounter)
               (setq LevelCounter (add1 LevelCounter))
               (return (append (TravelQueryBody In1 Temp1 Temp2 In4 (cadr QueryBody) NodeList)
                               (TravelQueryBody Temp2 In2 In3 Temp1 (caddr QueryBody) NodeList))))

              ((equal 'Select (car QueryBody))
               (setq Temp1 LevelCounter)
               (setq LevelCounter (add1 LevelCounter))
               (return (TravelQueryBody In1 In2 Temp1 In4 (caddr QueryBody) 
                                        (append1 NodeList (list 'Select Temp1 In3 In2 
                                                                `(IfStmt ,(ProcessIndexSpecCode (CheckStringPred (cadr QueryBody)))
                                                                     (Goto (Id ,In3))))))))

              ((equal 'Compliment (car QueryBody))
               (return (TravelQueryBody In1 0 In4 In3 (cadr QueryBody) (append1 NodeList (list 'Connect In2 In4)))))

              ((equal 'Cut (car QueryBody))
               (setq Temp1 LevelCounter)
               (setq LevelCounter (add1 LevelCounter))
               (return (TravelQueryBody Temp1 In2 In3 In4 (caddr QueryBody) 
                                        (append1 NodeList (list 'Cut In1 Temp1 
                                                                `(ExprStmt 
                                                                  (AssignOp 
                                                                   (FieldAcc (Id |PDMCQStruct|) 
                                                                             (Id ,(concat (cadr QueryBody) '|Cut|))) 
                                                                   (Const "1")))))))) 

              ((equal 'NullTuple (car QueryBody))
               (return (append1 (append1 NodeList (list 'Connect In1 In3)) (list 'Connect In2 In4))))

              ((equal 'Assign (car QueryBody))
               (cond ((equal (length QueryBody) 3)
                      (cond ((equal (caadr QueryBody) 'At) (PrintMsg "*****warning: from TravelQueryBody")))
                      (setq Temp1 (ProcessIndexSpecCode `(ExprStmt (AssignOp ,(cadr QueryBody) ,(caddr QueryBody))))) 
                      (do ((Temp2 (car ScopeList) (cdr Temp2))) ((null Temp2))
                          (setq Temp1 (subst `(FieldAcc (Id |PDMCQStruct|) (Id ,(caar Temp2))) `(Id ,(caar Temp2)) Temp1 :test #'equal)))
                      
                      (setq Temp1
                            (append1 
                             (append1 
                              NodeList 
                              `(Assignment (,In1 ,In3 (,In3) ,Temp1)))
                             (list 'Connect In2 In4))))
                     (t
                      (CMatch `(* (Msc ,(cadadddr QueryBody) > P1 > P2) *) InfoList)
                      (CMatch `(* (Reference ,(cadadddr QueryBody) > P3) *) InfoList)
                      (cond ((equal (car (Build '(< P3))) 'Direct)
                             (setq Temp2 '(Ptr)))
                            (t
                             (setq Temp2 '(PtrPtr (Ptr))))) 
                      (setq Temp1 (ProcessIndexSpecCode
                                   `(IfStmt (NEPred 
                                         (PrimExp
                                          (BitAndOp
                                           (FuncCallP 
                                            (Id ,(concat '|Access| (PathFuncClass (caddr QueryBody)) '|Msc|))
                                            ,(ProcessIndexSpecCode (caddr QueryBody)))
                                           (Const ,(car (Build '(< P2))))))
                                         (Const "0"))
                                        (CompndStmtWSList
                                         (StmtList
                                          (ExprStmt (AssignOp ,(cadr QueryBody) 
                                                               (CastExp 
                                                                (TypeSpecListWAbsDecl (StructWId ,(cadddr QueryBody)) ,Temp2)
                                                                (PrimExp,(ProcessIndexSpecCode (caddr QueryBody))))))
                                          (Goto (Id ,In3)))))))

                      (do ((Temp2 (car ScopeList) (cdr Temp2))) ((null Temp2))
                          (setq Temp1 (subst `(FieldAcc (Id |PDMCQStruct|) (Id ,(caar Temp2))) `(Id ,(caar Temp2)) Temp1 :test #'equal)))


                     
                      (setq Temp1
                            (append1
                             (append1
                              NodeList
                              `(AssignmentIn ,In1 ,In3 ,In4 ,Temp1))
                             (list 'Connect In2 In4)))))

               (return Temp1))


              ((member (car QueryBody) '(AssignIndexFirst AssignIndexFirstCond))
               (return (append1 (append1 NodeList (list 'IndexInit In1 In3 In4 QueryBody)) (list 'Connect In2 In4))))

              (t
               (return (append1 
                        (append1 NodeList (list 'IndexInit In1 In3 In4 QueryBody)) (list 'IndexNext In2 In3 In4 QueryBody)))))))





(defun QueryIndexInitNext (Node Command)
  (prog (DistributedOn DistributedCond OrderBy Argument FuncName CondClause Temp)

        (CMatch `(* (IndexSpec ,(cadaddaddddr Node) ? ? > P1 ? > P2) *) InfoList)
        (setq DistributedOn (car (Build '(< P1))) OrderBy (car (Build '(< P2))))
 
        (cond ((member (caaddddr Node) '(AssignIndexFirstCond AssignIndexEachCond))
               (setq CondClause (cadddaddddr Node))))

        (setq FuncName Command)

        (cond ((and (not (null DistributedOn)) (not (null CondClause)))
               (setq FuncName (concat '|Dist| Command))
               (cond ((equal (car CondClause) 'AndPred)
                      (setq DistributedCond (cadr CondClause))
                      (setq CondClause (caddr CondClause)))
                     (t
                      (setq DistributedCond CondClause)
                      (setq CondClause nil)))))

        (cond ((not (null OrderBy))
               (setq Argument 
							`(ArgExpList (Id ,(SetSpecialCompareFunc (cadaddaddddr Node) CondClause)) (Id |PDMCQStruct|)))))

        (cond ((member FuncName '(|DistInit| |DistNext|))
               (setq Temp (ProcessIndexSpecCode (caddr DistributedCond)))
               (do ((ScopeList (car ScopeList) (cdr ScopeList))) ((null ScopeList))
                   (setq Temp (subst `(FieldAcc (Id |PDMCQStruct|) (Id ,(caar ScopeList))) `(Id ,(caar ScopeList)) Temp :test #'equal)))
               (cond ((null Argument)
                      (setq Argument Temp))
                     (t
                      (setq Argument `(ArgExpList ,Temp ,Argument))))))

        (cond ((null Argument)
               (setq Argument 
                     `(ArgExpList (Id |PDMCSchema|) (AddrOp (PrimExp (FieldAcc (Id |PDMCQStruct|) (Id ,(cadadaddddr Node))))))))
              (t
               (setq Argument `(ArgExpList (Id |PDMCSchema|) 
                                        (ArgExpList (AddrOp (PrimExp (FieldAcc (Id |PDMCQStruct|) (Id ,(cadadaddddr Node)))))
                                                    ,Argument)))))
        (cond ((member FuncName '(|Init| |DistInit|))
               (return
                (list
                 (cadr Node)
                 (SetRefer (cadddr Node) 'Put)
                 (list (cadddr Node) (caddr Node))
                 `(StmtList
                   (ExprStmt (AssignOp (FieldAcc (Id |PDMCQStruct|) (Id ,(concat (cadadaddddr Node) '|Cut|))) (Const "0")))
                   (IfStmt (FuncCallP (Id ,(concat FuncName (cadaddaddddr Node))) ,Argument)
                       (Goto (Id ,(SetRefer (caddr Node) 'Put))))))))
              (t
               (return
                (list
                 (cadr Node)
                 (SetRefer (cadddr Node) 'Put)
                 (list (cadddr Node) (cadddr Node) (caddr Node))
                 `(StmtList 
                   (IfStmt (FieldAcc (Id |PDMCQStruct|) (Id ,(concat (cadadaddddr Node) '|Cut|)))
                       (Goto (Id ,(SetRefer (cadddr Node) 'Put))))
                   (IfStmt (FuncCallP (Id ,(concat FuncName (cadaddaddddr Node))) ,Argument)
                       (Goto (Id ,(SetRefer (caddr Node) 'Put)))))))))))







(defun ArrangeQueryBody (BodyList Num)
  (prog (Exit Code Temp)
        (cond ((Match (list '>* 'L1 (list Num '> 'P1 '> 'P2 '> 'P3) '>* 'L2) BodyList)
               (setq BodyList (Build '(<< L1 << L2)) 
                     Exit (car (Build '(< P1)))
                     Code (Build '(<< P3)))
               (SetRefer (Build '(<< P2)) 'Sub)
               (SetRefer Num 'Remove)
               (if (not (SetRefer Num 'Get)) (setq Code (list 'LabeledStmt (list 'Id Num) Code))))
              (t
               (setq Temp '(-1 100000))
               (do ((Refer Refer (cdr Refer))) ((null Refer))
                   (and (equal (cadddar Refer) 'Unexplored) (lessp (caddar Refer) (cadr Temp))
                        (setq Temp (list (caar Refer) (caddar Refer)))))
               (setq Num (car Temp))
               (CMatch (list '>* 'L1 (list (car Temp) '> 'P1 '> 'P2 '> 'P3) '>* 'L2) BodyList)
               (setq BodyList (Build '(<< L1 << L2)) 
                     Exit (car (Build '(< P1)))
                     Code (list 'LabeledStmt (list 'Id (car Temp)) (Build '(<< P3))))
               (SetRefer (Build '(<< P2)) 'Sub)
               (SetRefer (car Temp) 'Remove)))

        (and (not (Match (list '* (list Exit '? '? '?) '*) BodyList))
             (not (equal Num 3))
             (setq Code (list 'StmtList Code (list 'Goto (list 'Id Exit)))))

        (cond ((null BodyList)
               (return Code))
              (t
               (return (list 'StmtList Code (ArrangeQueryBody BodyList Exit)))))))


(defun SetRefer (Num Op)
  (prog ()
        (cond ((equal Op 'Put)
               (cond ((Match (list '>* 'L1 (list Num '> 'P1 '? '> 'P2) '>* 'L2) Refer)
                      (setq Refer (append1 (Build '(<< L1 << L2)) (list Num (add1 (car (Build '(< P1)))) 
                                                                        (add1 (car (Build '(< P1)))) (car (Build '(< P2)))))))
                     (t
                      (setq Refer (append1 Refer (list Num 1 1 'Unexplored)))))
               (return Num))
              ((equal Op 'Get)
               (CMatch (list '>* 'L1 (list Num '> 'P '? '?) '>* 'L2) Refer)
               (return (equal 1 (car (Build '(< P))))))
              ((equal Op 'Remove)
               (CMatch (list '>* 'L1 (list Num '> 'P1 '> 'P2 '?) '>* 'L2) Refer)
               (setq Refer (append1 (Build '(<< L1 << L2)) (list Num (car (Build '(< P1))) (car (Build '(< P2))) 'Explored))))
              ((equal Op 'Sub)
               (do ((Num Num (cdr Num))) ((null Num))
                   (CMatch (list '>* 'L1 (list (car Num) '> 'P1 '> 'P2 '> 'P3) '>* 'L2) Refer)
                   (setq Refer (append1 (Build '(<< L1 << L2)) (list (car Num) (car (Build '(< P1))) 
                                                                     (sub1 (car (Build '(< P2)))) (car (Build '(< P3)))))))))))



;***********************************************************************************************************************************
;***********************************************************************************************************************************


(defun SetBasicCompareFuncs (Index)
  (prog (IndexName OnClass OrderBy Code)
        (PrintMsg "   generating basic comparison functions.")
        (do ((Index Index (cdr Index))) ((null Index))
            (setq IndexName (cadar Index) OnClass (caddar Index) OrderBy (RestoreIdList (caddddddar Index)))
            (cond ((not (null OrderBy))
                   (setq Code (CompareFuncStmt OrderBy OnClass))
                   (setq Code
                         `(InlineFuncDefnWDeclSpec 
                           (IntType)
                           (FuncVarWPIdList (Id ,(concat IndexName '|Compare|))
                                            (IdList (Id P1) (Id P2)))
                           (FuncBodyWDeclList
                            ,(ProcessIndexSpecCode 
                              `(DeclSpecWVars (Prop (Id ,OnClass)) (InitDeclList (Id P1) (Id P2))))
                            (CompndStmtWSList ,Code))))
                   (cond ((null CompareFuncCode)
                          (setq CompareFuncCode Code))
                         (t
                          (setq CompareFuncCode `(File ,CompareFuncCode ,Code)))))))))





(defun CompareFuncStmt (OrderBy OnClass)
  (prog (LessThan GreaterThan)
        (cond ((null OrderBy)
               (return `(StmtList (StmtList (IfStmt (LTPred (Id P1) (Id P2)) (ReturnWExp (PrimExp (UnSubOp (Const "1")))))
                                            (IfStmt (GTPred (Id P1) (Id P2)) (ReturnWExp (PrimExp (Const "1")))))
                                  (ReturnWExp (PrimExp (Const "0"))))))
              (t
               (cond ((equal (caar OrderBy) 'Id)
                      (CMatch `(* (Msc ,(cadar OrderBy) > P2 > P3) *) InfoList)
                      (return
                       `(IfElse
                         (OrPred
                          (PrimExp (EqPred (PrimExp (BitAndOp (FuncCallP (Id ,(concat '|Access| OnClass '|Msc|)) (Id P1))
                                                              (Const ,(car (Build '(< P3)))))) (Const "0")))
                          (PrimExp (EqPred (PrimExp (BitAndOp (FuncCallP (Id ,(concat '|Access| OnClass '|Msc|)) (Id P2))
                                                              (Const ,(car (Build '(< P3)))))) (Const "0"))))
                         (CompndStmtWSList
                          (StmtList
                           (StmtList
                            (StmtList
                             (StmtList
                              (IfStmt
                               (NEPred (PrimExp (BitAndOp (FuncCallP (Id ,(concat '|Access| OnClass '|Msc|)) (Id P1))
                                                          (Const ,(car (Build '(< P3)))))) (Const "0"))
                               (ReturnWExp (PrimExp (UnSubOp (Const "1")))))
                              (IfStmt
                               (NEPred (PrimExp (BitAndOp (FuncCallP (Id ,(concat '|Access| OnClass '|Msc|)) (Id P2))
                                                          (Const ,(car (Build '(< P3)))))) (Const "0"))
                               (ReturnWExp (PrimExp (Const "1")))))
                             (IfStmt (LTPred (Id P1) (Id P2)) (ReturnWExp (PrimExp (UnSubOp (Const "1"))))))
                            (IfStmt (GTPred (Id P1) (Id P2)) (ReturnWExp (PrimExp (Const "1")))))
                           (ReturnWExp (PrimExp (Const "0")))))
                         (CompndStmtWSList
                          ,(CompareFuncStmt (cdr OrderBy) (cadar OrderBy))))))
                     (t
                      (cond ((equal (caar OrderBy) 'ASC)
                             (setq LessThan 'LTPred GreaterThan 'GTPred))
                            ((equal (caar OrderBy) 'DESC)
                             (setq LessThan 'GTPred GreaterThan 'LTPred)))
                      (CMatch `(* (Type ,(cadadar OrderBy) > P1 *) *) InfoList)
                      (cond ((equal (Build '(< P1)) '(String))
                             (return 
                              `(StmtList 
                                (StmtList
                                 (IfStmt (,LessThan 
                                      (FuncCallP (Id |strcmp|)
                                                 (ArgExpList 
                                                  (FuncCallP (Id ,(concat '|Access| OnClass (cadadar OrderBy))) (Id P1))
                                                  (FuncCallP (Id ,(concat '|Access| OnClass (cadadar OrderBy))) (Id P2))))
                                      (Const "0"))
                                     (ReturnWExp (PrimExp (UnSubOp (Const "1")))))
                                 (IfStmt (,GreaterThan 
                                      (FuncCallP (Id |strcmp|)
                                                 (ArgExpList 
                                                  (FuncCallP (Id ,(concat '|Access| OnClass (cadadar OrderBy))) (Id P1))
                                                  (FuncCallP (Id ,(concat '|Access| OnClass (cadadar OrderBy))) (Id P2))))
                                      (Const "0"))
                                     (ReturnWExp (PrimExp (Const "1")))))
                                ,(CompareFuncStmt (cdr OrderBy) OnClass))))
                            (t
                             (return
                              `(StmtList
                                (StmtList
                                 (IfStmt (, LessThan
                                        (FuncCallP (Id ,(concat '|Access| OnClass (cadadar OrderBy))) (Id P1))
                                        (FuncCallP (Id ,(concat '|Access| OnClass (cadadar OrderBy))) (Id P2)))
                                     (ReturnWExp (PrimExp (UnSubOp (Const "1")))))
                                 (IfStmt (, GreaterThan
                                        (FuncCallP (Id ,(concat '|Access| OnClass (cadadar OrderBy))) (Id P1))
                                        (FuncCallP (Id ,(concat '|Access| OnClass (cadadar OrderBy))) (Id P2)))
                                     (ReturnWExp (PrimExp (Const "1")))))
                                ,(CompareFuncStmt (cdr OrderBy) OnClass)))))))))))







(defun SetSpecialCompareFunc (IndexName Cond)
  (prog (Class Code Temp FuncName FirstArg SecondArg Stmt1 Stmt2 Stmt3 Stmt4 Stmt5 OrderBy Return1 Return2)
        (cond ((Match `(* (CompareFuncName ,IndexName ,Cond > P1) *) InfoList)
               (return (car (Build '(< P1)))))
              (t
               (setq FuncName (GenerateName 'Compare))
               (setq InfoList (append1 InfoList `(CompareFuncName ,IndexName ,Cond ,FuncName)))
               (CMatch `(* (IndexSpec ,IndexName > P1 ? ? ? > P2) *) InfoList)
               (setq Class (car (Build '(< P1))))
               (setq OrderBy (RestoreIdList (Build '(<< P2))))
               
               (setq Code nil)

               (do ((Cond (RestoreAndPredList Cond) (cdr Cond)) (OrderBy OrderBy (cdr OrderBy))) ((null Cond))
                   (cond ((member (caar Cond) '(EqPred LTPred GTPred LEPred GEPred NEPred))

                          (setq FirstArg (ProcessIndexSpecCode (caddar Cond)))
                          (setq SecondArg (ProcessIndexSpecCode (cadar Cond)))

                          (cond ((equal (caar OrderBy) 'ASC)
                                 (setq Return1 `(ReturnWExp (PrimExp (Const "1"))))
                                 (setq Return2 `(ReturnWExp (PrimExp (UnSubOp (Const "1"))))))
                                (t
                                 (setq Return2 `(ReturnWExp (PrimExp (Const "1"))))
                                 (setq Return1 `(ReturnWExp (PrimExp (UnSubOp (Const "1")))))))

                          (do ((ScopeList (car ScopeList) (cdr ScopeList))) ((null ScopeList))
                              (setq FirstArg (subst `(FieldAcc (Id |PDMCQStruct|) (Id ,(caar ScopeList))) `(Id ,(caar ScopeList)) FirstArg :test #'equal))
                              (setq SecondArg (subst `(Id P) `(Id ,(caar ScopeList)) SecondArg :test #'equal)))

                          (CMatch `(* (Type ,(cadaddadar Cond) > P1 *) *) InfoList)
                          (cond ((equal (Build '(< P1)) '(String))
                                 (setq Stmt1  `(LTPred (FuncCallP (Id |strcmp|) (ArgExpList ,FirstArg ,SecondArg)) (Const "0")))
                                 (setq Stmt2  `(LEPred (FuncCallP (Id |strcmp|) (ArgExpList ,FirstArg ,SecondArg)) (Const "0")))
                                 (setq Stmt3  `(EqPred (FuncCallP (Id |strcmp|) (ArgExpList ,FirstArg ,SecondArg)) (Const "0")))
                                 (setq Stmt4  `(GEPred (FuncCallP (Id |strcmp|) (ArgExpList ,FirstArg ,SecondArg)) (Const "0")))
                                 (setq Stmt5  `(GTPred (FuncCallP (Id |strcmp|) (ArgExpList ,FirstArg ,SecondArg)) (Const "0"))))
                                (t
                                 (setq Stmt1 `(LTPred ,FirstArg ,SecondArg))
                                 (setq Stmt2 `(LEPred ,FirstArg ,SecondArg))
                                 (setq Stmt3 `(EqPred ,FirstArg ,SecondArg))
                                 (setq Stmt4 `(GEPred ,FirstArg ,SecondArg))
                                 (setq Stmt5 `(GTPred ,FirstArg ,SecondArg))))

                          (cond ((equal (caar Cond) 'EqPred)
                                 (setq Temp `(StmtList (IfStmt ,Stmt1 ,Return2) (IfStmt ,Stmt5 ,Return1))))
                                ((equal (caar Cond) 'LTPred)
                                 (setq Temp `(IfStmt ,Stmt2 ,Return2)))
                                ((equal (caar Cond) 'GTPred)
                                 (setq Temp `(IfStmt ,Stmt4 ,Return1)))
                                ((equal (caar Cond) 'LEPred)
                                 (setq Temp `(IfStmt ,Stmt1 ,Return2)))
                                ((equal (caar Cond) 'GEPred)
                                 (setq Temp `(IfStmt ,Stmt5 ,Return1)))
                                (t
                                 (PrintMsg "*****warning: from SetSpecialCompareFunc"))))

                         ((equal (caar Cond) 'INPred)
                          (CMatch `(* (Msc ,(cadaddar Cond) > P1 > P2) *) InfoList)
                          (setq Temp `(IfStmt (EqPred (PrimExp (BitAndOp (FuncCallP (Id ,(concat '|Access| Class '|Msc|)) (Id P))
                                                                     (Const ,(car (Build '(< P2)))))) (Const "0"))
                                          (ReturnWExp (PrimExp (UnSubOp (Const "1")))))))

                   
                         ((equal (caar Cond) 'ISPred)
                          (PrintMsg "*****warning: from SetSpecialCompareFunc"))
                         (t 
                          (PrintMsg "*****warning: from SetSpecialCompareFunc")))

                   (cond ((null Code)
                          (setq Code Temp))
                         (t
                          (setq Code `(StmtList ,Code ,Temp)))))

               (cond ((null Code)
                      (setq Code `(ReturnWExp (PrimExp (Const "0")))))
                     (t
                      (setq Code `(StmtList ,Code (ReturnWExp (PrimExp (Const "0")))))))
        
               (setq Code
                     `(InlineFuncDefnWDeclSpec 
                       (IntType)
                       (FuncVarWPIdList (Id ,FuncName)
                                        (IdList (Id P) (Id |PDMCQStruct|)))
                       (FuncBodyWDeclList
                        ,(ProcessIndexSpecCode 
                          `(DeclList 
                            (DeclSpecWVars (Prop (Id ,Class)) (Id P))
                            (DeclSpecWVars (StructWId (Id ,(concat CurrentQuery '|Struct|))) (PtrVar (Ptr) (Id |PDMCQStruct|)))))
                        (CompndStmtWSList ,Code))))
               (cond ((null CompareFuncCode)
                      (setq CompareFuncCode Code))
                     (t
                      (setq CompareFuncCode `(File ,CompareFuncCode ,Code))))
        
               (return FuncName)))))



;***********************************************************************************************************************************
;***********************************************************************************************************************************


(defun SetIndex (Code Index)
  (prog (Port IndexCode T1 T2 T3 M1 M2 SubstitutionMatch DistFunction)
        (PrintMsg "   processing indices.")
        (do ((Index Index (cdr Index))) ((null Index))

            (princ "      index: " *error-output*)
            (PrintMsg (cadar Index))
            (setq Port (open (concatenate 'string (string (cadddar Index)) ".internal")))
            (setq IndexCode (read Port))
            (close Port)
            (setq T1 (cadadr IndexCode) T2 (caddr IndexCode) T3 (cadddr IndexCode))
            (cond ((not (equal T1 (cadddar Index)))
                   (ErrorMsg `("***PDMC Error: Index names not match between" ,T1 ,(cadddar Index)))))

				(cond ((not (null (caddddar Index))) 
						 (setq DistFunction (DistAccessCode (RestoreAtList (caddddar Index)) (caddar Index) (cadar Index))))
						(t
						 (setq DistFunction nil)))


            (setq SubstitutionMatch nil M1 nil M2 nil)
            (do ((T2 (cdr T2) (cdr T2))) ((null T2))
                (cond ((null (car T2))
                       (setq M1 (append1 M1 nil)))
                      (t
                       (setq M1 (append1 M1 (cadar T2))))))
            (setq M2 (list SchemaName (cadar Index) (caddar Index) (car DistFunction) (cadddddar Index)))
            (do ((M1 M1 (cdr M1)) (M2 M2 (cdr M2))) ((null M1))
                (and (or (and (null (car M1)) (not (null (car M2))))
                         (and (null (car M2)) (not (null (car M1)))))
                     (ErrorMsg `("***PDMC Error: Index generic names matching error")))
                (cond ((not (null (car M1)))
                       (setq SubstitutionMatch (append1 SubstitutionMatch (list (car M1) (car M2)))))))

            (setq Code `(File ,Code (Comment "index====================================")))

				(cond ((not (null DistFunction))
						 (setq Code `(File ,Code ,(cadr DistFunction)))))

            (setq Code `(File ,Code ,(ProcessIndexSpecCode T3))))
        (return Code)))



(defun DistAccessCode (Path DistClass IndexName)
  (prog (Code IndexClass Pointer)
		  (setq Code '(Id P) IndexClass DistClass)
        (do ((Path Path (cdr Path))) ((null Path))
				(CMatch `(* (Type ,DistClass > P1 *) *) InfoList)
				(setq Code `(FuncCallP (Id ,(concat '|Access| (car (Build '(< P1))) (car Path))) ,Code))
				(setq DistClass (car Path)))
		  (setq Code `(CompndStmtWSList (ReturnWExp (PrimExp ,Code))))
        (CMatch `(* (Reference ,IndexClass > P1) *) InfoList)
        (cond ((equal (car (Build '(< P1))) 'Direct)
					(setq Pointer '(Ptr)))
				  (t
					(setq Pointer '(PtrPtr (Ptr)))))
		  (setq Code `(FuncBodyWDeclList (DeclSpecWVars (StructWId (Id ,IndexClass)) (PtrVar ,Pointer (Id P))) ,Code))
		  (CMatch `(* (Type ,DistClass > P1 *) *) InfoList)
        (CMatch `(* (Reference ,(car (Build '(< P1))) > P2) *) InfoList)
        (cond ((equal (car (Build '(< P2))) 'Direct)
					(setq Pointer '(Ptr)))
				  (t
					(setq Pointer '(PtrPtr (Ptr)))))
		  (setq Code `(InlineFuncDefnWDeclSpec 
							(StructWId (Id ,(car (Build '(< P1))))) 
							(PtrVar ,Pointer (FuncVarWPIdList (Id ,(concat '|DistPath| IndexName)) (Id P))) ,Code))
		  
		  (return (list DistClass Code))))


(defun RestoreAtList (Code)
  (prog ()
		  (cond ((equal (car Code) 'Id)
					(return (list (cadr Code))))
				  (t
					(return (append1 (RestoreAtList (cadr Code)) (cadaddr Code)))))))


;***********************************************************************************************************************************
;***********************************************************************************************************************************




(defun ProcessIndexSpecCode (IndexSpecCode)
  (prog ()
        (cond  ((equal 1 (CheckKeyWord (car IndexSpecCode)))
                (return (list (car IndexSpecCode) 
                              (ProcessIndexSpecCode (cadr IndexSpecCode)))))
               ((equal 2 (CheckKeyWord (car IndexSpecCode)))
                (return (list (car IndexSpecCode) (ProcessIndexSpecCode (cadr IndexSpecCode)) 
                              (ProcessIndexSpecCode (caddr IndexSpecCode)))))
               ((equal 3 (CheckKeyWord (car IndexSpecCode)))
                (return (list (car IndexSpecCode) 
                              (ProcessIndexSpecCode (cadr IndexSpecCode)) 
                              (ProcessIndexSpecCode (caddr IndexSpecCode)) 
                              (ProcessIndexSpecCode (cadddr IndexSpecCode)))))
               ((equal 4 (CheckKeyWord (car IndexSpecCode)))
                (return (list (car IndexSpecCode) 
                              (ProcessIndexSpecCode (cadr IndexSpecCode))
                              (ProcessIndexSpecCode (caddr IndexSpecCode))
                              (ProcessIndexSpecCode (cadddr IndexSpecCode))
                              (ProcessIndexSpecCode (caddddr IndexSpecCode)))))
               ((equal (car IndexSpecCode) 'DeclSpecWVars)
                (cond ((equal (caadr IndexSpecCode) 'Prop)
                       (return (PropDeclCode (cadr (ProcessIndexSpecCode (cadadr IndexSpecCode)))
                                             (ProcessIndexSpecCode (caddr IndexSpecCode)))))
                      (t
                       (return `(DeclSpecWVars ,(ProcessIndexSpecCode (cadr IndexSpecCode)) 
                                               ,(ProcessIndexSpecCode (caddr IndexSpecCode)))))))
               ((member (car IndexSpecCode) '(FuncDefnWDeclSpec InlineFuncDefnWDeclSpec)) 
                (cond ((equal (caadr IndexSpecCode) 'Prop)
                       (return 
                        (append (GenStructDeclCode (ProcessIndexSpecCode (caddr IndexSpecCode)) 
                                                   (cadr (ProcessIndexSpecCode (cadadr IndexSpecCode))) 
                                                   (car IndexSpecCode)) 
                                (list (ProcessIndexSpecCode (cadddr IndexSpecCode))))))
                      (t
                       (return (list (car IndexSpecCode) (ProcessIndexSpecCode (cadr IndexSpecCode))
                                     (ProcessIndexSpecCode (caddr IndexSpecCode)) (ProcessIndexSpecCode (cadddr IndexSpecCode)))))))
               ((equal (car IndexSpecCode) 'SubstitutionList)
                       (return `(Id ,(FixSubstitution IndexSpecCode))))
               ((equal (car IndexSpecCode) 'Substitution)
                (return `(Id ,(FixSubstitution IndexSpecCode))))
               ((equal (car IndexSpecCode) 'At)
                (PathFuncClass IndexSpecCode)
                (return (AccessCode IndexSpecCode)))
               (t
                (return IndexSpecCode)))))


(defun FixSubstitution (Code)
  (prog (Temp)
        (cond ((equal (car Code) 'SubstitutionList)
               (cond ((member (cadr Code) '((Id |Assign|) (Id |Access|)) :test #'equal)
                      (setq Temp (FixSubstitution (caddr Code)))
                      (cond ((Match `(* (Type ,Temp > P1 *) *) InfoList)
                             (setq Temp (car (Build '(< P1))))))
                      (return (concat (cadadr Code) Temp)))
                     (t
                      (return (concat (FixSubstitution (cadr Code)) (FixSubstitution (caddr Code)))))))
              ((equal (car Code) 'Substitution)
               (cond ((not (Match `(* (,(cadr Code) > P1) *) SubstitutionMatch))
                      (ErrorMsg `("***PDMC Error: Unable to substitute" ,(cadr Code) "in the Specification file"))))
               (return (car (Build '(< P1)))))
              ((equal (car Code) 'Id)
               (return (cadr Code)))
              (t

               (PrintMsg "***warning: from FixSubstitution1")))))



(defun CheckKeyWord (KeyWord)
        (cond ((member KeyWord
                     '(AbstDeclParens 
                       AddrOp 
                       ArrayVar 
                       BangOp 
                       CompndArrayAbstDecl 
                       CompndFuncAbstDecl 
                       CompndStmtWDList 
                       CompndStmtWSList 
                       DeclSpec 
                       DefaultStmt 
                       EnumWEnumList 
                       EnumWId 
                       ExprStmt 
                       For 
                       FuncCall 
                       FuncVar 
                       Goto 
                       InitListHdr 
                       InitListHdrWCom 
                       NotOp 
                       OnesComp 
                       PostInc 
                       PreDec 
                       PreInc 
                       PrimExp 
                       PtrPtr  
                       PtrTSList  
                       ReturnWExp 
                       SimpArrayWSizeAbst 
                       SimpFuncAbstDeclWPList 
                       SizeExpOp 
                       SizeTypeOp 
                       StructFiller 
                       StructWDecl 
                       StructWId 
                       UnAddOp 
                       UnSubOp 
                       UnionWDecl 
                       UnionWId 
                       VarWParens)) 1)
        ((member KeyWord
                     '(AbstDeclWPtrAbsDecl 
                       Access 
                       AndPred 
                       ArgExpList 
                       ArrayExp 
                       ArrayVarWSize 
                       AssignAddOp 
                       AssignBitAndOp 
                       AssignBitOrOp 
                       AssignBitXOrOp 
                       AssignDivOp 
                       AssignLeftShiftOp 
                       AssignModOp 
                       AssignMultOp 
                       AssignOp 
                       AssignRightShiftOp 
                       AssignSubOp 
                       BinAddOp 
                       BinSubOp 
                       BitAndOp 
                       BitOrOp 
                       BitXOrOp 
                       CaseStmt 
                       CastExp 
                       CompndArrayWSizeAbstDecl 
                       CompndFuncAbstDeclWPList 
                       CompndStmtWDListSList 
                       DeclList 
                       DivOp 
                       DoStmt
                       EnumList 
                       EnumWIdEnumList 
                       EnumWInit 
                       EqPred 
                       ExprList 
                       FieldAcc 
                       File 
                       ForWF 
                       ForWI 
                       ForWS 
                       FuncBodyWDeclList 
                       FuncCallP 
                       FuncDefn  
                       FuncVarWPIdList 
                       FuncVarWPTList 
                       GEPred 
                       GTPred 
                       IdList 
                       IfStmt
                       InitDecl 
                       InitDeclList 
                       InitList 
                       InLineFuncDefn
                       LEPred 
                       LTPred 
                       LabeledStmt 
                       LeftShiftOp 
                       ModOp 
                       MultOp 
                       NEPred 
                       OrPred 
                       ParamDecl 
                       ParamList 
                       PtrTSListPtr  
                       PtrVar 
                       RightShiftOp 
                       StmtList 
                       StorDeclSpec 
                       StructDecl 
                       StructDeclList 
                       StructPacked 
                       StructVarList 
                       StructWDecl 
                       StructWIdDecl 
                       Switch
                       TypeDeclSpec 
                       TypeSpecList 
                       TypeSpecListWAbsDecl 
                       UnionWIdDecl 
                       While)) 2)
        ((member KeyWord
                     '(CondExp 
                       ForWIF 
                       ForWIS 
                       ForWSF 
                       IfElse)) 3)
        ((member KeyWord
                     '(ForWISF)) 4)
        (t nil)))




(defun AccessCode (Code)
  (prog ()
        (cond ((equal (caadr Code) 'At)
               (CMatch `(* (Type ,(cadaddadr Code) > P1 *) *) InfoList)
               (return 
                `(FuncCallP (Id ,(concat '|Access| (car (Build '(< P1))) (cadaddr Code))) ,(AccessCode (cadr Code)))))
              (t
               (return
                `(FuncCallP (Id, (concat '|Access| (PathFuncClass (cadr Code)) (cadaddr Code))) ,(cadr Code)))))))



(defun PropDeclCode (Name1 Name2)
  (prog ()
        (cond ((equal (car Name2) 'InitDeclList)
               (return (list 'DeclList (PropDeclCode Name1 (cadr Name2)) (PropDeclCode Name1 (caddr Name2)))))
              (t
               (return (GenStructDeclCode Name2 Name1 'StructDecl))))))


;***********************************************************************************************************************************
;***********************************************************************************************************************************


(defun CheckScopeList (N)
  (prog (Result)
        (cond ((equal (car N) 'ArrayExp) 
               (setq N (list 'Array (cadadr N))))
              (t
               (setq N (cadr N))))
        (do ((Temp1 ScopeList (cdr Temp1))) ((null Temp1))
            (do ((Temp2 (car Temp1) (cdr Temp2))) ((null Temp2))
                (if (equal (caar Temp2) N) (setq Result (cadar Temp2)))))
        (if (not (null Result)) (return Result))
        (cond ((atom N)
               ;(showstack)
               (ErrorMsg `("***PDMC Error: Prop variable" ,N "has not been defined")))
              (t
               ;(showstack)
               (ErrorMsg `("***PDMC Error: Prop variable" ,(cadr N) "has not been defined"))))))


(defun CheckProperty (V1 V2)
  (prog ()
        (cond ((Match `(* (Field ,V1 ,V2) *) InfoList)
               (CMatch `(* (Type ,V2 > P1 *) *) InfoList)
               (return (car (Build '(< P1)))))
              (t
               (ErrorMsg `("***PDMC Error: Illegal path function on class " ,V1 ,V2))))))


(defun FindType (V)
  (prog ()
       (CMatch `(* (Type ,(PathFuncClass V) > P1 *) *) InfoList)
       (return (car (Build '(< P1))))))


(defun PathFuncClass (V)
  (prog ()
        (cond ((equal (car V) 'At)
               (return (CheckProperty (PathFuncClass (cadr V)) (cadaddr V))))
              (t
               (return (CheckScopeList V))))))


(defun CheckSuperClass (C1 C2)
  (prog ()
        (if (null C1) (return nil))
        (if (equal C1 C2) (return t))
        (if (Match `(* (IsA ,C1 > P1) *) InfoList) (return (CheckSuperClass (car (Build '(< P1))) C2)))
        (return nil)))

;***********************************************************************************************************************************
;***********************************************************************************************************************************

