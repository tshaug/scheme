; Working with Scheme Revival Project 
; Thomas Haug
; Copyright 2015
; multiple values (see The Scheme Programming Language 4th Edition, Section 5.8. Multiple Values, P 108)
(import (rnrs))
; this procedure returns 2 values
(define (car-cdr ls)
   (values (car ls) (cdr ls))
)

; (call-with-values producer consumer)
; producer and consumer are procedures
; the producer procedure must have zero arguments
; this procedure consumes 2 values
(define (combine ls)
  (call-with-values 
     (lambda () (car-cdr ls)) ; produces two values 
     (lambda (x y) (cons x y))
  )
)
