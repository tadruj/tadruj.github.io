#lang racket

; basic operators
(+ 10 5)
(- 10 5)
(/ 10 5)
(* 10 5)
 
(+
(+ 3 5)
(+ 4 7))

; defining new names
(define (square x) (* x x))
    
(define pi 3.14159265359)

(define 
  (circumference radius)
  (* 2 pi radius)
)

(circumference 12)

; conditions
(define (abs x)
  (cond 
    ((< x 0) (- x))
    (else x)
  )  
)

(abs 2)
(abs -2)

(define (abs-if x)
  (if 
    (< x 0)
    (- x)
    x
  )
)
        
(abs-if 2)
(abs-if -2)   

; first class functions

(define (abs-oper x)
  ((if (< x 0) - +) x)
)

(abs-oper 2)
(abs-oper -2)
