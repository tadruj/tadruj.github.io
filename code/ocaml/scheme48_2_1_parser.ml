(* install MParser with: opam install mparser *)
#require "core"
#require "mparser"
open MParser
open Core.Std

let symbol = any_of "!#$%&|*+-/:<=>?@^_~"

let readExpr input = match parse_string symbol input () with
	| Success e -> "Found value"
	| Failed (msg, e) -> "No match: " ^ msg

let () =
	let args = Sys.argv in
    print_string (readExpr args.(1) ^ "\n");
