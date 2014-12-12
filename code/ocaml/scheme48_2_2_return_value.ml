(* install MParser with: opam install mparser *)
#require "core"
#require "mparser"
open MParser
open Core.Std

let symbol = any_of "!#$%&|*+-/:<=>?@^_~"

let spaces' = skip_many1 space

type lispVal =
	| Atom of string
	| List of lispVal list
	| DottedList of lispVal list * lispVal
	| Number of int
	| String of string
	| Bool of bool

let (>>=) p f s =
  match p s with
    | Empty_failed e1 -> Empty_failed e1
    | Consumed_failed e1 -> Consumed_failed e1
    | Empty_ok (r1, s1, e1) ->
        ( match f r1 s1 with
            | Empty_failed e2 -> Empty_failed (merge_errors e2 e1)
            | Empty_ok (r2, s2, e2) -> Empty_ok (r2, s2, merge_errors e2 e1)
            | consumed -> consumed )
    | Consumed_ok (r1, s1, e1) ->
        ( match f r1 s1 with
            | Empty_failed e2 -> Consumed_failed (merge_errors e2 e1)
            | Empty_ok (r2, s2, e2) -> Consumed_ok (r2, s2, merge_errors e2 e1)
            | consumed -> consumed )

let (>>) p q =
  p >>= fun _ -> q

let (<|>) p1 p2 s =
  match p1 s with
    | Empty_failed e1 ->
        ( match p2 s with
            | Empty_failed e2 -> Empty_failed (merge_errors e2 e1)
            | Empty_ok (r2, s2, e2) -> Empty_ok (r2, s2, (merge_errors e2 e1))
            | consumed -> consumed )
    | other -> other

let parseString = MParser.char '"' 
	>> (MParser.many (MParser.none_of "\"")) 
	>>= (fun t -> MParser.char '"' >> return (String (String.of_char_list t)))

let parseAtom = 
	(MParser.letter <|> symbol) >>= fun first ->
	MParser.many (MParser.letter <|> MParser.digit <|> symbol) >>= fun last ->
	let atom = String.of_char first ^ String.of_char_list last in
	return (match atom with
		| "#t" -> Bool true
		| "#f" -> Bool false
		| _ -> Atom atom)

let parseExpr = parseAtom <|> parseString

let readExpr input = match parse_string parseExpr input () with
	| Success r -> "Found value: " ^ (match r with
		|(String s) -> "String: " ^ s
		|(Atom s) -> "Atom: " ^ s
		|(Bool true) -> "Bool: True"
		|(Bool false) -> "Bool: False"
		|(_) -> "other")
	| Failed (msg, e) -> "No match on: " ^ input ^ ": " ^ msg

let () =
	let args = Sys.argv in
    print_string (readExpr args.(1) ^ "\n");


