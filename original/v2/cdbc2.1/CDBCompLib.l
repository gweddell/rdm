;***********************************************************************
;***********************************************************************

(declare
  (special InfoList errport @SchemaVar))


(defun RestoreList (L)
  (prog ()
        (if (null L) (return nil))
        (if (atom L) (return (list L)))
        (if (equal (car L) 'Id) (return (cdr L)))
        (return (append (RestoreList (cadr L)) (RestoreList (caddr L))))))


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


(defun FixInput (PDMcode) 
  (prog (F S) 
        (setq F PDMcode S nil) 
        loop 
        (if (null F) (return (car S))) 
        (caseq (car F) 
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


(defun Print (Message)
  (patom Message errport)
  (terpri errport))


(defun Error (L)
  (prog (Temp)
        (do Temp L (cdr Temp) (null Temp)
            (patom (car Temp) errport)
            (patom " " errport))
        (terpri errport)
        (exit)))


(defun CMatch (Pat L)
  (cond ((null (Match Pat L)) 
         (Print "*****warning: from Pattern matcher")
         (patom Pat errport))))


(defun GenerateName (Name)
  (prog ()
        (cond ((equal Name 'SchemaVar)
               (setq @SchemaVar (add1 @SchemaVar))
               (return (concat 'CDBSchemaVar @SchemaVar))))))


(defun GenStructDeclCode (Name1 Name2 Name3)
  (prog (Temp)
        (if (atom Name1) 
            (setq Name1 (list 'Id Name1)))
        (if (not (Match `(* (Type ,Name2 >* P) *) InfoList))
            (Error  `("***CDB Error: prop" ,Name2 "has not been defined.")))
        (cond ((equal (car (Build '(<< P))) 'Integer)
               (setq Temp (list Name3 '(Int) Name1)))
              ((equal (car (Build '(<< P))) 'Real)
               (setq Temp (list Name3 '(Long) Name1)))
              ((equal (car (Build '(<< P))) 'DoubleReal)
               (setq Temp (list Name3 '(Double) Name1)))
              ((equal (car (Build '(<< P))) 'String)
               (setq Temp `(,Name3 (Char) (ArrayVarWSize ,Name1 (Const ,(caddadadr (Build '(<< P))))))))
              (t
               (CMatch `(* (Reference ,(car (Build '(<< P))) > Q) *) InfoList)
               (cond ((equal '(Direct) (Build '(< Q)))
                      (setq Temp `(,Name3 (StructWId (Id ,(car (Build '(<< P))))) (PtrVar (Ptr) ,Name1))))
                     (t
                      (setq Temp `(,Name3 (StructWId (Id ,(car (Build '(<< P))))) (PtrVar (PtrPtr (Ptr)) ,Name1)))))))
        (return Temp)))
