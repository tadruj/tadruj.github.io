#lang racket
(define x (cons 1 2)) ; new type constructor
(cdr x) ; new type selector
(car x) ; new type selector
(newline) ; constant

; closure property of cons = property that it can take functions as arguments
; these functions then formulate a functional version of a linked-list or just list
(cons 1
      (cons 2
            (cons 3
                  (cons 4 null))))
