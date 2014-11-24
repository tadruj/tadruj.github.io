; iterative procedure
(define (faktorial n)
  (define (faktorial-iter r c n)
    (if (> c n)
        r
        (faktorial-iter (* r c) (+ c 1) n)) ; pure
    )
  
  (faktorial-iter 1 1 n))

(faktorial 1)
(faktorial 2)
(faktorial 3)
(faktorial 4)
(faktorial 5)