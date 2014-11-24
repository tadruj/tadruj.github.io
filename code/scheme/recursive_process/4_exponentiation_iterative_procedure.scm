; recursive process and iterative procedure
(define (exponentiate-iter b n acc)
  (if (= n 0)
  acc
  (exponentiate-iter b (- n 1) (* b acc)))) ; pure

(exponentiate-iter 2 1 1)
(exponentiate-iter 2 2 1)
(exponentiate-iter 2 3 1)
(exponentiate-iter 2 4 1)