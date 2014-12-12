(* install MParser with: opam install mparser *)
(* #require "core"
#require "mparser"
 *)open MParser
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

let parseString =  MParser.char '"' >> MParser.many (MParser.none_of "\"") << MParser.char '"'

let parseExpr = parseString

let readExpr input = match parse_string parseExpr input () with
	| Success r -> "Found value: " ^ String.of_char_list r
	| Failed (msg, e) -> "No match on: " ^ input ^ ": " ^ msg

let () =
	let args = Sys.argv in
    print_string (readExpr args.(1) ^ "\n");
