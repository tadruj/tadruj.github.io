type shish_kebab = Skewer
	| Onion of shish_kebab
	| Lamb of shish_kebab
	| Tomato of shish_kebab

let rec only_onions:(shish_kebab -> bool) = function
	| Skewer -> true
	| Onion x -> only_onions x
	| Lamb _ -> false
	| Tomato _ -> false

