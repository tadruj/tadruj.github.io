val symbol : (char, unit) MParser.t
val spaces' : (unit, unit) MParser.t
type lispVal =
    Atom of bytes
  | List of lispVal list
  | DottedList of lispVal list * lispVal
  | Number of int
  | String of bytes
  | Bool of bool
val parseString : (lispVal, unit) MParser.t
val parseAtom : (lispVal, unit) MParser.t
val parseNumber : (lispVal, unit) MParser.t
val parseExpr : (lispVal, unit) MParser.t
val parseList : (lispVal, unit) MParser.t
val readExpr : bytes -> bytes
