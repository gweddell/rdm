;***********************************************************************
;***********************************************************************

(defun RestoreList (L)
  (prog ()
        (if (null L) (return nil))
        (if (atom L) (return (list L)))
        (if (equal (car L) 'Id) (return (cdr L)))
        (return (append (RestoreList (cadr L)) (RestoreList (caddr L))))))


(defun RestoreFieldList (L)
  (prog ()
        (if (null L) (return nil))
        (if (atom L) (return (list (list 'Field L))))
        (return (cons (list 'Field (cadr L)) (RestoreFieldList (caddr L))))))


(defun RestoreArgExpList (L)
  (prog ()
        (if (null L) (return nil))
        (if (equal (car L) 'ArgExpList) (return (append1 (RestoreArgExpList (cadr L)) (caddr L))))
        (return (list L))))


(defun RestoreIdList (L)
  (prog ()
        (if (null L) (return nil))
        (if (equal (car L) 'IdList) (return (append1 (RestoreIdList (cadr L)) (caddr L))))
        (return (list L))))


(defun RestoreAndPredList (L)
  (prog ()
        (if (null L) (return nil))
        (if (equal (car L) 'AndPred) (return (cons (cadr L) (RestoreAndPredList (caddr L)))))
        (return (list L))))


(defun FixInput (PDMcode) 
  (prog (F S) 
        (setq F PDMcode S nil) 
        loop 
        (if (null F) (return (car S))) 
        (case (car F) 
               (0 (rplaca S (list (car S)))) 
               (1 (rplaca S (list (car S) (cadr S))) (rplacd S (cddr S))) 
               (2 (rplaca S (list (car S) (caddr S) (cadr S))) (rplacd S (cdddr S))) 
               (3 (rplaca S (list (car S) (cadddr S) (caddr S) (cadr S))) (rplacd S (cddddr S))) 
               (4 (rplaca S (list (car S) (caddddr S) (cadddr S) (caddr S) (cadr S))) (rplacd S (cdddddr S))) 
               (5 (rplaca S (list (car S) (cadddddr S) (caddddr S) (cadddr S) (caddr S) (cadr S))) (rplacd S (cddddddr S))) 
               (6 (rplaca S (list (car S) (caddddddr S) (cadddddr S) (caddddr S) (cadddr S) (caddr S) (cadr S))) 
                  (rplacd S (cdddddddr S))) 
               (**error** (exit))
               (t (setq S (cons (car F) S)))) 
        (setq F (cdr F)) 
        (go loop))) 


(defun PrintMsg (Message)
  (princ Message errport)
  (terpri errport))


(defun ErrorMsg (L)
  (prog ()
        (do ((Temp L (cdr Temp))) ((null Temp))
            (princ (car Temp) errport)
            (princ " " errport))
        (terpri errport)
        (exit)))


(defun CMatch (Pat L)
  (cond ((null (Match Pat L)) 
         (PrintMsg "*****warning: from Pattern matcher")
         (princ Pat errport))))


(defun GenerateName (Name)
  (prog ()
        (cond ((equal Name 'SchemaVar)
               (setq @SchemaVar (add1 @SchemaVar))
               (return (concat 'PDMCSchemaVar @SchemaVar)))
              ((equal Name 'Dummy)
               (setq @Dummy (add1 @Dummy))
               (return (concat 'PDMCDummy @Dummy)))
              ((equal Name 'Compare)
               (setq @Compare (add1 @Compare))
               (return (concat 'PDMCCompare @Compare)))
              ((equal Name 'Label)
               (setq @Label (add1 @Label))
               (return (concat 'PDMCLabel @Label)))
				  )))


(defun GenStructDeclCode (Name1 Name2 Name3)
  (prog (Temp)
        (if (atom Name1) 
            (setq Name1 (list 'Id Name1)))
        (if (not (Match `(* (Type ,Name2 >* P) *) InfoList))
            (ErrorMsg  `("***PDMC Error: prop" ,Name2 "has not been defined.")))
        (cond ((equal (car (Build '(<< P))) 'Integer)
               (setq Temp (list Name3 '(IntType) Name1)))
              ((equal (car (Build '(<< P))) 'Real)
               (setq Temp (list Name3 '(LongType) Name1)))
              ((equal (car (Build '(<< P))) 'DoubleReal)
               (setq Temp (list Name3 '(DoubleType) Name1)))
              ((equal (car (Build '(<< P))) 'String)
					(cond ((member (car Name1) '(FuncVar FuncVarWPIdList FuncVarWPTList))
							 (setq Temp `(,Name3 (CharType) (BangOp ,Name1))))
							(t
							 (setq Temp `(,Name3 (CharType) (ArrayVarWSize ,Name1 (Const ,(caddadadr (Build '(<< P))))))))))
              (t
               (CMatch `(* (Reference ,(car (Build '(<< P))) > Q) *) InfoList)
               (cond ((equal '(Direct) (Build '(< Q)))
                      (setq Temp `(,Name3 (StructWId (Id ,(car (Build '(<< P))))) (PtrVar (Ptr) ,Name1))))
                     (t
                      (setq Temp `(,Name3 (StructWId (Id ,(car (Build '(<< P))))) (PtrVar (PtrPtr (Ptr)) ,Name1)))))))
        (return Temp)))


(defun CheckStringPred (Code)
  (prog (Temp Result)
		  (cond ((equal (caadr Code) 'At)
					(setq Temp (cadr Code)))
				  (t
					(setq Temp (caddr Code))))
		  (setq Result Code)
		  (if (equal (PathFuncClass Temp) 'String)
				(cond ((equal (car Code) 'EqPred)
						 (setq Result
						  `(EqPred (FuncCallP (Id strcmp) (ArgExpList ,(cadr Code) ,(caddr Code))) (Const "0"))))
						((equal (car Code) 'NEPred)
						 (setq Result
						  `(NEPred (FuncCallP (Id strcmp) (ArgExpList ,(cadr Code) ,(caddr Code))) (Const "0"))))
						(t
						 (PrintMsg "*****warning: from CheckStringPred"))))
		  (setq Result (ProcessIndexSpecCode Result))
		  (do ((Temp (car ScopeList) (cdr Temp))) ((null Temp))
				(setq Result (subst `(FieldAcc (Id PDMCQStruct) (Id ,(caar Temp))) `(Id ,(caar Temp)) Result)))
		  (return Result)))

