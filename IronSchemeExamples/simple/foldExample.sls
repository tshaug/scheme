;;; Joy of Scheme Revival Project 
;;; Thomas Haug
;;; Copyright 2015
;;; thomas.haug@mathema.de 


(library (foldExample)
  (export
    reverse3
    reverse2
	myFilter
	myFoldRight
	)
  
	(import 
	(rnrs)
	(ironscheme clr))
(define (reverse2 ls)
  (define (reverse2Inner ls acc)
    (if (null? ls)
      acc
      (reverse2Inner (cdr ls) (cons (car ls) acc))
      ) ; if
    ) ; define
  (reverse2Inner ls '())
  )

(define (reverse3 l)
  (if (null? l)
     '()
     (append (reverse3 (cdr l)) (list (car l)))
  )
)


; my fold-right impl
; definition (wiki):
;https://en.wikipedia.org/wiki/Fold_(higher-order_function)
;(myFoldRight func initialValue list)
; If the list is empty, the result is the initial value z. If not, apply f to the first element and the result of folding the rest.

(define (myFoldRight func initialValue list)
  (if (null? list)
      initialValue
      (func (car list) (myFoldRight func initialValue (cdr list)))
      )
  )


; my filter implementation
; definition
; https://en.wikipedia.org/wiki/Filter_(higher-order_function)
; (myFilter pred list)
(define (myFilter pred ls)
  (define (myFilter-Inner innerList resultList)
    (if (null? innerList)
        resultList
       (myFilter-Inner (cdr innerList)
                       (if (pred (car innerList))
                           (cons (car innerList) resultList)
                           resultList))
      )
    )
  (myFilter-Inner (reverse ls) '()) ; this is a HACK...
)


; DemoData
(define myList '(1 2 3 4))
(define myNestedList '(1 2 (3 4) 5))
)