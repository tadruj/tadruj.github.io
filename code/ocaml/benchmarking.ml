(* Benchmarking *)

open Core.Std
open Core_bench.Std

let rec sum' = function
	| [] -> 0
	| head :: tail -> head + sum' tail

let rec sum'' list = 
	if List.is_empty list then 0
	else List.hd_exn list + sum'' (List.tl_exn list)

let numbers = List.range 0 1000 in
	[Bench.Test.create ~name:"sum'" (fun () -> ignore (sum' numbers));
	 Bench.Test.create ~name:"sum''" (fun () -> ignore (sum'' numbers))]
	|> Bench.bench

let x = printf "Yeee\n"