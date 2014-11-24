#lang racket
; applicative-order evaluation would recurse indefinitely at (p)
; normal-order evaluation returns 0, because p never gets evaluated

(define (p) (p))
(define (test x y)
  (if (= x 0)
      0
      y
  )
)

(test 0 p)
