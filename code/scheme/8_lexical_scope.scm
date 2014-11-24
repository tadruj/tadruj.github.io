#lang racket
; hiding sub functions in the scope of a function and lexically scoping them 
; = (using x from square-root in all sub-functions without passing it explicitly)

(define (square-root x)
  (define (in-tolerance? g t) (< (abs (- x (* g g))) t))

  (define (guess g) (/ (+ (/ x g) g) 2))

  (define (square-root-core g t) 
    (if
      (in-tolerance? g t)
      g
      (square-root-core (guess g) t)))
  (square-root-core 1 (/ x 1000000)))

(square-root 0.0000002)
(sqrt 0.0000002)
