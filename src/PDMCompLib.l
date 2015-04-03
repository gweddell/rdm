;***********************************************************************
;***********************************************************************

(defun caadddr (L) (car (cadddr L)))
(defun cadadar (L) (car (cdadar L)))
(defun cadaddr (L) (car (cdaddr L)))
(defun caddadr (L) (car (cddadr L)))
(defun cadddar (L) (car (cdddar L)))
(defun caddddr (L) (car (cddddr L)))
(defun cddadar (L) (cdr (cdadar L)))
(defun cdddddr (L) (cdr (cddddr L)))
(defun caaddddr (L) (caar (cddddr L)))
(defun cadadadr (L) (cadr (cadadr L)))
(defun cadaddar (L) (cadr (caddar L)))
(defun cadadddr (L) (cadr (cadddr L)))
(defun cadddadr (L) (cadr (cddadr L)))
(defun caddddar (L) (cadr (cdddar L)))
(defun cadddddr (L) (cadr (cddddr L)))
(defun cddddddr (L) (cddr (cddddr L)))
(defun caaddddar (L) (caadr (cdddar L)))
(defun cadaddadr (L) (cadar (cddadr L)))
(defun cadadddar (L) (cadar (cdddar L)))
(defun caddadadr (L) (caddr (cadadr L)))
(defun caddaddar (L) (caddr (caddar L)))
(defun cadddddar (L) (caddr (cdddar L)))
(defun caddddddr (L) (caddr (cddddr L)))
(defun cdadddadr (L) (cdadr (cddadr L)))
(defun cdddddddr (L) (cdddr (cddddr L)))
(defun cadaddadar (L) (cadadr (cdadar L)))
(defun cadaddddar (L) (cadadr (cdddar L)))
(defun caddadddar (L) (caddar (cdddar L)))
(defun caddddddar (L) (cadddr (cdddar L)))
(defun cadadaddddr (L) (car (cdadar (cddddr L))))
(defun cadadddddar (L) (car (cdaddr (cdddar L))))
(defun caddaddddar (L) (car (cddadr (cdddar L))))
(defun cadddaddddr (L) (car (cdddar (cddddr L))))
(defun caadaddddadr (L) (caar (cdaddr (cddadr L))))
(defun cadaddaddddr (L) (cadr (caddar (cddddr L))))
(defun cadadddddadr (L) (cadr (cadddr (cddadr L))))
(defun cadaddddddar (L) (cadr (cadddr (cdddar L))))
(defun cadaddaddddar (L) (cadar (cddadr (cdddar L))))
(defun cadaddddddadr (L) (cadar (cddddr (cddadr L))))

(defun append1 (L e) (append L (list e)))

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
               (**error** (quit))
               (t (setq S (cons (car F) S)))) 
        (setq F (cdr F)) 
        (go loop))) 


(defun PrintMsg (Message)
  (princ Message *error-output*)
  (terpri *error-output*))


(defun ErrorMsg (L)
  (prog ()
        (do ((Temp L (cdr Temp))) ((null Temp))
            (princ (car Temp) *error-output*)
            (princ " " *error-output*))
        (terpri *error-output*)
        (quit)))


(defun CMatch (Pat L)
  (cond ((null (Match Pat L)) 
         (PrintMsg "*****warning: from Pattern matcher")
         (princ Pat *error-output*))))


(defun GenerateName (Name)
  (prog ()
        (cond ((equal Name 'SchemaVar)
               (setq @SchemaVar (add1 @SchemaVar))
               (return (concat '|PDMCSchemaVar| (make-symbol (write-to-string @SchemaVar)))))
              ((equal Name 'Dummy)
               (setq @Dummy (add1 @Dummy))
               (return (concat '|PDMCDummy| (make-symbol (write-to-string @Dummy)))))
              ((equal Name 'Compare)
               (setq @Compare (add1 @Compare))
               (return (concat '|PDMCCompare| (make-symbol (write-to-string @Compare)))))
              ((equal Name 'Label)
               (setq @Label (add1 @Label))
               (return (concat '|PDMCLabel| (make-symbol (write-to-string @Label))))))))


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
						  `(EqPred (FuncCallP (Id |strcmp|) (ArgExpList ,(cadr Code) ,(caddr Code))) (Const "0"))))
						((equal (car Code) 'NEPred)
						 (setq Result
						  `(NEPred (FuncCallP (Id |strcmp|) (ArgExpList ,(cadr Code) ,(caddr Code))) (Const "0"))))
						(t
						 (PrintMsg "*****warning: from CheckStringPred"))))
		  (setq Result (ProcessIndexSpecCode Result))
		  (do ((Temp (car ScopeList) (cdr Temp))) ((null Temp))
				(setq Result (subst `(FieldAcc (Id |PDMCQStruct|) (Id ,(caar Temp))) `(Id ,(caar Temp)) Result :test #'equal)))
		  (return Result)))

