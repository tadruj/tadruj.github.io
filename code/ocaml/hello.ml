(* compile with ocamlbuild hello.(native|byte) *)
open Core.Std

let () =
    let name = if (Array.length Sys.argv) > 1 then Sys.argv.(1) else "Noname"
    in printf "Hello %s\n" name
