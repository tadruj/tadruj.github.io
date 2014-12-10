(*Functions*)
let square x = x * x

let ratio x y = 
    Float.of_int x /. Float.of_int y;;

let isMoreThanOne test x y =
    if test x y > 1. then true else false;; 

let isMoreThanOneAnnotated (test : int -> int -> float) (x : int) (y : int) =
    if test x y > 1. then true else false;; 

(*Tuples and destructuring*)

let tuple = (5, "Five", 0.5);;
let (t_int, t_bytes, t_float) = tuple;;

let t_bytes_length = String.length t_bytes

let distance (x1,y1) (x2,y2) =
    sqrt ((x1 -. x2) ** 2. +. (y1 -. y2) ** 2.);;

(*Lists*)

let languages = ["English";"Slovenian";"Deutch"]
let num_langs = List.length languages
let len_langs = List.map languages ~f:String.length (*f is a labeled argument:cool*)
let len_langs = List.map ~f:String.length languages (*so we can swap arguments*) 

let more_langs = "Amharic" :: "Farsi" :: languages

let a_list = [1;2;3]
let a_tuple = 1,2,3
let a_single_tuple_in_a_list = [1,2,3]
let a_list_again = 1 :: 2 :: 3 :: []

let concatenated_list = [1;2;3] @ [4;5;6]
let glued_list = [4;5;6] @ 7 :: [];; 

let match_languages_guards languages = 
    match languages with
        | x :: xs -> [x]
        | [] -> ["Slovenian"] 

let rec sum' numbers =
    match numbers with
        | [] -> 0
        | (x :: xs) -> x + sum' xs

(*Q: Function which deduplicates items on a list*)
let rec dedup' items =
    match items with
        | [] -> []
        | head :: [] -> [head]
        | (first :: second :: tail) -> 
                if first = second then dedup' (second :: tail)
                else first :: dedup' (second :: tail)

let deduped_tuples = dedup' [(1,2,3);(1,2,3);(3,4,5);(6,7,8);(6,7,8)]
let deduped_tuples' = dedup' [1,2,3;1,2,3;3,4,5;6,7,8;6,7,8]

let divide x y =
    if y = 0 then None else Some (x/y)

let list_of_some_stuff = [None;None;Some 1;None;Some 5;None]
let list_of_some_stuff' = [Some "English";None;Some "Dutch"]

(*Q: Function filters trough a list of options for valid options*)
let rec filter_valid_languages languages = 
    match languages with
        | [] -> []
        | (Some language :: tail) -> language :: filter_valid_languages tail
        | (None :: tail) -> filter_valid_languages tail

let valid_languages = filter_valid_languages [None; Some "English"; Some "Japanese"; None; Some "Slovenian"; None]

(*Q: Make a nice string which outputs current time and some text*)
let log_entry maybe_time message =
(*Introduce new variable in the scope which starts with in*)
    let time = 
        match maybe_time with
            | Some x -> x
            | None -> Time.now ()
    in
        Time.to_sec_string time ^ " -- " ^ message

let concatenated_strings = "This " ^ "is" ^ " fabulous!!!"

let x = 7 in x + x

type point2D = { x: float; y: float }
let p = {x = 3.; y = -4.}

let magnitude {x; y} = sqrt (x ** 2. +. y ** 2.)

let magnitude' point =
    match point with
        | { x; y } -> sqrt (x ** 2. +. y ** 2.)

let some_magnitude = magnitude {x=2.;y=3.}

(* Q: Write a function that calculates distance between two points *)
let distance start finish =
    magnitude {x=start.x -. finish.x; y=start.y -. start.y}

let some_distance = distance {x=3.;y=4.} {x=10.;y=20.}

(*Types*)

type circle = {center:point2D; radius:float}
type rectangle = {lower_left:point2D; width:float; height:float}

type scene =
    | Circle of circle
    | Rectangle of rectangle

let is_point_inside_scene_element point scene_element =
    match scene_element with
    | Circle {center; radius} -> distance center point < radius
    | Rectangle {lower_left;width;height} -> 
        let horizontal = point.x > lower_left.x && point.x < lower_left.x +. width in
        let vertical = point.y > lower_left.y && point.y < lower_left.y +. height in
        horizontal && vertical 

let is_point_inside_rectangle = is_point_inside_scene_element {x=2.;y=2.} (Rectangle {lower_left={x=1.;y=1.};width=2.;height=2.})
let is_point_inside_rectangle' = is_point_inside_scene_element {x=6.;y=2.} (Rectangle {lower_left={x=1.;y=1.};width=2.;height=2.})

let is_point_inside_circle = is_point_inside_scene_element {x=2.;y=2.} (Circle {center={x=3.;y=3.};radius=3.})
let is_point_inside_circle' = is_point_inside_scene_element {x=2.;y=2.} (Circle {center={x=3.;y=3.};radius=3.})

let is_point_inside_scene point scene_list = 
    List.exists scene_list (*Does at least one of the function run on element returns true*)
        ~f:(fun element -> is_point_inside_scene_element point element)

let point1 = {x=3.;y=1.}
let point2 = {x=2.9;y=1.1}
let point3 = {x=2.5;y=2.5}
let point4 = {x=3.5;y=2.5}
let point5 = {x=5.;y=5.}

let scene1 = [(Circle {center={x=2.;y=2.};radius=1.});(Rectangle {lower_left={x=2.;y=2.};width=2.;height=2.})]

let frka = List.map ~f:(fun point -> is_point_inside_scene point scene1) [point1;point2;point3;point4;point5]
