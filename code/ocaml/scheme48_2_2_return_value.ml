(* install MParser with: opam install mparser *)
#require "core"
open Core.Std
#require "mparser" (* Warning: MParser overwrites Core.Std parser combinator *)
open MParser

let symbol = any_of "!#$%&|*+-/:<=>?@^_~"

let spaces' = skip_many1 space

type lispVal =
	| Atom of string
	| List of lispVal list
	| DottedList of lispVal list * lispVal
	| Number of int
	| String of string
	| Bool of bool

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


