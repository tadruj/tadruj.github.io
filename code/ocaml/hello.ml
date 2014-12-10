open Printf

let () =
    let name = if (Array.length Sys.argv) > 1 then Sys.argv.(1) else "Noname"
    in printf "Hello %s\n" name
