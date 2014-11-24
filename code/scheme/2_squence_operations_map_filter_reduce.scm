#lang scheme
; sequence operations
(map (lambda (x) (+ x 1)) (list 1 2 3 4))

(filter odd? (list 1 2 3 4))

(define (reduce op initial sequence)
  (if (null? sequence)
      initial
      (op (car sequence)
          (reduce op initial (cdr sequence)))))

(reduce + 0 (list 1 2 3 4 5))

(reduce (lambda (a b) (+ a b)) 0 (list 1 2 3 4 5))

(reduce (lambda (a b) (- b a)) 100 (list 1 2 3 4 5))
