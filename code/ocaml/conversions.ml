(* OCaml types conversions *)

String.of_char_list digits

Int.of_string (String.of_char_list digits))

Pervasives.int_of_string
Pervasives.string_of_int

(* List Matching *)
| List ((Atom "if") :: predicate :: consequence :: alternative :: _) ->
| List [Atom "if"; predicate; consequence; alternative] ->
