;***********************************************************************
; Copyright (C) 1989, G. E. Weddell.
;***********************************************************************

(trace
   (ApplyRuleControl if (atom (arg 1)) printargs
		     (lambda (args)
			(terpri)
			(patom "*** Rule: ")
			(print (car (setq ARG args)))
			(if (memq (car ARG) '(
PreJoinOrder
FailSQOptimize
PostAltFind
PostAltScan
				 )) then
			   (terpri)
			   (pp-form (cadr ARG)))))
   (ApplyRuleControl if (atom (arg 1)) printres
		     (lambda (args)
			(terpri)
			(if args then
			   (if (memq (car ARG) '(
PreJoinOrder
PreSQOptimize
FindEVarProject
PreAltFind
CreateLogicalScan
NoScanPossible
PostAltFind
SubstituteIntro
CondSubstituteIntro
PreAltScan
QualPFIntro
QualSCIntro
PostAltScan
ReplaceSubstitute
ReplaceSubstitute2
EstimateFindCost
				 )) then
			      (patom "*** Result is:")
			      (pp-form (cadr ARG))
			    else
			      (patom "*** Applied."))
			 else
			   (patom "*** NotApplied."))
			(terpri)(terpri))))
