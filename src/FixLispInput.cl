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

(defun caddddddr (L) (caddr (cddddr L)))
(defun cadddddr (L) (cadr (cddddr L)))
(defun caddddr (L) (car (cddddr L)))
(defun cdddddddr (L) (cdddr (cddddr L)))
(defun cddddddr (L) (cddr (cddddr L)))
(defun cdddddr (L) (cdr (cddddr L)))

(defun p () 
  (prog (Port Code)
		  (setq Port (open "isc.internal.in")) 
		  (setq Code (FixInput (read Port))) 
		  (close Port) 
		  (setq Port (open "isc.internal.out" :direction :output
                     :if-does-not-exist :create
                     :if-exists :supersede))
		  (pprint Code Port)
		  (close Port)
		  (quit)))

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
					(t (setq S (cons (car F) S)))) 
		  (setq F (cdr F)) 
		  (go loop))) 

(p)
