(* Q: Return a list of unsortable list items sorted by indexes of sortable list *)

(* First try *)
let zap'' u s = 
	let zip' = match List.zip u s with Some l -> l | None -> [] in
	let compare' a b =
		match (snd a > snd b, snd a < snd b) with
			| (true, false) -> 1
			| (false, true) -> -1
			| (_, _) -> 0 in
	let sort' l = List.sort compare' l in
	let extract' l = List.map ~f:(fun (a,b) -> a) l in
	extract' (sort' zip')

(* We don't actually need custom compare function, we just turn around the tuples *)
(* Built in compare compares by the first element of tuple *)
let zap' u s = 
	let zip' = match List.zip s u with Some l -> l | None -> [] in
	let extract' l = List.map ~f:(fun (a,b) -> b) l in
	extract' (List.sort compare zip')

(* Unreadable oneliner *)
let zap u s = 
	List.map ~f:(fun (a,b) -> b) (List.sort compare (match List.zip s u with Some l -> l | None -> []))

let _ = 
	zap' ['A'; 'B'; 'C'; 'D'; 'E'] [2; 4; 0; 1; 3]
