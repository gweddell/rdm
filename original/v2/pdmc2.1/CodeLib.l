;***********************************************************************
; Copyright (C) 1989, G. E. Weddell.
;***********************************************************************

(declare (special MacroList InfoList Refer))


(defun Code001 (Var Index) 
  (prog (Reference)
        (CMatch `(* (IndexSpec ,Index > P ?) *) InfoList)
        (CMatch (list '* (list 'Reference (car (Build '(< P))) '> 'Q) '*) InfoList)
        (cond ((equal (Build '(< Q)) '(Direct))
               (setq Reference '(Ptr)))
              (t
               (setq Reference '(PtrPtr (Ptr)))))
        (return  
         (list 'IfElse 
               (list 'EqPred 
                     (list 'Id (concat Index 'Head)) 
                     '(Const "0")) 
               (list 'CompndStmtWSList 
                     (list 'StmtList 
                           (list 'ExprStmt 
                                 (list 'AssignOp 
                                       (list 'At 
                                             Var 
                                             (list 'Id (concat Index 'Prev))) 
                                       (list 'AssignOp 
                                             (list 'At 
                                                   Var
                                                   (list 'Id (concat Index 'Next))) 
                                             '(Const "0")))) 
                           (list 'ExprStmt 
                                 (list 'AssignOp 
                                       (list 'Id (concat Index 'Head)) 
                                       (list 'CastExp 
                                             (list 'TypeSpecListWAbsDecl 
                                                   (list 'StructWId 
                                                         (list 'Id 
                                                               (car (Build '(< P)))))
                                                   Reference)
                                             Var)))))
               (list 'CompndStmtWSList 
                     (list 'StmtList 
                           (list 'StmtList
                                 (list 'ExprStmt 
                                       (list 'AssignOp 
                                             (list 'At 
                                                   Var 
                                                   (list 'Id (concat Index 'Prev))) 
                                             '(Const "0")))
                                 (list 'ExprStmt
                                       (list 'AssignOp 
                                             (list 'At 
                                                   Var 
                                                   (list 'Id (concat Index 'Next))) 
                                             (list 'Id (concat Index 'Head)))))
                           (list 'ExprStmt
                                 (list 'AssignOp 
                                       (list 'Id (concat Index 'Head))
                                       (list 'AssignOp 
                                             (list 'At 
                                                   (list 'At 
                                                         Var 
                                                         (list 'Id (concat Index 'Next)))
                                                   (list 'Id (concat Index 'Prev)))
                                             (list 'CastExp 
                                                   (list 'TypeSpecListWAbsDecl 
                                                         (list 'StructWId 
                                                               (list 'Id 
                                                                     (car (Build '(< P)))))
                                                         Reference)
                                                   Var))))))))))


(defun Code002 (Var Index On)
  (prog (Reference)
        (CMatch `(* (IndexSpec ,Index > P ?) *) InfoList)
        (CMatch (list '* (list 'Reference (car (Build '(< P))) '> 'Q) '*) InfoList)
        (cond ((equal (Build '(< Q)) '(Direct))
               (setq Reference '(Ptr)))
              (t
               (setq Reference '(PtrPtr (Ptr)))))
        (return  (list 'IfElse
                       (list 'EqPred 
                             (list 'Id (concat Index 'Head))
                             '(Const "0"))
                       (list 'CompndStmtWSList
                             (list 'StmtList 
                                   (list 'ExprStmt
                                         (list 'AssignOp
                                               (list 'At 
                                                     Var 
                                                     (list 'Id (concat Index 'Prev)))
                                               (list 'AssignOp 
                                                     (list 'At 
                                                           Var 
                                                           (list 'Id (concat Index 'Next))) 
                                                     '(Const "0")))) 
                                   (list 'ExprStmt 
                                         (list 'AssignOp 
                                               (list 'Id (concat Index 'Head))
                                               (list 'AssignOp 
                                                     (list 'At 
                                                           (list 'At 
                                                                 Var
                                                                 (list 'Id On))
                                                           (list 'Id (concat Index 'First)))
                                                     (list 'CastExp 
                                                           (list 'TypeSpecListWAbsDecl 
                                                                 (list 'StructWId 
                                                                       (list 'Id 
                                                                             (car (Build '(< P)))))
                                                                 Reference)
                                                           Var))))))
                       (list 'IfElse
                             (list 'EqPred
                                   (list 'At
                                         (list 'At
                                               Var
                                               (list 'Id On))
                                         (list 'Id (concat Index 'First)))
                                   '(Const "0"))
                             (list 'CompndStmtWSList
                                   (list 'StmtList
                                         (list 'StmtList
                                               (list 'ExprStmt
                                                     (list 'AssignOp 
                                                           (list 'At 
                                                                 Var
                                                                 (list 'Id (concat Index 'Next)))
                                                           (list 'Id (concat Index 'Head))))
                                               (list 'ExprStmt
                                                     (list 'AssignOp
                                                           (list 'At
                                                                 Var
                                                                 (list 'Id (concat Index 'Prev)))
                                                           '(Const "0"))))
                                         (list 'ExprStmt
                                               (list 'AssignOp
                                                     (list 'Id (concat Index 'Head))
                                                     (list 'AssignOp
                                                           (list 'At
                                                                 (list 'At
                                                                       Var
                                                                       (list 'Id On))
                                                                 (list 'Id (concat Index 'First)))
                                                           (list 'AssignOp
                                                                 (list 'At
                                                                       (list 'At
                                                                             Var
                                                                             (list 'Id (concat Index 'Next)))
                                                                       (list 'Id (concat Index 'Prev)))
                                                                 (list 'CastExp 
                                                                       (list 'TypeSpecListWAbsDecl 
                                                                             (list 'StructWId 
                                                                                   (list 'Id 
                                                                                         (car (Build '(< P)))))
                                                                             Reference)
                                                                       Var)))))))
                             (list 'CompndStmtWSList
                                   (list 'StmtList
                                         (list 'StmtList
                                               (list 'StmtList
                                                     (list 'ExprStmt
                                                           (list 'AssignOp
                                                                 (list 'At
                                                                       Var
                                                                       (list 'Id (concat Index 'Next)))
                                                                 (list 'At
                                                                       (list 'At
                                                                             Var
                                                                             (list 'Id On))
                                                                       (list 'Id (concat Index 'First)))))
                                                     (list 'ExprStmt
                                                           (list 'AssignOp
                                                                 (list 'At
                                                                       Var
                                                                       (list 'Id (concat Index 'Prev)))
                                                                 (list 'At
                                                                       (list 'At
                                                                             (list 'At
                                                                                   Var
                                                                                   (list 'Id On))
                                                                             (list 'Id (concat Index 'First)))
                                                                       (list 'Id (concat Index 'Prev)))))) 
                                               (list 'ExprStmt
                                                     (list 'AssignOp
                                                           (list 'At
                                                                 (list 'At
                                                                       Var
                                                                       (list 'Id On))
                                                                 (list 'Id (concat Index 'First)))
                                                           (list 'AssignOp
                                                                 (list 'At
                                                                       (list 'At
                                                                             Var 
                                                                             (list 'Id (concat Index 'Next))) 
                                                                       (list 'Id (concat Index 'Prev))) 
                                                                 (list 'CastExp 
                                                                       (list 'TypeSpecListWAbsDecl 
                                                                             (list 'StructWId 
                                                                                   (list 'Id 
                                                                                         (car (Build '(< P)))))
                                                                             Reference)
                                                                       Var)))))
                                         (list 'IfElse
                                               (list 'NEPred
                                                     (list 'At
                                                           Var
                                                           (list 'Id (concat Index 'Prev)))
                                                     '(Const "0"))
                                               (list 'ExprStmt
                                                     (list 'AssignOp
                                                           (list 'At
                                                                 (list 'At
                                                                       Var
                                                                       (list 'Id (concat Index 'Prev)))
                                                                 (list 'Id (concat Index 'Next)))
                                                           (list 'CastExp 
                                                                 (list 'TypeSpecListWAbsDecl 
                                                                       (list 'StructWId 
                                                                             (list 'Id 
                                                                                   (car (Build '(< P)))))
                                                                       Reference)
                                                                 Var)))
                                               (list 'ExprStmt
                                                     (list 'AssignOp
                                                           (list 'Id (concat Index 'Head)) 
                                                           (list 'CastExp 
                                                                 (list 'TypeSpecListWAbsDecl 
                                                                       (list 'StructWId 
                                                                             (list 'Id 
                                                                                   (car (Build '(< P)))))
                                                                       Reference)
                                                                 Var)))))))))))

(defun Code003 (Var Index On)
  (list 'StmtList
        (list 'StmtList
              (list 'StmtList
                    (list 'If
                          (list 'EqPred
                                (list 'At
                                      (list 'At
                                            Var
                                            (list 'Id On))
                                      (list 'Id (concat Index 'First)))
                                Var))
                    (list 'IfElse
                          (list 'AndPred
                                (list 'NEPred
                                      (list 'At
                                            Var
                                            (list 'Id (concat Index 'Next)))
                                      '(Const "0"))
                                (list 'EqPred
                                      (list 'At
                                            (list 'At
                                                  Var
                                                  (list 'Id (concat Index 'Next)))
                                            (list 'Id On))
                                      (list 'At
                                            Var
                                            (list 'Id On))))
                          (list 'ExprStmt 
                                (list 'AssignOp
                                      (list 'At
                                            (list 'At
                                                  Var
                                                  (list 'Id On))
                                            (list 'Id (concat Index 'First)))
                                      (list 'At 
                                            Var
                                            (list 'Id (concat Index 'Next)))))
                          (list 'ExprStmt
                                (list 'AssignOp
                                      (list 'At
                                            (list 'At
                                                  Var
                                                  (list 'Id On))
                                            (list 'Id (concat Index 'First)))
                                      '(Const "0")))))
              (list 'IfElse
                    (list 'EqPred
                          (list 'At
                                Var
                                (list 'Id (concat Index 'Prev)))
                          '(Const "0"))
                    (list 'ExprStmt
                          (list 'AssignOp
                                (list 'Id (concat Index 'Head))
                                (list 'At
                                      Var
                                      (list 'Id (concat Index 'Next)))))
                    (list 'ExprStmt
                          (list 'AssignOp 
                                (list 'At
                                      (list 'At
                                            Var
                                            (list 'Id (concat Index 'Prev)))
                                      (list 'Id (concat Index 'Next)))
                                (list 'At
                                      Var
                                      (list 'Id (concat Index 'Next)))))))
        (list 'If
              (list 'NEPred
                    (list 'At
                          Var
                          (list 'Id (concat Index 'Next)))
                    '(Const "0"))
              (list 'ExprStmt
                    (list 'AssignOp
                          (list 'At
                                (list 'At
                                      Var
                                      (list 'Id (concat Index 'Next)))
                                (list 'Id (concat Index 'Prev)))
                          (list 'At
                                Var
                                (list 'Id (concat Index 'Prev))))))))


(defun Code004 (Var Index)
  (list 'StmtList
        (list 'IfElse
              (list 'EqPred
                    (list 'At
                          Var
                          (list 'Id (concat Index 'Prev)))
                    '(Const "0"))
              (list 'ExprStmt
                    (list 'AssignOp
                          (list 'Id (concat Index 'Head))
                          (list 'At
                                Var
                                (list 'Id (concat Index 'Next)))))
              (list 'ExprStmt
                    (list 'AssignOp 
                          (list 'At
                                (list 'At
                                      Var
                                      (list 'Id (concat Index 'Prev)))
                                (list 'Id (concat Index 'Next)))
                          (list 'At
                                Var
                                (list 'Id (concat Index 'Next))))))
        (list 'If
              (list 'NEPred
                    (list 'At
                          Var
                          (list 'Id (concat Index 'Next)))
                    '(Const "0"))
              (list 'ExprStmt
                    (list 'AssignOp
                          (list 'At
                                (list 'At
                                      Var
                                      (list 'Id (concat Index 'Next)))
                                (list 'Id (concat Index 'Prev)))
                          (list 'At
                                Var
                                (list 'Id (concat Index 'Prev))))))))


(defun Code005 (Var Store StructName)
  (CMatch (list '* (list 'StoreSpec Store '? '> 'P1) '*) InfoList)
  (CMatch (list '* (list 'Msc (car (Build '(< P1))) '> 'P2 '> 'P3) '*) InfoList)
  (list 'StmtList
        (list 'IfElse 
              (list 'EqPred 
                    (list 'Id Store)
                    '(Const "0"))
              (list 'ExprStmt
                    (list 'AssignOp
                          Var
                          (list 'CastExp 
                                (list 'TypeSpecListWAbsDecl
                                      (list 'StructWId 
                                            (list 'Id StructName))
                                      '(Ptr))
                                (list 'FuncCallP
                                      '(Id malloc)
                                      (list 'Id (concat Store 'Size))))))
              (list 'CompndStmtWSList
                    (list 'StmtList
                          (list 'ExprStmt
                                (list 'AssignOp
                                      Var
                                      (list 'CastExp 
                                            (list 'TypeSpecListWAbsDecl
                                                  (list 'StructWId 
                                                        (list 'Id StructName))
                                                  '(Ptr))
                                            (list 'Id Store))))
                          (list 'ExprStmt
                                (list 'AssignOp
                                      (list 'Id Store)
                                      (list 'At 
                                            (list 'Id Store)
                                            '(Id Next)))))))
        (list 'ExprStmt
              (list 'AssignOp
                    (list 'At
                          Var
                          '(Id Msc))
                    (list 'Const (car (Build '(< P2))))))))


(defun Code006 (Var Store)
  (list 'StmtList
        (list 'ExprStmt
              (list 'AssignOp
                    (list 'At
                          (list 'PrimExp
                                (list 'CastExp
                                      (list 'TypeSpecListWAbsDecl
                                            (list 'StructWId
                                                  '(Id StoreTemplate))
                                            '(Ptr))
                                      Var))
                          '(Id Next))
                    Store))
        (list 'ExprStmt
              (list 'AssignOp
                    Store
                    (list 'CastExp
                          (list 'TypeSpecListWAbsDecl
                                (list 'StructWId
                                      '(Id StoreTemplate))
                                '(Ptr))
                          Var)))))


(defun Code007 (Code)
  (list 'File
        Code
        (list 'File
              (list 'Comment
                    "Structure for Store")
              '(DeclSpec 
                (StructWIdDecl 
                 (Id StoreTemplate) 
                 (StructDecl 
                  (StructWId (Id StoreTemplate)) 
                  (PtrVar (Ptr) (Id Next))))))))



(defun Code008 (Var1 Var2 Var3)
  (list 'DeclSpecWVars
        (list 'StructWId 
              (list 'Id Var1))
        (list 'InitDecl 
              (list 'PtrVar 
                    Var3 
                    (list 'Id 
                          (concat Var2 'Head))) 
              '(Const "0"))))


(defun Code009 ()
  '(DeclSpecWVars 
    (StructWId (Id StoreTemplate)) 
    (InitDecl (PtrVar *Replace1* (Id *Replace2*)) (Const "0"))))


(defun Code010 (Pred In Yes No)
  (list 'If 
        (CheckStringPred Pred) 
        (list 'Goto 
              (list 'Id Yes))))


(defun Code011 (Body In Out)
  (list 'ExprStmt 
        (list 'AssignOp 
              (list 'Id (concat Body 'Cut)) 
              '(Const "1")))) 


(defun Code012 (V1 V2 V3)
  `(PrimExp (CastExp (TypeSpecListWAbsDecl (StructWId ,V1) ,V3) ,V2)))


(defun Code013 (V) 
  (SetRefer (caddr V) 'Put)
  (list
   (cadr V) 
   (caddr V)
   (list (caddr V))
   (CheckStringAssign (list 'ExprStmt (list 'AssignOp (cadadddr V) (caddadddr V)))))) 


(defun Code014 ()
  '(CompndStmtWDListSList 
    (DeclSpecWVars (Int) (InitDecl (Id Flag) (Const "1"))) 
    (While 
     (Id Flag) 
     (CompndStmtWSList 
      (StmtList (ExprStmt (AssignOp (Id Flag) (Const "0")))
                *Replace*)))))


(defun Code015 (Node)
  (prog ()
        (cond ((equal (length (caddddr Node)) 4)
               (return
                (list
                 (cadr Node)
                 (SetRefer (caddr Node) 'Put)
                 (list (caddr Node) (cadddr Node))
                 (list 'StmtList
                       (list 'ExprStmt
                             (list 'AssignOp
                                   (list 'Id (ConcatCut (cadadaddddr Node)))
                                   '(Const "0")))
                       (list 'IfElse
                             (list 'EqPred
                                   (list 'At
                                         (caddadddaddddr Node)
                                         (list 'Id (concat (cadaddaddddr Node) 'First)))
                                   '(Const "0"))
                             (list 'Goto 
                                   (list 'Id (SetRefer (cadddr Node) 'Put))) 
                             (list 'ExprStmt
                                   (list 'AssignOp
                                         (list 'Id
                                               (cadadaddddr Node))
                                         (list 'At 
                                               (caddadddaddddr Node)
                                               (list 'Id
                                                     (concat (cadaddaddddr Node) 'First))))))))))
              (t
               (return 
                (list 
                 (cadr Node)
                 (SetRefer (caddr Node) 'Put)
                 (list (caddr Node) (cadddr Node))
                 (list 'StmtList
                       (list 'StmtList
                             (list 'ExprStmt
                                   (list 'AssignOp
                                         (list 'Id (ConcatCut (cadadaddddr Node)))
                                         '(Const "0")))
                             (list 'If
                                   (list 'EqPred
                                         (list 'Id (concat (cadaddaddddr Node) 'Head))
                                         '(Const "0"))
                                   (list 'Goto 
                                         (list 'Id (SetRefer (cadddr Node) 'Put)))))
                       (list 'ExprStmt
                             (list 'AssignOp
                                   (list 'Id (cadadaddddr Node))
                                   (list 'Id (concat (cadaddaddddr Node) 'Head)))))))))))


(defun Code016 (Node)
  (prog ()
        (cond ((equal (length (caddddr Node)) 4)
               (return
                (list
                 (cadr Node)
                 (SetRefer (cadddr Node) 'Put)
                 (list (cadddr Node) (cadddr Node) (caddr Node))
                 (list 'StmtList
                       (list 'StmtList
                             (list 'If
                                   (list 'Id
                                         (concat (cadadaddddr Node) 'Cut))
                                   (list 'Goto 
                                         (list 'Id (SetRefer (cadddr Node) 'Put))))
                             (list 'ExprStmt
                                   (list 'AssignOp
                                         (list 'Id
                                               (cadadaddddr Node))
                                         (list 'At 
                                               (list 'Id
                                                     (cadadaddddr Node))
                                               (list 'Id
                                                     (concat (cadaddaddddr Node) 'Next)))))) 
                       (list 'If
                             (list 'AndPred
                                   (list 'NEPred
                                         (list 'Id 
                                               (cadadaddddr Node))
                                         '(Const "0"))
                                   (CheckStringPred (cadddaddddr Node)))
                             (list 'Goto
                                   (list 'Id (SetRefer (caddr Node) 'Put))))))))
              (t
               (return
                (list 
                 (cadr Node)
                 (SetRefer (caddr Node) 'Put)
                 (list (caddr Node) (cadddr Node) (cadddr Node))
                 (list 'StmtList
                       (list 'StmtList
                             (list 'If
                                   (list 'Id
                                         (concat (cadadaddddr Node) 'Cut))
                                   (list 'Goto 
                                         (list 'Id (SetRefer (cadddr Node) 'Put))))
                             (list 'ExprStmt
                                   (list 'AssignOp
                                         (list 'Id
                                               (cadadaddddr Node))
                                         (list 'At 
                                               (list 'Id
                                                     (cadadaddddr Node))
                                               (list 'Id
                                                     (concat (cadaddaddddr Node) 'Next)))))) 
                       (list 'If
                             (list 'EqPred
                                   (list 'Id 
                                         (cadadaddddr Node))
                                   '(Const "0"))
                             (list 'Goto
                                   (list 'Id (SetRefer (cadddr Node) 'Put)))))))))))
                                  
                                  
(defun Code017 (Node)
  (list 
   (cadr Node)
   (SetRefer (caddr Node) 'Put)
   (list (caddr Node) (cadddr Node))
   (list 'StmtList
         (list 'StmtList
               (list 'ExprStmt
                     (list 'AssignOp
                           (list 'Id (ConcatCut (cadadaddddr Node)))
                           '(Const "0")))
               (list 'If
                     (list 'EqPred
                           (list 'Id (concat (cadaddaddddr Node) 'Head))
                           '(Const "0"))
                     (list 'Goto 
                           (list 'Id (SetRefer (cadddr Node) 'Put)))))
         (list 'ExprStmt
               (list 'AssignOp
                     (list 'Id (cadadaddddr Node))
                     (list 'Id (concat (cadaddaddddr Node) 'Head)))))))


(defun Code018 (Node)
  (list
   (cadr Node)
   (SetRefer (caddr Node) 'Put)
   (list (caddr Node) (cadddr Node) (cadddr Node))
   (list 'StmtList
         (list 'StmtList
               (list 'If
                     (list 'Id
                           (concat (cadadaddddr Node) 'Cut))
                     (list 'Goto 
                           (list 'Id (SetRefer (cadddr Node) 'Put))))
               (list 'ExprStmt
                     (list 'AssignOp
                           (list 'Id
                                 (cadadaddddr Node))
                           (list 'At 
                                 (list 'Id
                                       (cadadaddddr Node))
                                 (list 'Id
                                       (concat (cadaddaddddr Node) 'Next)))))) 
         (list 'If
               (list 'EqPred
                     (list 'Id 
                           (cadadaddddr Node))
                     '(Const "0"))
               (list 'Goto
                     (list 'Id (SetRefer (cadddr Node) 'Put)))))))


(defun Code019 (Code Stmt Flag)
  (list 'CompndStmtWDListSList
        (list 'DeclSpecWVars 
              '(Int) 
              (list 'InitDecl 
                    (list 'Id Flag) 
                    '(Const "0"))) 
        (list 'StmtList
              Code
              (list 'If
                    (list 'Id Flag)
                    Stmt))))


(defun Code020 (Code Stmt1 Stmt2 Flag)
  (list 'CompndStmtWDListSList
        (list 'DeclSpecWVars 
              '(Int) 
              (list 'InitDecl 
                    (list 'Id Flag) 
                    '(Const "0"))) 
        (list 'StmtList
              Code
              (list 'IfElse
                    (list 'Id Flag)
                    Stmt1
                    Stmt2))))
         

