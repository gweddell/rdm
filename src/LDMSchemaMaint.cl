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

;************************** SCHEMA MAINTENANCE *************************
;***********************************************************************
; The following functions add or delete schema information.
;***********************************************************************

(defun NewClass (C)
   (if (Class? C) (ReportError `(ClassExists ,C)))
   (putprop C t 'Class?)
   (putprop C nil 'SupClasses)
   (putprop C nil 'ClassProps)
   (putprop C nil 'ClassConstraints)
   (putprop C nil 'ClassIndices)
   (putprop C nil 'ClassDistIndices)
   (setq Classes (cons C Classes)))

(defun AddSupClasses (C CList)
   (putprop C (append CList (SupClasses C)) 'SupClasses))

(defun AddClassProps (C PList)
   (putprop C (append PList (ClassProps C)) 'ClassProps))

(defun DelClassProp (C P)
   (putprop C (remove P (ClassProps C)) 'ClassProps))

(defun AddClassConstraints (C ConList)
   (putprop C (append ConList (ClassConstraints C)) 'ClassConstraints))

(defun AddClassIndex (C I)
   (putprop C (cons I (ClassIndices C)) 'ClassIndices))

(defun AddClassDistIndex (C I)
   (putprop C (cons I (ClassDistIndices C)) 'ClassDistIndices))

(defun NewProp (P C)
   (if (Prop? P) (ReportError `(PropExists ,P)))
   (putprop P t 'Prop?)
   (putprop P C 'PropType)
   (putprop P nil 'PropConstraint)
   (setq Properties (cons P Properties)))
  
(defun AddPropConstraint (P Con) (putprop P Con 'PropConstraint))

(defun NewClassProps (CPList)
   (mapc
      #'(lambda (CPDecl)
         (NewProp (cadr CPDecl) (caddr CPDecl))
         (AddClassProps (car CPDecl) (list (cadr CPDecl))))
      CPList))

(defun NewQuery (N Body)
   (if (Query? N) (ReportError `(QueryExists ,N)))
   (putprop N t 'Query?)
   (putprop N Body 'QueryBody)
   (setq Queries (cons N Queries)))

(defun NewTrans (N Body)
   (if (Trans? N) (ReportError `(TransExists ,N)))
   (putprop N t 'Trans?)
   (putprop N Body 'TransBody)
   (setq Transactions (cons N Transactions)))
   
;***********************************************************************
; Determines all superclasses and subclasses of each class; computes the
; values of the SupClasses*, SubClasses and SubClasses+ properties for
; each class.
; NOTE: may be safely reapplied.
;***********************************************************************

(defun IsaClose ()
   (mapc #'(lambda (C)
         (putprop C nil 'SupClasses*)
         (putprop C nil 'SubClasses+)
         (putprop C nil 'SubClasses)) Classes)
   (mapc #'(lambda (C) (GenIsaClose C C)) Classes)
   (mapc #'(lambda (C)
         (putprop C (remove C (SubClasses+ C)) 'SubClasses+)
         (do ((SCList (SupClasses C) (cdr SCList))) ((null SCList))
            (putprop (car SCList)
               (cons C (SubClasses (car SCList))) 'SubClasses)))
      Classes))

(defun GenIsaClose (C SC)
   (if (not (member SC (SupClasses* C)))
      (progn 
         (putprop C (cons SC (SupClasses* C)) 'SupClasses*)
         (putprop SC (cons C (SubClasses+ SC)) 'SubClasses+)
         (do ((SCList (SupClasses SC) (cdr SCList))) ((null SCList))
            (if (eq C (car SCList)) 
               (ReportError '(CyclicSchema))
               (GenIsaClose C (car SCList)))))))
