#require "core"
open Core.Std

(* anonymous function *)
let a' = (fun a -> a + 7) 5

(* can be also expressed as *)
let b' = let b = 5 in b + 7;;

(* Passing a function to a function *)
let c' = List.map ~f:(fun x -> x + 1) [1;2;3]

(* Multiargument function *)
let d' a b  = a + b

(* Partially applied function *)
let e' = d' 5
let e'' = e' 6

;;printf "e'' = %i\n" e''

(* Multiargument function expressed in curried form *)
let f' = (fun y -> (fun x -> x + y))

(* Use of partial applicaton  *)
let add_three = f' 3

let g' = (add_three 4)

;;printf "g' = %i\n" g'

let rec destutter list =
	match list with
	(* OR pattern *)
	| [] | [_] -> None
	| first :: second :: tail ->
		if first = second then Some first
		else destutter (second::tail)

let h' = destutter [1;2;2;3;4]
;;printf "h' = %s\n" (match h' with Some x -> string_of_int x | None -> "None");;

(* Any infix function can be called in prefix notation by putting () around *)
(* infix function identifiers: !$%&*+-./:<=>?@^|~ *)
let i' = (+) 1 2

;;String.split ~on:':' @@ Sys.getenv_exn "PATH"
|> List.dedup ~compare:String.compare
|> List.iter ~f:(fun x -> printf "%s   " x)

(* Application operator and reverse application operator *)
let f x = x + 1
let g x = x + 2
let h'' = g (f 3)
let h''' = g @@ f @@ 3
let h'''' = 3 |> f |> g
(* This is cool stuff *)

(* function is shorter for function and a match *)
let some_or_zero = function
	| Some x -> x
	| None -> 0

let some_or_zero' foo = 
	match foo with
	| Some x -> x
	| None -> 0

let ratio ~numerator ~denominator = float numerator /. float denominator
let out1_ = ratio 3 4
let out2_ = ratio ~numerator:3 ~denominator:4
let out3_ = ratio ~denominator:3 ~numerator:4

(* label punning *)
let out4_ = let denominator = 3 in ratio ~denominator ~numerator:4
(* Ordering of labelled arguments matters in higher order function passing *)

(* Optional arguments *)
let concat' ?separator a b =
	let separator = match separator with None -> "" | Some s -> s in
	a ^ separator ^ b

let out5_ = concat' ~separator:" likes " "Johnny" "Jane"
let out6_ = concat' "Johnny" "Jane"

(* Optional arguments with default value *)
let concat'' ?(separator=" and ") a b =	a ^ separator ^ b
let out7_ = concat'' "Johnny" "Jane"

(* Explicitly passing None or Some to an optional argument *)
let out8_ = concat'' ?separator:None "Johnny" "Jane"
