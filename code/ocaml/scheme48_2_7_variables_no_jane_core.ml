(* install MParser with: opam install mparser *)
(* open Core.Std *)
(* Warning: MParser overwrites Core.Std parser combinator <|> *)
(* Compile with: ocamlfind ocamlc -linkpkg -package mparser,re.pcre this.ml -o this.byte *)
open MParser

let symbol:(char, unit) MParser.t = any_of "!#$%&|*+-/:<=>?@^_~"

let spaces':(unit, unit) MParser.t = skip_many1 space

type lispVal =
	| Atom of string
	| List of lispVal list
	| Number of int
	| String of string
	| Bool of bool

type lispEnv = (string * lispVal) list

let isBound (env:lispEnv ref) (name:string):bool = 
	List.filter (fun (_name, _) -> _name = name) !env 
	|> List.length > 0

let getVar (env:lispEnv ref) (name:string):lispVal =
	match List.find (fun (_name, _value) -> _name = name) !env with 
		| (__name, __value) -> __value 

let setVar (env:lispEnv ref) (name:string) (value:lispVal):unit =
	env := List.filter (fun (_name, _) -> _name <> name) !env;
	env := (name, value) :: !env;
	()

let bindVars (env:lispEnv ref) (vars:lispEnv):(lispEnv ref) = 
	List.iter (fun (name, value) -> setVar env name value) vars; (* TODO: setVar should return lispVal; -> ( block ) might solve *)
	env

let explode s =
  let rec exp i l =
    if i < 0 then l else exp (i - 1) (s.[i] :: l) in
  exp (Bytes.length s - 1) []

let implode l =
  let res = Bytes.create (List.length l) in
  let rec imp i = function
  | [] -> res
  | c :: l -> res.[i] <- c; imp (i + 1) l in
  imp 0 l

let parseString:(lispVal, unit) MParser.t =	MParser.char '"' 
	>> MParser.many @@ MParser.none_of "\"" 
	>>= fun s -> MParser.char '"' 
		>> return @@ String (implode s)

let parseAtom:(lispVal, unit) MParser.t = (MParser.letter <|> symbol) 
	>>= fun first -> MParser.many (MParser.letter <|> MParser.digit <|> symbol) 
		>>=	fun last ->	let atom = implode [first] ^ implode last in
			return @@ match atom with
				| "#t" -> Bool true
				| "#f" -> Bool false
				| _ -> Atom atom

let parseNumber:(lispVal, unit) MParser.t =	MParser.many1 MParser.digit 
	>>= fun digits -> return @@ Number (Pervasives.int_of_string @@ implode digits)

