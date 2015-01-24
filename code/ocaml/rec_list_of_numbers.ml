open Core.Std

(* Input: [1;1;1;2;2;3] Output should be [[1;1;1];[2;2];[3]] *)

let rec banana = function
	| [], result -> List.rev result
	| first :: second :: rest, [] -> 
		if first = second then banana (rest, [[first;second]]) 
		else banana (rest, [[second];[first]])
	| hd :: tl, (result_hd :: result_tl) :: result_long_tl when hd = result_hd -> banana (tl, (hd :: result_hd :: result_tl) :: result_long_tl)
	| hd :: tl, (result_hd :: result_tl) :: result_long_tl -> banana (tl, [hd] :: (result_hd :: result_tl) :: result_long_tl)
	| _, _ -> raise (Invalid_argument ("Error"))

let int_list_to_string list = 
	"[" ^ String.concat ~sep:";" (List.map ~f:(fun s -> Pervasives.string_of_int s) list) ^ "]"

let print_string_list list =
	print_string @@ "[" ^ String.concat ~sep:";" (List.map ~f:(fun l -> int_list_to_string l) list) ^ "]\n"

let () =
	print_string_list @@ banana ([], []);
	print_string_list @@ banana ([1;1;1], []);
	print_string_list @@ banana ([1;2;3], []);
	print_string_list @@ banana ([1;2;3;3;3], []);
	print_string_list @@ banana ([1;1;1;2;2;3], []);
