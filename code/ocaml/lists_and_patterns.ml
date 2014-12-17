(* Lists and patterns *)

open Core.Std

let list_of_string_dump list = 
	printf "[";
	ignore @@ List.map ~f:(fun x -> printf "%s;" x) list;
	printf "]\n"
in
let list_of_int_dump list = 
	printf "[";
	ignore @@ List.map ~f:(fun x -> printf "%i;" x) list;
	printf "]\n"
in
	let out1_ = List.map ~f:String.length ["Hella"; "Worldish"] in
		list_of_int_dump out1_;

	(* Map with comparison function and exception if the lists are not of equal size *)
	let out2_ = List.map2_exn ~f:Int.max [1;2;3] [3;2;1] in
		list_of_int_dump out2_;

	(* Left to right reduction *)
	let out3_ = List.fold ~init:0 ~f:(+) [1;2;3;4] in
		list_of_int_dump [out3_];

	(* Accumulators can be lists *)
	let out4_ = List.fold ~init:[] ~f:(fun list x -> x :: list) [1;2;3;4] in
		list_of_int_dump out4_;

	(* Reduce is simpler fold that doesn't need init and the same type of accumulator and items in the list *)
	let out5_ = List.reduce ~f:(+) [1;2;3;4;5] in
		list_of_int_dump [(match out5_ with Some x -> x|None -> 0)];

	let out6_ = List.filter ~f:(fun x -> x mod 2 = 0) [1;2;3;4;5;6] in
		list_of_int_dump out6_;

	(* Map and filter Nones *)
	let out7_ = List.filter_map (Sys.ls_dir ".") ~f:(fun fname ->
		match String.rsplit2 ~on:'.' fname with
		|None|Some ("",_) -> None
		|Some (_,ext) -> Some ext)
		|> List.dedup
		|> list_of_string_dump
	in ();

	(* Two partitions of list, one with true filter and one with false *)
	let out8_ = List.partition_tf (Sys.ls_dir ".") ~f:(fun s -> match (String.rsplit2 s ~on:'.') with 
		| Some (_,("ml"|"mli")) -> true
		| _ -> false)
	in 
		printf "\nocamls:\n";
		list_of_string_dump (match out8_ with (first,_) -> first);
		printf "\nNOcamls:\n";
		list_of_string_dump (match out8_ with (_,second) -> second);
		printf "\n\n";

	let out9_ = List.append [1;2;3] [4;5;6] in
	list_of_int_dump out9_;

	let out10_ = [1;2;3] @ [4;5;6] in
	list_of_int_dump out10_;


