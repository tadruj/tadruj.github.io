(* Compile with: ocamlbuild hello.(native|byte) *)
#require "core"
open Core.Std

let () =
	let args = Sys.argv in
    print_string ("Hello " ^ args.(1) ^ "\n")
