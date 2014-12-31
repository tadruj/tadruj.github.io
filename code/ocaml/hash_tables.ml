(* Hash table usage *)

let t2 = String.Table.create () ~size:4

Hashtbl.set t2 ~key:"Rok" ~data:(Number 39)
Hashtbl.set t2 ~key:"Ana" ~data:(String "Stara 30 let")

Hashtbl.find t2 "Rok"
