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

(defvar InfoList nil)
(defvar ScopeList)
(defvar InlineFlag 0)
(defvar SchemaVarName)
(defvar @SchemaVar)

(setq MatchVar (gensym "B") MatchVarStack nil FreeMatchVars nil)

;***********************************************************************************************************************************
;***********************************************************************************************************************************


(defun MAIN () 
  (prog (PDMCode CDBCode CCode Port NumPDMFile)
        (setq @SchemaVar 0)
        (setq Port (open "cdbc.pdm.number"))
        (setq NumPDMFile (read Port))
        (close Port)
        (cond ((equal NumPDMFile 0)
               (setq PDMCode (PhaseOne "cdbc.pdm.input0")) 
               (PhaseThree PDMCode))
              (t
               (do ((Temp 1 (add1 Temp))) ((> Temp NumPDMFile))
                   (setq PDMCode (PhaseOne (concatenate 'string "cdbc.pdm.input" (write-to-string Temp)))) 
                   (PhaseThree PDMCode))))
        (setq CDBCode (PhaseTwo "cdbc.cdb.input")) 
        (setq CCode (PhaseFour CDBCode))
        (PhaseFive CCode "cdbc.output")
        (quit)))


;***********************************************************************************************************************************
;***********************************************************************************************************************************



(defun PhaseOne (PDMFile)
  (prog (PDMCode Port)
        (setq Port (open PDMFile))
        (setq PDMCode (read Port))
        (close Port)
        (setq PDMCode (FixInput PDMCode))
        (return PDMCode)))


(defun PhaseTwo (CDBFile)
  (prog (CDBCode Port)
        (setq Port (open CDBFile))
        (setq CDBCode (read Port))
        (close Port)
        (setq CDBCode (FixInput CDBCode))
        (return CDBCode)))


(defun PhaseThree (PDMCode)
  (PrintMsg "processing PDM code.")
  (ProcessPDMCode PDMCode))


(defun PhaseFour (CDBCode)
  (prog ()
        (PrintMsg "processing CDB code.")
        (setq ScopeList '(()) SchemaVarName nil)
        (setq CDBCode (ProcessCDBCode CDBCode))
        (return CDBCode)))


(defun PhaseFive (CCode OutputFile)
  (PrintMsg "code generation.")
  (GenCode CCode OutputFile))


;***********************************************************************************************************************************
;***********************************************************************************************************************************


(defun ProcessPDMCode (PDMCode) 
  (prog (FieldList)
        (setq PDMCode (caddr PDMCode))
        (do ((PDMCode PDMCode (caddr PDMCode))) ((null PDMCode))
            (cond ((equal (caadr PDMCode) 'ClassSpec) 
                   (setq InfoList (append InfoList `((Reference ,(cadadadr PDMCode) ,(caadaddddadr PDMCode))
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
                   (setq InfoList (append1 InfoList (append '(Type) (cdadr PDMCode))))) 
                  ((equal (caadr PDMCode) 'QuerySpec)
                   (setq InfoList (append1 InfoList 
                                           `(Query ,(cadadadr PDMCode) 
                                                   ,(RestoreList (cadaddadr PDMCode)) ,(RestoreList (caddaddadr PDMCode))
                                                   ,(RestoreList (cadadddadr PDMCode)) ,(RestoreList (caddadddadr PDMCode))))))
                  ((equal (caadr PDMCode) 'TransSpec)
                   (setq InfoList (append1 InfoList 
                                           `(Trans ,(cadadr PDMCode) 
                                                 ,(RestoreList (cadaddadr PDMCode)) ,(RestoreList (caddaddadr PDMCode))))))))))


;***********************************************************************************************************************************
;***********************************************************************************************************************************


(defun ProcessCDBCode (CDBCode)
  (prog (Temp)
        (cond  ((equal 1 (CheckKeyWord (car CDBCode)))
                (return (list (car CDBCode) 
                              (ProcessCDBCode (cadr CDBCode)))))
               ((equal 2 (CheckKeyWord (car CDBCode)))
                (return (list (car CDBCode) (ProcessCDBCode (cadr CDBCode)) 
                              (ProcessCDBCode (caddr CDBCode)))))
               ((equal 3 (CheckKeyWord (car CDBCode)))
                (return (list (car CDBCode) 
                              (ProcessCDBCode (cadr CDBCode)) 
                              (ProcessCDBCode (caddr CDBCode)) 
                              (ProcessCDBCode (cadddr CDBCode)))))
               ((equal 4 (CheckKeyWord (car CDBCode)))
                (return (list (car CDBCode) 
                              (ProcessCDBCode (cadr CDBCode))
                              (ProcessCDBCode (caddr CDBCode))
                              (ProcessCDBCode (cadddr CDBCode))
                              (ProcessCDBCode (caddddr CDBCode)))))
               ((equal (car CDBCode) 'CompndStmtWDList)
                (setq ScopeList (cons nil ScopeList))
                (setq Temp `(CompndStmtWDList ,(ProcessCDBCode (cadr CDBCode))))
                (setq ScopeList (cdr ScopeList))
                (return Temp))
               ((member (car CDBCode) '(FuncBodyWDeclList CompndStmtWDListSList))
                (setq ScopeList (cons nil ScopeList))
                (setq Temp `(,(car CDBCode) ,(ProcessCDBCode (cadr CDBCode)) ,(ProcessCDBCode(caddr CDBCode))))
                (setq ScopeList (cdr ScopeList))
                (return Temp))
               ((equal (car CDBCode) 'DeclSpecWVars)
                (cond ((equal (caadr CDBCode) 'Prop)
                       (return (PropDeclCode (cadadadr CDBCode) (caddr CDBCode))))
                      ((equal (caaddadr CDBCode) 'Prop)
                       (return (ExternDeclCode (PropDeclCode (cadadaddadr CDBCode) (caddr CDBCode)))))
                      (t
                       (return `(DeclSpecWVars ,(ProcessCDBCode (cadr CDBCode)) ,(ProcessCDBCode (caddr CDBCode)))))))
               ((equal (car CDBCode) 'FuncDefnWDeclSpec) 
                (cond ((equal (caadr CDBCode) 'Prop)
                       (return (append (GenStructDeclCode (caddr CDBCode) (cadadadr CDBCode) 'FuncDefnWDeclSpec) 
                                       (list (ProcessCDBCode (cadddr CDBCode))))))
                      (t
                       (return (list (car CDBCode) (ProcessCDBCode (cadr CDBCode))
                                     (ProcessCDBCode (caddr CDBCode)) (ProcessCDBCode (cadddr CDBCode)))))))
               ((equal (car CDBCode) 'SchemaDecl)
                (cond ((equal 'Id (caaddr CDBCode))
                       (cond ((equal SchemaVarName nil)
                              (setq SchemaVarName (cadaddr CDBCode)))
                             (t
                              (setq SchemaVarName '(nil)))))
                      (t
                       (setq SchemaVarName '(nil))))
                (return 
                 `(File (Preprocessor1 (,(concatenate 'string "include \"" (string (cadadr CDBCode)) ".h\"")))
                        (DeclSpecWVars (StructWId (Id ,(concat (cadadr CDBCode) '|Struct|))) ,(ProcessCDBCode (caddr CDBCode))))))
               ((equal (car CDBCode) 'IfQuery)
                (return (IfElseQueryCode (QueryTypeCheck nil (cadr CDBCode))
                                         (cadadaddr CDBCode)
                                         nil
                                         (RestoreArgExpList (caddadaddr CDBCode))
                                         (cadddr CDBCode)
                                         nil)))
               ((equal (car CDBCode) 'IfQueryWSelect)
                (return (IfElseQueryCode (QueryTypeCheck (cadr CDBCode) (caddr CDBCode))
                                         (cadadaddr CDBCode)
                                         (RestoreIdList (cadr CDBCode))
                                         (RestoreArgExpList (caddadaddr CDBCode))
                                         (cadddr CDBCode)
                                         nil)))
               ((equal (car CDBCode) 'IfElseQuery)
                (return (IfElseQueryCode (QueryTypeCheck nil (cadr CDBCode))
                                         (cadadaddr CDBCode)
                                         nil
                                         (RestoreArgExpList (caddadaddr CDBCode))
                                         (cadddr CDBCode)
                                         (caddddr CDBCode))))
               ((equal (car CDBCode) 'IfElseQueryWSelect)
                (return (IfElseQueryCode (QueryTypeCheck (cadr CDBCode) (caddr CDBCode))
                                         (cadadaddr CDBCode)
                                         (RestoreIdList (cadr CDBCode))
                                         (RestoreArgExpList (caddadaddr CDBCode))
                                         (cadddr CDBCode)
                                         (caddddr CDBCode))))
               ((equal (car CDBCode) 'WhileQuery)
                (return (WhileQueryCode (QueryTypeCheck nil (cadr CDBCode))
                                        (cadadaddr CDBCode)
                                        nil
                                        (RestoreArgExpList (caddadaddr CDBCode))
                                        (cadddr CDBCode))))
               ((equal (car CDBCode) 'WhileQueryWSelect)
                (return (WhileQueryCode (QueryTypeCheck (cadr CDBCode) (caddr CDBCode))
                                        (cadadaddr CDBCode)
                                        (RestoreIdList (cadr CDBCode))
                                        (RestoreArgExpList (caddadaddr CDBCode))
                                        (cadddr CDBCode))))
               ((equal (car CDBCode) 'ForQuery)
                (return (ForQueryCode (QueryTypeCheck nil (cadr CDBCode))
                                      (cadadaddr CDBCode)
                                      nil
                                      (RestoreArgExpList (caddadaddr CDBCode))
                                      (cadddr CDBCode))))
               ((equal (car CDBCode) 'ForQueryWSelect)
                (return (ForQueryCode (QueryTypeCheck (cadr CDBCode) (caddr CDBCode))
                                      (cadadaddr CDBCode)
                                      (RestoreIdList (cadr CDBCode))
                                      (RestoreArgExpList (caddadaddr CDBCode))
                                      (cadddr CDBCode))))
               ((equal (car CDBCode) 'TransCall)
                (return (TransCode (cadr CDBCode) nil nil)))
               ((equal (car CDBCode) 'TransCallWSchema)
                (return (TransCode (cadr CDBCode) nil (caddr CDBCode))))
               ((equal (car CDBCode) 'TransCallP)
                (return (TransCode (cadr CDBCode) (caddr CDBCode) nil)))
               ((equal (car CDBCode) 'TransCallPWSchema)
                (return (TransCode (cadr CDBCode) (caddr CDBCode) (cadddr CDBCode))))
               ((equal (car CDBCode) 'At)
                (PathFuncClass CDBCode)
                (return (AccessCode CDBCode)))
               (t
                (return CDBCode)))))


(defun CheckKeyWord (KeyWord)
  (prog ()
        (and (member KeyWord
                     '(AbstDeclParens 
                       AddrOp 
                       ArrayVar 
                       BangOp 
                       CompndArrayAbstDecl 
                       CompndFuncAbstDecl 
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
                       VarWParens))
             (return 1))
        (and (member KeyWord
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
                       While))
             (return 2))
        (and (member KeyWord
                     '(CondExp 
                       ForWIF 
                       ForWIS 
                       ForWSF 
                       IfElse))
             (return 3))
        (and (member KeyWord
                     '(ForWISF)) 
             (return 4)) 
        (return nil)))


(defun ForQueryCode (Schema QueryName Select Given Stmt1)
  (prog (Code SchemaVar Giv Sel)
        (CMatch `(* (Query ,(cadr QueryName) > P1 ? > P2 ?) *) InfoList)
        (setq Sel (Build '(<< P2)) Giv (Build '(<< P1)))
        (setq SchemaVar (GenerateName 'SchemaVar))
        (setq Code '(EmptyStmt))
        (do ((Giv Giv (cdr Giv)) (Given Given (cdr Given))) ((null Giv))
            (cond ((equal (FindType(car Given)) 'String) 
                   (setq Code `(StmtList 
                                ,Code (ExprStmt 
                                       (FuncCallP (Id |strcpy|) 
                                                  (ArgExpList (Access (Id ,SchemaVar) (Id ,(car Giv))) 
																				  ,(ProcessCDBCode (car Given))))))))
                  (t
                   (setq Code `(StmtList ,Code (ExprStmt (AssignOp (Access (Id ,SchemaVar) (Id ,(car Giv))) ,(car Given))))))))
        (setq Code `(StmtList ,Code (ExprStmt (FuncCallP ,QueryName (ArgExpList (AddrOp ,Schema) (AddrOp (Id ,SchemaVar)))))))
        (do ((Sel Sel (cdr Sel)) (Select Select (cdr Select))) ((null Sel))
            (cond ((equal (FindType(car Select)) 'String) 
                   (setq Code `(StmtList 
                                ,Code (ExprStmt 
                                       (FuncCallP (Id |strcpy|) 
                                                  (ArgExpList ,(car Select) 
																				  (Access (Id ,SchemaVar) (Id ,(car Sel)))))))))
                  (t
                   (setq Code `(StmtList ,Code (ExprStmt (AssignOp ,(car Select) (Access (Id ,SchemaVar) (Id ,(car Sel))))))))))
        (setq Code `(StmtList ,Code (IfStmt (Access (Id ,SchemaVar) (Id |Result|)) ,(ProcessCDBCode Stmt1))))
        (setq Code `(DoStmt (CompndStmtWSList ,Code) (Access (Id ,SchemaVar) (Id |Result|))))
        (setq Code `(StmtList (ExprStmt (AssignOp (Access (Id ,SchemaVar) (Id |First|)) (Const "1"))) ,Code))
        (return 
         `(CompndStmtWDListSList (DeclSpecWVars (StructWId (Id ,(concat (cadr QueryName) '|Struct|))) (Id ,SchemaVar)) ,Code))))


(defun WhileQueryCode (Schema QueryName Select Given Stmt1)
  (prog (Code SchemaVar Giv Sel)
        (CMatch `(* (Query ,(cadr QueryName) > P1 ? > P2 ?) *) InfoList)
        (setq Sel (Build '(<< P2)) Giv (Build '(<< P1)))
        (setq SchemaVar (GenerateName 'SchemaVar))
        (setq Code `(ExprStmt (AssignOp (Access (Id ,SchemaVar) (Id |First|)) (Const "1"))))
        (do ((Giv Giv (cdr Giv)) (Given Given (cdr Given))) ((null Giv))
            (cond ((equal (FindType(car Given)) 'String) 
                   (setq Code `(StmtList 
                                ,Code (ExprStmt 
                                       (FuncCallP (Id |strcpy|) 
                                                  (ArgExpList (Access (Id ,SchemaVar) (Id ,(car Giv))) 
																				  ,(ProcessCDBCode (car Given))))))))
                  (t
                   (setq Code `(StmtList ,Code (ExprStmt (AssignOp (Access (Id ,SchemaVar) (Id ,(car Giv))) ,(car Given))))))))
        (setq Code `(StmtList ,Code (ExprStmt (FuncCallP ,QueryName (ArgExpList (AddrOp ,Schema) (AddrOp (Id ,SchemaVar)))))))
        (do ((Sel Sel (cdr Sel)) (Select Select (cdr Select))) ((null Sel))
            (cond ((equal (FindType(car Select)) 'String) 
                   (setq Code `(StmtList 
                                ,Code (ExprStmt 
                                       (FuncCallP (Id |strcpy|) 
                                                  (ArgExpList ,(car Select) 
																				  (Access (Id ,SchemaVar) (Id ,(car Sel)))))))))
                  (t
                   (setq Code `(StmtList ,Code (ExprStmt (AssignOp ,(car Select) (Access (Id ,SchemaVar) (Id ,(car Sel))))))))))
        (setq Code `(StmtList ,Code (IfStmt (Access (Id ,SchemaVar) (Id |Result|)) ,(ProcessCDBCode Stmt1))))
        (setq Code `(While (Access (Id ,SchemaVar) (Id |Result|)) (CompndStmtWSList ,Code)))
        (setq Code `(StmtList (ExprStmt (AssignOp (Access (Id ,SchemaVar) (Id |Result|)) (Const 1))) ,Code))
        (return 
         `(CompndStmtWDListSList (DeclSpecWVars (StructWId (Id ,(concat (cadr QueryName) '|Struct|))) (Id ,SchemaVar)) ,Code))))


(defun IfElseQueryCode (Schema QueryName Select Given Stmt1 Stmt2)
  (prog (Code SchemaVar Giv Sel)
        (CMatch `(* (Query ,(cadr QueryName) > P1 ? > P2 ?) *) InfoList)
        (setq Sel (Build '(<< P2)) Giv (Build '(<< P1)))
        (setq SchemaVar (GenerateName 'SchemaVar))
        (setq Code `(ExprStmt (AssignOp (Access (Id ,SchemaVar) (Id |First|)) (Const "1"))))
        (do ((Giv Giv (cdr Giv)) (Given Given (cdr Given))) ((null Giv))
            (cond ((equal (FindType(car Given)) 'String) 
                   (setq Code `(StmtList 
                                ,Code (ExprStmt 
                                       (FuncCallP (Id |strcpy|) 
                                                  (ArgExpList (Access (Id ,SchemaVar) (Id ,(car Giv))) 
																				  ,(ProcessCDBCode (car Given))))))))
                  (t
                   (setq Code `(StmtList ,Code (ExprStmt (AssignOp (Access (Id ,SchemaVar) (Id ,(car Giv))) ,(car Given))))))))
        (setq Code `(StmtList ,Code (ExprStmt (FuncCallP ,QueryName (ArgExpList (AddrOp ,Schema) (AddrOp (Id ,SchemaVar)))))))
        (do ((Sel Sel (cdr Sel)) (Select Select (cdr Select))) ((null Sel))
            (cond ((equal (FindType(car Select)) 'String) 
                   (setq Code `(StmtList 
                                ,Code (ExprStmt 
                                       (FuncCallP (Id |strcpy|) 
                                                  (ArgExpList ,(car Select) 
																				  (Access (Id ,SchemaVar) (Id ,(car Sel)))))))))
                  (t
                   (setq Code `(StmtList ,Code (ExprStmt (AssignOp ,(car Select) (Access (Id ,SchemaVar) (Id ,(car Sel))))))))))
        (cond ((null Stmt2)
               (setq Code `(StmtList ,Code (IfStmt (Access (Id ,SchemaVar) (Id |Result|)) ,(ProcessCDBCode Stmt1)))))
              (t
               (setq Code `(StmtList ,Code (IfElse (Access (Id ,SchemaVar) (Id |Result|)) 
                                                   ,(ProcessCDBCode Stmt1) ,(ProcessCDBCode Stmt2))))))
        (return 
         `(CompndStmtWDListSList (DeclSpecWVars (StructWId (Id ,(concat (cadr QueryName) '|Struct|))) (Id ,SchemaVar)) ,Code))))


(defun TransCode (TransName Parameters SchemaName)
  (prog (Temp1 Temp2)
        (and (null SchemaName) (or (null SchemaVarName) (equal SchemaVarName '(nil)))
             (ErrorMsg `("***CDB Error: Explicit schema variable is required in a call to transaction" ,(cadr TransName))))
        (if (null SchemaName) (setq SchemaName (list 'Id SchemaVarName)))  
        (if (not (Match `(* (Trans ,(cadr TransName) ? > P1) *) InfoList))
            (ErrorMsg `("***CDB Error: Transaction" ,(cadr TransName) "has not been defined in PDM source.")))
        (setq Temp1 (RestoreArgExpList Parameters) Temp2 (Build '(<< P1)))
        (if (not (equal (length Temp1) (length Temp2))) 
            (ErrorMsg `("***CDB Error: Parameter error in a call to transaction" ,(cadr TransName))))
        (do ((Temp1 Temp1 (cdr Temp1)) (Temp2 Temp2 (cdr Temp2))) ((null Temp1))
            (and
             (not (member (caar Temp1) '(Const StrLit)))
             (not (CheckSuperClass (PathFuncClass (car Temp1)) (car Temp2)))
             (ErrorMsg `("***CDB Error: Parameter type not match in a call to transaction" ,(cadr TransName)))))
        (cond ((null Parameters)
               (return `(FuncCallP ,TransName (AddrOp ,SchemaName))))
              (t
               (return `(FuncCallP ,TransName (ArgExpList (AddrOp ,SchemaName) ,(ProcessCDBCode Parameters))))))))


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
               (cond ((equal (car Name2) 'Id)
                      (setq ScopeList (cons (cons (list (cadr Name2) Name1) (car ScopeList)) (cdr ScopeList))))
                     ((equal (car Name2) 'ArrayVarWSize)
                      (setq ScopeList (cons (cons (list (list 'Array (cadadr Name2)) Name1) (car ScopeList)) (cdr ScopeList))))
                     (t
                      (ErrorMsg `("***CDB Error:" "Illegal variable declaration to prop" ,Name1 "."))))
               (return (GenStructDeclCode Name2 Name1 'StructDecl))))))


(defun ExternDeclCode (Code)
  (prog ()
        (cond ((member (car Code) '(File DeclList))
               (return `(File ,(ExternDeclCode (cadr Code)) ,(ExternDeclCode (caddr Code)))))
              ((member (car Code) '(StructDecl))
               (return `(DeclSpecWVars (StorDeclSpec (Extern) ,(cadr Code)) ,(caddr Code))))
              (t
               (PrintMsg "*****warning: from ExternDeclCode")))))


;***********************************************************************************************************************************
;***********************************************************************************************************************************


(defun QueryTypeCheck (Select QueryCall)
  (prog (SchemaName S1 S2 G1 G2)
        (cond ((equal (car QueryCall) 'QueryCallWSchema)
               (setq SchemaName (caddr QueryCall)))
              ((or (null SchemaVarName) (equal SchemaVarName '(nil)))
               (ErrorMsg `("***CDB Error: Explicit schema variable is required in a call to query" ,(cadadadr QueryCall))))
              (t
               (setq SchemaName (list 'Id SchemaVarName)))) 
        (if (not (Match `(* (Query ,(cadadadr QueryCall) ? > P1 ? > P2) *) InfoList))
            (ErrorMsg `("***CDB Error: Query" ,(cadadadr QueryCall) "has not been defined in PDM source.")))
        (setq S2 (Build '(<< P2)) G2 (Build '(<< P1)) S1 (RestoreIdList Select) G1 (RestoreArgExpList (caddadr QueryCall)))
        (if (not (equal (length S1) (length S2))) 
            (ErrorMsg `("***CDB Error: Select clause error in a call to query" ,(cadadadr QueryCall))))
        (if (not (equal (length G1) (length G2))) 
            (ErrorMsg `("***CDB Error: Parameter error in a call to query" ,(cadadadr QueryCall))))
        (do ((S1 S1 (cdr S1)) (S2 S2 (cdr S2))) ((null S1))
            (if (not (CheckSuperClass (car S2) (PathFuncClass (car S1))))
                (ErrorMsg `("***CDB Error: Select clause parameter type not match in a call to query" ,(cadadadr QueryCall)))))
        (do ((G1 G1 (cdr G1)) (G2 G2 (cdr G2))) ((null G1))
            (cond ((not (CheckSuperClass (PathFuncClass (car G1)) (car G2)))
						 (ErrorMsg `("***CDB Error: Given clause parameter type not match in a call to query" ,(cadadadr QueryCall))))))
        (return SchemaName)))


(defun FindType2 (S)
  (prog ()
		  (CMatch `(* (Type ,S > P1 *) *) InfoList)
        (return (car (Build '(< P1))))))


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
               (ErrorMsg `("***CDB Error: Object-valued variable" ,N "has not been defined")))
              (t
               (ErrorMsg `("***CDB Error: Object-valued variable" ,(cadr N) "has not been defined"))))))


(defun CheckProperty (V1 V2)
  (prog ()
        (cond ((Match `(* (Field ,V1 ,V2) *) InfoList)
               (CMatch `(* (Type ,V2 > P1 *) *) InfoList)
					(cond ((member (car (Build '(< P1))) '(String Integer Real DoubleReal))
							 (return V2))
							(t
							 (return (car (Build '(< P1))))))) 
				  (t
               (ErrorMsg `("***CDB Error: Illegal path function on class " ,V1))))))


(defun FindType (V)
  (prog()
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

