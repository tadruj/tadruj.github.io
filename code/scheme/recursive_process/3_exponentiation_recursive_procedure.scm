; recursive process and recursive procedure
(define (exponentiate b n)
  (if (= n 0)
  1
  (* b (exponentiate b (- n 1))))) ; dirty

(exponentiate 2 1)
(exponentiate 2 2)
(exponentiate 2 3)
(exponentiate 2 4)