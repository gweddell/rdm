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

;***********************************************************************
; Reports syntax and semantic errors to the standard error file.
;
; Expects a list of atoms as an argument: the first atom
; identifies the message text, the remaining atoms are
; message arguments. e.g.
;
;      (ReportError '(UndefProp <PName> query <QName>))
;
; prints:
;
;    ** error: symbol <PName> occurring in query <QName>
;              is not a property.
;
; Note: ReportError terminates execution; ReportWarning allows the
;       compiler to continue execution.
;***********************************************************************

(defun ReportError (Msg)
   (princ "** error: " *error-output*)
   (do ((Text
      (coerce (cadr (assoc (car Msg) '(
         (CyclicSchema "class schema is cyclic.")
         (UndefVar "undefined variable ? in ? ?.")
         (UndefProp "symbol ? occurring in ? ?/is not a property.")
         (UndefClass "symbol ? occurring in ? ?/is not a class.")
         (NotUserClass "symbol ? occurring in ? ?/is not a user-defined class.")
         (ClassExists "class ? multiply defined.")
         (PropExists "property ? multiply defined.")
         (QueryExists "query ? multiply defined.")
         (TransExists "transaction ? multiply defined.")
         (IndexExists "index ? multiply defined.")
         (StoreExists "store ? multiply defined.")
         (MultipleClassProp "multiply defined property ? in class ?.")
         (MultipleClassStore "multiply defined store for class ?.")
         (UndefClassStore "missing store declaration for class ?.")
         (BadStaticStore "missing subclasses in static store ?.")
         (BadPfdConstraint "bad path function in pfd constraint for class ?.")
         (BadCoverConstraint "illegal class in cover constraint for class ?.")
         (BadPfInExpr "illegal path function in ? ?.")
         (BadVarDecl "mismatched types for variable declaration in ? ?.")
         (BadVarType "undefined variable type declared in ? ?.")
         (BadCreate "creating object for covered class in transaction ?.")
         (BadArithExpr "bad form for arithmetic expression in ? ?.")
         (BadAssign "illegal assignment in transaction ?.")
         (BadIndexDistPF "illegal distributed path function for index ?.")
         (BadIndexPFSort "illegal path function sort for index ?.")
         (BadIndexSCSort "illegal subclass sort for index ?.")
         ))) 'list) (cdr Text)))
      ((null Text) (terpri *error-output*))
      (case (car Text)
         (#\?
            (setq Msg (cdr Msg))
            (princ (car Msg) *error-output*))
         (#\/
            (terpri *error-output*)
            (princ "          " *error-output*))
         (t
            (princ (car Text) *error-output*))))
   (quit))

(defun ReportWarning (Msg)
   (princ "** warning: " *error-output*)
   (do ((Text
      (coerce (cadr (assoc (car Msg) '(
         (NoStrategyFound "no execution strategy for query ? has been found.")
         (SortUsed "a sort operation for query ? has been used.")
         (ProjectionUsed "a projection operation for query ? has been used.")
         ))) 'list) (cdr Text)))
      ((null Text) (terpri *error-output*))
      (case (car Text)
         (#\?
            (setq Msg (cdr Msg))
            (princ (car Msg) *error-output*))
         (#\/
            (terpri *error-output*)
            (princ "          " *error-output*))
         (t
            (princ (car Text) *error-output*)))))
