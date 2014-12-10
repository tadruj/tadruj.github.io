(* Arrays *)
let array_of_numbers = [|1;2;3;4;5;6|]
let a_third_number = array_of_numbers.(2)
let mutate_a_number = array_of_numbers.(2) <- 9 (* Returns a unit () and mutates the array *)

type running_sum = {
	mutable sum: float;
	mutable sum_sq: float;
	mutable samples: int;
}

let mean rsum = rsum.sum /. Float.of_int rsum.samples
let stdev rsum =
	sqrt (rsum.sum_sq /. Float.of_int rsum.samples
		-. (rsum.sum /. Float.of_int rsum.samples) ** 2.)

let create () = { sum = 0.; sum_sq = 0.; samples = 0}
let update rsum x =
	rsum.samples <- rsum.samples + 1 ;
	rsum.sum 	 <- rsum.sum     +. x ;
	rsum.sum_sq  <- rsum.sum_sq  +. x *. x

let rsum = create ()
let void = List.iter [1.;3.;2.;-7.;4.;5.] ~f:(fun x -> update rsum x)
let a_mean = mean rsum
let a_stdev = stdev rsum

(* Mutable shorthands *)

let x = ref 0 (*create a value with contents*)
let pulled_x = !x (* pull the value out of contents *)
let assigned_x = x := !x + 1

(* Re-Implementation of mutable shorthands *)
type 'a ref = { mutable contents : 'a }
let ref x = { contents = x }
let (!) r = r.contents
let (:=) r x = r.contents <- x

(* Using shorthands in functions *)
let sum' list = 
	let sum = ref 0 in
	List.iter list ~f:(fun x -> sum := !sum + x);
	!sum

(* Plain Implementation without shorthands *)
let sum'' list =
	let sum = { contents = 0} in
	List.iter list ~f:(fun x -> sum.contents <- sum.contents + x);
	!sum

(* Ugly old school mutable array shuffling *)
let permute array =
	let length = Array.length array in
	for i = 0 to length - 2 do
		let j = i + 1 + Random.int (length - i - 1) in
		let tmp = array.(i) in
		array.(i) <- array.(j);
		array.(j) <- tmp
	done

(* Array of random numbers *)
let random_numbers_array = Array.init 20 ~f:(fun x -> Random.int 100)

let find_first_negative_entry array =
	let pos = ref 0 in
	while !pos < Array.length array && array.(!pos) >= 0 do
		pos := !pos + 1
	done;
	if !pos = Array.length array then None else Some !pos

let find_first_negative_entry' array =
	let pos = { contents = 0 } in
	while pos.contents < Array.length array && array.(pos.contents) >= 0 do
		pos.contents <- pos.contents + 1
	done;
	if pos.contents = Array.length array then None else Some pos.contents

let explodeString string = 
	String.split string ~on:','

let dashList list = 
	String.concat ~sep:"-" list

let thisAndThat = dashList (explodeString "This,and,this,and,that")


