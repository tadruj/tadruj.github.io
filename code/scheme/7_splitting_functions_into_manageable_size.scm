#lang racket
; recursive and iterative implementation of f which is defined by the rule that
; f(n) = n if n<3 and f(n) = f(n - 1) + 2f(n - 2) + 3f(n - 3) if n> 3

(define (f n)
  (if (< n 3)
      n
      (+ (f (- n 1)) (* 2 (f (- n 2))) (* 3 (f (- n 3))))))

(define (h x y z c) ; x being f(n-1), y f(n-2)... and c the iteration counter
  (if (= c 2) 
      x
      (h (+ x (* 2 y) (* 3 z)) x y (- c 1))))

(define (g n) ; wrap for the h with starting arguments and a condition
  (if (< n 3)
      n
      (h 2 1 0 n)))

(f 1)
(f 2)
(f 3)
(f 4)
(f 5)

(g 1)
(g 2)
(g 3)
(g 4)
(g 5)
