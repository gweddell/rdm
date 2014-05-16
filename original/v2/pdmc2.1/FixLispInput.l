
(setq user-top-level 'p)


(defun p () 
  (prog (Port Code)
		  (setq Port (fileopen "isc.internal.in" "r")) 
		  (setq Code (FixInput (read Port))) 
		  (close Port) 
		  (setq Port (fileopen "isc.internal.out" "w"))
		  (pp-form Code Port)
		  (close Port)
		  (exit)))



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
					(t (setq S (cons (car F) S)))) 
		  (setq F (cdr F)) 
		  (go loop))) 

