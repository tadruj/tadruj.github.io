(* install MParser with: opam install mparser *)
open Core.Std
(* Warning: MParser overwrites Core.Std parser combinator <|> *)
open MParser

let symbol:(char, unit) MParser.t = any_of "!#$%&|*+-/:<=>?@^_~"

let spaces':(unit, unit) MParser.t = skip_many1 space

type lispVal =
	| Atom of string
	| List of lispVal list
	| Number of int
	| String of string
	| Bool of bool

let parseString:(lispVal, unit) MParser.t =	MParser.char '"' 
	>> MParser.many @@ MParser.none_of "\"" 
	>>= fun s -> MParser.char '"' 
		>> return @@ String (String.of_char_list s)

let parseAtom:(lispVal, unit) MParser.t = (MParser.letter <|> symbol) 
	>>= fun first -> MParser.many (MParser.letter <|> MParser.digit <|> symbol) 
		>>=	fun last ->	let atom = String.of_char first ^ String.of_char_list last in
			return @@ match atom with
				| "#t" -> Bool true
				| "#f" -> Bool false
				| _ -> Atom atom

let parseNumber:(lispVal, unit) MParser.t =	MParser.many1 MParser.digit 
	>>= fun digits -> return @@ Number (Int.of_string @@ String.of_char_list digits)

let rec parseExpr:(lispVal, unit) MParser.t lazy_t = lazy (
	parseAtom
	<|> parseString
	<|> parseNumber
	<|> force parseList
) and parseList = lazy (
	MParser.char '(' 
	>>= fun _ -> MParser.sep_by (force parseExpr) spaces' 
	>>= fun l -> List l |> return
	>>= fun item -> MParser.char ')' >> return item
)

let rec showVal:lispVal -> bytes = function
	| String s -> "\"" ^ s ^ "\""
	| Atom s -> s
	| Number n -> string_of_int n
	| List l -> "(" ^ unwordList l ^ ")"
	| Bool true -> "#t"
	| Bool false -> "#f"
and unwordList (list:lispVal list):bytes = List.map ~f:(fun item -> showVal item) list |> String.concat ~sep:" "

let readExpr (input:bytes):lispVal = match parse_string (force parseExpr) input () with
	| Success v -> v
	| Failed (msg, _) -> (fun _ -> raise (Invalid_argument ("LISP needs LISTS: " ^ input ^ "\n" ^ msg))) (String "Error")

let rec unpackNum = function
	| Number n -> n
	| List [n] -> unpackNum n
	| _ -> raise (Invalid_argument ("unpackNum: Not a number or list of numbers")) 0

let numOp (op:int -> int -> int) (params:lispVal list):lispVal = 
	Number (match (List.reduce ~f:(op) (List.map ~f:(unpackNum) params)) with None -> 0|Some n -> n)

let unpackBool = function
	| Bool b -> b
	| _ -> raise (Invalid_argument ("unpackBool: Type Mismatch: bool operation needs bools"))

let boolOp (unpacker:lispVal -> 'a) (op:'a -> 'a -> bool) (params:lispVal list):lispVal =
	if List.length params <> 2 then (fun _ -> raise (Invalid_argument ("boolOp: bool operation needs two arguments"))) (String "Error")
	else Bool (op (unpacker @@ List.nth_exn params 0) (unpacker @@ List.nth_exn params 1))

let primitives = function
	| "+" -> numOp (+)
	| "-" -> numOp (-)
	| "*" -> numOp ( * )
	| "/" -> numOp (/)
	| "%" -> numOp (mod)
	| "=" -> boolOp unpackNum (=)
	| "!=" -> boolOp unpackNum (<>)
	| "<" -> boolOp unpackNum (<)
	| ">" -> boolOp unpackNum (>)
	| ">=" -> boolOp unpackNum (>=)
	| "<=" -> boolOp unpackNum (<=)
	| "&&" -> boolOp unpackBool (&&)
	| "||" -> boolOp unpackBool (||)
	| _ -> fun _ -> Invalid_argument "Unknown operation" |> raise

let apply (func:bytes) (args:lispVal list):lispVal =
	primitives func args

let rec eval:(lispVal -> lispVal) = function
	| (List (Atom func :: args)) -> apply func @@ List.map ~f:(eval) args
	| v -> v

let () =
	let scheme_expression =
		try
			Sys.argv.(1)
		with error ->
			read_line ()
		in
    showVal (eval @@ readExpr scheme_expression) ^ "\n" |> print_string
