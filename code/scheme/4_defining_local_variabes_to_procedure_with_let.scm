#lang racket
; defining local variables with let
(define (f x y)
  (let ((a (+ 1 (* x y)))
        (b (- 1 y)))
    (+ (* x (* a a))
       (* y b)
       (* a b))))

(define (test x)
  (let ((a (* 2 x))
        (b (* x x)))
    (* a b)))

(test 1)
(test 2)
(test 3)
