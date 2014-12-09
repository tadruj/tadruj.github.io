let square x = x * x

let ratio x y = 
    Float.of_int x /. Float.of_int y
;;

let isMoreThanOne test x y =
    if test x y > 1. then true else false
;; 

let isMoreThanOneAnnotated (test : int -> int -> float) (x : int) (y : int) =
    if test x y > 1. then true else false
;; 


