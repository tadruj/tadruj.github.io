(* install MParser with: opam install mparser *)
open Core.Std
(* Warning: MParser overwrites Core.Std parser combinator <|> *)
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


let parseString = printf "parseString\n";
	MParser.char '"' 
	>> (MParser.many (MParser.none_of "\"")) 
	>>= (fun t -> printf "parseString.string=%s\n" (String.of_char_list t); MParser.char '"' 
		>> return (String (String.of_char_list t)))

let parseAtom = printf "parseAtom\n";
	(MParser.letter <|> symbol) >>= fun first ->
	MParser.many (MParser.letter <|> MParser.digit <|> symbol) >>= fun last ->
	let atom = String.of_char first ^ String.of_char_list last in
	printf "parseAtom.atom=%s\n" atom;
	return (match atom with
		| "#t" -> Bool true
		| "#f" -> Bool false
		| _ -> Atom atom)

let parseNumber = printf "parseNumber\n";
	MParser.many1 MParser.digit 
	>>= (fun digits -> printf "parseNumber.number=%s\n" (String.of_char_list digits); return (Number (Int.of_string (String.of_char_list digits))))

let rec parseExpr = lazy (
	printf "parseExpr\n";
	parseAtom
	<|> parseString
	<|> parseNumber
	<|> force parseList
) and parseList = lazy (
	printf "parseList\n";
	(MParser.char '(' >>= (fun item -> MParser.sep_by (force parseExpr) spaces' >>= (fun l -> return (List l)))
		>>= (fun item -> printf "parseExpr.LIST %i\n" (match item with (List i) -> List.length i|(_) -> 0);
		MParser.char ')' >> return (List ([item]))))
)

let readExpr input = match parse_string ((force parseExpr)) input () with
	| Success r -> "Found value: " ^ (match r with
		|(String s) -> "String: " ^ s
		|(Atom s) -> "Atom: " ^ s
		|(Bool true) -> "Bool: True"
		|(Bool false) -> "Bool: False"
		|(Number n) -> "Number: " ^ string_of_int n
		|(List l) -> "List: " ^ string_of_int (List.length l)
		|(_) -> "other")
	| Failed (msg, _) -> "No match on: " ^ input ^ ": " ^ msg

let () =
	let args = Sys.argv in
	(* print_string (readExpr "(159 roki \"stroj\" cist (ana tud stroj))" ^ "\n"); *)
	printf "args=%s\n" args.(1);
    print_string (readExpr args.(1) ^ "\n");


