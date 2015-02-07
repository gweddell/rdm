;***********************************************************************
; Copyright (C) 1989, G. E. Weddell.
;***********************************************************************

;**************************** PASS THREE *******************************

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
; This pass determines the choice of object identification.  There
; are currently three possibilities.  A system class for the schema
; is also generated.
;
;    System     - the object identification for built-in classes.
;    Pointer    - address of a record storing all property values.
;    IndPointer - address of a cell containing an address of a record
;                 storing all property values.
;
;***********************************************************************

(defun PassThree ()
   (AddSchemaClass)
   (FindObjectIdRep)
   (AddMscProperty)
   (AddPropertiesForIndices)
   (AddPropertiesForStores)
   (GenInitTransaction)
   (CheckProperties)
   (AddEntityClass)
   (IsaClose)
   (GenerateTreeSchema))


(defun AddSchemaClass ()
   (NewClass (concat Schema 'Struct))
   (putprop (concat Schema 'Struct) t 'UserClass?)
   (NewProp (concat Schema 'Struct) (concat Schema 'Struct)))


(defun FindObjectIdRep ()
   (mapc #'(lambda (C) (putprop C 'Pointer 'ClassReference)) Classes)
   (mapc 'ChgIdCheck (mapcar 'TransBody Transactions)))


(defun ChgIdCheck (L)
   (if
      (Match
         '(? ? ? (Block ? * (Assign (Apply (? ? > C) (* Id)) > T)
            where (or
               (eq 'Pointer (ClassReference <q C))
               (eq 'Pointer (ClassReference (Type <q T))))
            *) *)
         L)
      (mapc #'(lambda (SC) (putprop SC 'IndPointer 'ClassReference))
         (append
            (eval (Build '(ReachableClasses <q C ())))
            (eval (Build '(ReachableClasses (Type <q T) ())))))))


;***********************************************************************
; ReachableClasses computes the familty of a class; that is, all classes
; that are reachable via subclass or superclass links.
;***********************************************************************

(defun ReachableClasses (C L)
   (setq L (cons C L))
   (do ((CList (append (SupClasses C) (SubClasses C))
         (cdr CList)))
         ((null CList))
      (if (not (member (car CList) L)) (setq L (ReachableClasses (car CList) L))))
   L)


;***********************************************************************
; AddMscProperty add the system Msc property to the schema, and determines
; Msc values for each class.  Note that the range constraint on the Msc
; property is calculated as 2**(MaxFamilySize-1), where MaxFamilySize
; is the maximum number of non-covered classes in a class family.
;***********************************************************************

(defun AddMscProperty ()
   (mapc #'(lambda (C) (putprop C 0 'ClassMscSumVal)) Classes)
   (prog (MaxMscVal NextMscVal TopCList C ReachCList)
      (setq MaxMscVal 0)
      (setq TopCList Classes)
    loop
      (if (null TopCList)
         (progn (NewProp 'Msc 'Integer)
         (AddPropConstraint 'Msc `(Range 1 ,MaxMscVal))
         (return t)))
      (setq C (car TopCList) TopCList (cdr TopCList))
      (setq NextMscVal 1)
      (setq ReachCList (ReachableClasses C ()))
      (do ((ReachCList ReachCList (cdr ReachCList))) ((null ReachCList))
         (setq C (car ReachCList))
         (if (ClassCovers C)
            (putprop C 0 'ClassMscVal)
          (progn
            (putprop C NextMscVal 'ClassMscVal)
            (mapc
               #'(lambda (C)
                  (putprop C (add NextMscVal (ClassMscSumVal C))
                     'ClassMscSumVal))
               (SupClasses* C))
            (if (greaterp NextMscVal MaxMscVal)
               (setq MaxMscVal NextMscVal))
            (setq NextMscVal (times 2 NextMscVal))))
         (setq TopCList (remove C TopCList)))
      (go loop)))


(defun AddPropertiesForIndices () (mapc 'AddIndexProperties Indices))


(defun AddIndexProperties (I &aux C)
   (setq C (IndexClass I))
   (case (IndexType I)
      (List
         (NewClassProps `(
            (,(concat Schema 'Struct) ,(concat I 'Head) ,C)
            (,C ,(concat I 'Prev) ,C)
            (,C ,(concat I 'Next) ,C))))
      (DistList
         (NewClassProps `(
            (,(concat Schema 'Struct) ,(concat I 'Head) ,C)
            (,C ,(concat I 'Prev) ,C)
            (,C ,(concat I 'Next) ,C)
            (,(Dom (DistPF I)) ,(concat I 'First) ,C))))
      (DistPointer
         (NewClassProps `(
            (,(concat Schema 'Struct) ,(concat I 'Head) ,C)
            (,(Dom (DistPF I)) ,(concat I 'First) ,C))))
      (BinaryTree
         (NewClassProps `(
            (,(concat Schema 'Struct) ,(concat I 'Head) ,C)
            (,C ,(concat I 'LSon) ,C)
            (,C ,(concat I 'RSon) ,C)
            (,C ,(concat I 'Mark) Integer)))
         (AddPropConstraint (concat I 'Mark) '(Range 0 1)))
      (DistBinaryTree
         (NewClassProps `(
            (,(concat Schema 'Struct) ,(concat I 'Head) ,C)
            (,C ,(concat I 'LSon) ,C)
            (,C ,(concat I 'RSon) ,C)
            (,C ,(concat I 'Mark) Integer)
            (,(Dom (DistPF I)) ,(concat I 'First) ,C)))
         (AddPropConstraint (concat I 'Mark) '(Range 0 1)))))


(defun AddPropertiesForStores () (mapc 'AddStoreProperties Stores))


(defun AddStoreProperties (S)
   (case (StoreType S)
      (Dynamic (NewClassProps `( (,(concat Schema 'Struct) ,S StoreTemplate))))))


;***********************************************************************
; GenInitTransaction generates a new transaction call "InitS",
; where S is the schema name, which includes "init" operations
; for each store and index manager.
;***********************************************************************

(defun GenInitTransaction (&aux SInitL IInitL)
   (setq SInitL (mapcar #'(lambda (SName) `(SInit ,SName)) Stores))
   (setq IInitL (mapcar #'(lambda (IName) `(IInit ,IName)) Indices))
   (NewTrans
      (concat 'Init Schema)
      `(StmtTrans ,(concat 'Init Schema) ()
         (Block () ,@SInitL ,@IInitL))))


;***********************************************************************
; Let DomClasses denote the set of all classes declared by the user that
; explicitly include a given property P.  If a class exists that has two
; or more instances of DomClasses as superclasses, then CheckProperties
; declares a new class with P as its only property, removes P from each
; class in DomClasses, and makes each class in DomClasses a subclass of
; the newly introduced class.
;***********************************************************************

(defun CheckProperties ()
   (do ((CList Classes (cdr CList))) ((null CList))
      (do ((PList (ClassProps (car CList)) (cdr PList))) ((null PList))
         (CheckProp (car CList) (car PList))))
   (do ((PList Properties (cdr PList))) ((null PList))
      (remprop (car PList) 'NewDomClass)
      (remprop (car PList) 'DomClasses)))

(defun CheckProp (C P &aux GenNewDomClass)
   (if (get P 'NewDomClass)
    (progn
      (DelClassProp C P)
      (AddSupClasses C (list (get P 'NewDomClass))))
    (progn
      (setq GenNewDomClass nil)
      (putprop P (cons C (get P 'DomClasses)) 'DomClasses)
      (do ((SCList (SubClasses+ C))
           (CList (cdr (get P 'DomClasses)) (cdr CList)))
         ((or GenNewDomClass (null CList)))
         (if (not (null (SetIntersection SCList (SubClasses+ (car CList)))))
            (setq GenNewDomClass t)))
      (if GenNewDomClass
         (let ((NewC (gentemp "C")) C)
            (NewClass NewC)
            (AddClassProps NewC (list P))
            (putprop P NewC 'NewDomClass)
            (do ((CList (get P 'DomClasses) (cdr CList))) ((null CList))
               (setq C (car CList))
               (DelClassProp C P)
               (AddSupClasses C (list NewC))))))))


;***********************************************************************
; Adds the Entity class, together with the Msc property, as a
; superclass of all classes not built-in (such as Integer).
;***********************************************************************

(defun AddEntityClass ()
   (mapc #'(lambda (C)
      (if (and (null (SupClasses C))
               (not (member C BuiltInClasses)))
         (AddSupClasses C '(Entity))))
      Classes)
   (NewClass 'Entity)
   (AddClassProps 'Entity '(Msc)))


;***********************************************************************
; Generate the tree schema.  See reference "Efficient property access
; in memory resident object oriented databases" for details.
;***********************************************************************

(defun GenerateTreeSchema ()
   (prog (St CR1 CList C CLi CRj CTrail CCom PCList)
      (setq St '(Entity))
    loop1
      (if (null St) (return t))
      (setq CR1 (car St)) (setq St (cdr St))
      (setq CList (SubClasses CR1))
    loop2
      (if (null CList) (go loop1))
      (setq C (car CList)) (setq CList (cdr CList))
      (if (null (ClassExtension C))
       (progn 
         (putprop C CR1 'ClassExtension)
         (setq St (cons C St))
         (go loop2)))
      (setq CCom CR1)
      (setq PCList nil)
      (setq CLi C)
    loop3
      (setq CLi (ClassExtension CLi))
      (setq PCList (cons CLi PCList))
      (if (not (eq CLi 'Entity)) (go loop3))
    loop4
      (if (member CCom PCList) (go cont))
      (setq CCom (ClassExtension CCom))
      (go loop4)
    cont
      (setq CLi (ClassExtension C))
      (setq CRj CR1)
      (setq CTrail C)
    loop5
      (if (and (eq CLi CCom) (eq CRj CCom)) (go loop2))
      (if (or (eq CLi CCom)
              (and (not (member CRj (SupClasses* CLi)))
                   (greaterp
                      (times
                         (diff (SizeEst CLi) (SizeEst C))
                         (length (ClassProps CRj)))
                      (times
                         (diff (SizeEst CRj) (SizeEst C))
                         (length (ClassProps CLi))))))
       (progn
         (putprop CTrail CRj 'ClassExtension)
         (setq CRj (ClassExtension CRj)))
       (progn
         (putprop CTrail CLi 'ClassExtension)
         (setq CLi (ClassExtension CLi))))
      (setq CTrail (ClassExtension CTrail))
      (go loop5)))
