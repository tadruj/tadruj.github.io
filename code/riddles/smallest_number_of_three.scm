#lang racket
; SICP: Exercise 1.3
; algo: find the smallest number and then square the other two; watch for the equals

(define (square x) (* x x))

(define (sum-square-two-max x y z)
  (cond
    ((and (<= x y) (<= x z)) (+ (square y) (square z)))
    ((and (<= y x) (<= y z)) (+ (square x) (square z)))
    ((and (<= z x) (<= z y)) (+ (square x) (square y)))
  )  
)
   
(sum-square-two-max 1 2 3)
(sum-square-two-max 3 2 1)
(sum-square-two-max 1 3 2)

(sum-square-two-max 4 4 3)
(sum-square-two-max 4 3 4)

(sum-square-two-max 3 4 4)

(sum-square-two-max 2 2 3)
(sum-square-two-max 2 3 2)
(sum-square-two-max 3 2 2)  

(sum-square-two-max 4 6 5)
