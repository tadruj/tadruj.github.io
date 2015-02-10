;; some exercises from 4clojure

(ns clojure-exercises)

;; penultimate
((comp (partial first) rest reverse) [1 2 3 4])
((comp last butlast) [1 2 3 4])

;; nth
(#(first (drop %2 %1)) [1 2 3 4] 2)
(#((vec %1) %2)[1 2 3 4] 2)

;; count
(#(reduce (fn [counter _] (+ counter 1)) 0 %1) [1 2 3 4])
(#(reduce + (map (constantly 1) %1)) [1 2 3 4 5])
((comp (partial reduce +) (partial map (constantly 1))) [1 2 3 4 5])