let rec parseExpr:(lispVal, unit) MParser.t lazy_t = lazy (
	parseAtom
	<|> parseString
	<|> parseNumber
	<|> Lazy.force parseList
) and parseList = lazy (
	MParser.char '(' 
	>>= fun _ -> MParser.sep_by (Lazy.force parseExpr) spaces' 
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
and unwordList (list:lispVal list):bytes = List.map (fun item -> showVal item) list |> String.concat " "

let readExpr (input:bytes):lispVal = match parse_string (Lazy.force parseExpr) input () with
	| Success v -> v
	| Failed (msg, _) -> (fun _ -> raise (Invalid_argument ("LISP needs LISTS: " ^ input ^ "\n" ^ msg))) (String "Error")

let car:(lispVal list -> lispVal) = function
	| [List (x :: _)] -> x
	| [_] -> raise (Invalid_argument ("car: Type Mismatch pair"))
	| _ -> raise (Invalid_argument ("car: Number of arguments"))

let cdr:(lispVal list -> lispVal) = function
	| [List (_ :: xs)] -> List xs
	| [_] -> raise (Invalid_argument ("cdr: Type Mismatch pair"))
	| _ -> raise (Invalid_argument ("cdr: Number of arguments"))

let cons:(lispVal list -> lispVal) = function
	| [x; List []] -> List [x]
	| [x; List xs] -> List (x :: xs)
	| [x; Atom "null"] -> List [x]
	| _ -> raise (Invalid_argument ("cons: Number of arguments"))

let eqv:(lispVal list -> lispVal) = function
	| [Bool arg1; Bool arg2] -> Bool (arg1 = arg2)
	| [Number arg1; Number arg2] -> Bool (arg1 = arg2)
	| [String arg1; String arg2] -> Bool (arg1 = arg2)
	| [Atom arg1; Atom arg2] -> Bool (arg1 = arg2)
	| [List arg1; List arg2] -> Bool (List.length arg1 = List.length arg2) (* TODO *)
	| [_;_] -> Bool false
	| _ -> raise (Invalid_argument ("eqv: Number of arguments"))

let rec unpackNum = function
	| Number n -> n
	| List [n] -> unpackNum n
	| _ -> raise (Invalid_argument ("unpackNum: Not a number or list of numbers"))

let numOp (op:int -> int -> int) (params:lispVal list):lispVal = 
	Number (List.fold_left (op) 0 (List.map (unpackNum) params))

let unpackBool = function
	| Bool b -> b
	| _ -> raise (Invalid_argument ("unpackBool: Type Mismatch: bool operation needs bools"))

let boolOp (unpacker:lispVal -> 'a) (op:'a -> 'a -> bool) (params:lispVal list):lispVal =
	if List.length params <> 2 then (fun _ -> raise (Invalid_argument ("boolOp: bool operation needs two arguments"))) (String "Error")
	else Bool (op (unpacker @@ List.nth params 0) (unpacker @@ List.nth params 1))

let unpackString = function
	| String s -> s
	| Number s -> string_of_int s
	| Bool s -> string_of_bool s
	| _ -> raise (Invalid_argument ("unpackString: Type Mismatch: not a string"))

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
	| "string=?" -> boolOp unpackString (=)
	| "string<?" -> boolOp unpackString (<)
	| "string>?" -> boolOp unpackString (>)
	| "string<=?" -> boolOp unpackString (<=)
	| "string>=?" -> boolOp unpackString (>=)
	| "car" -> car
	| "cdr" -> cdr
	| "cons" -> cons
	| "eq?" -> eqv
	| "eqv?" -> eqv
	| _ -> fun _ -> Invalid_argument "Unknown operation" |> raise

let apply (func:bytes) (args:lispVal list):lispVal =
	primitives func args

let rec eval (env:lispEnv ref) (expr:lispVal):lispVal =
	(* | List ((Atom "if") :: predicate :: consequence :: alternative :: _) -> *)
	match expr with
		| Atom name -> getVar env name
		| List [Atom "if"; predicate; consequence; alternative] ->
			(match (eval env predicate) with
				| Bool false -> eval env alternative
				| _ -> eval env consequence
			)
		| List [Atom "set!"; Atom name; form] | List [Atom "define"; Atom name; form] ->
			setVar env name (eval env form); 
			getVar env name
		| List (Atom func :: args) -> apply func @@ List.map (eval env) args
		| v -> v

let repl env = lazy(
	let end_of_file = ref false in
		while !end_of_file = false do
			try
				Printf.printf "SCHEManaBANANA >>> ";
				let scheme_expression = read_line () in
					showVal (eval env @@ readExpr scheme_expression) ^ "\n" |> print_string
			with 
				| End_of_file -> end_of_file := true; Printf.printf "\n"
				| Invalid_argument e -> Printf.printf "ERR: %s\n" e
		done
)

let () =
	let env:lispEnv ref = ref [] in
		if Array.length Sys.argv <= 1 then
			Lazy.force (repl env)
		else
			let scheme_expression =	Sys.argv.(1) in
		    	showVal (eval env @@ readExpr scheme_expression) ^ "\n" |> print_string
