open Lazy

let rec 
	a (c) = 1 + b 1 (* recursive function has to have a variable *)
and 
	b (c) = 2 + 1

(* let rec 
	a (c) = lazy (1 + b 1)
and 
	b (c) = 2 + 1
 *)

(* 

let rec (p: (string, unit) t) s =
  s |> (char '(' >> opt "" p << char ')' |>> (fun content -> "(" ^ content ^ ")"))

let rec (p: (string, unit) t) =
        char '(' >> opt "" p << char ')' |>> (fun content-> "(" ^ content ^ ")")

 *)