module Token = struct

  type t = Number of float
         | Left
         | Right
         | Fact
         | Cos
         | Mult
         | Plus
         | Minus
         | EOF

  let to_string = function
  | Number x -> x |> string_of_float
  | Left -> "("
  | Right -> ")"
  | Fact -> "!"
  | Cos -> "cos"
  | Mult -> "*"
  | Plus -> "+"
  | Minus -> "-"
  | EOF -> "$"

end


module Terminal = Token


module Nonterminal = struct

  type t = E'
         | E
         | T
         | F
         | CA
         | FA
         | U

  let follow =
    let open Terminal in
    function
    | E' -> [EOF]
    | E  -> [Plus; Minus; Right; EOF]
    | T  -> [Plus; Minus; Right; EOF]
    | F  -> [Mult; Plus; Minus; Right; EOF]
    | CA -> [Fact; Mult; Plus; Minus; Right; EOF]
    | FA -> [Fact; Mult; Plus; Minus; Right; EOF]
    | U  -> [Fact; Mult; Plus; Minus; Right; EOF]


  let to_string = function
  | E' -> "Starting Symbol"
  | E  -> "Expression"
  | T  -> "Term"
  | F  -> "Factor"
  | CA -> "Cosine Argument"
  | FA -> "Factorial Argument"
  | U  -> "Unsigned Number"
 
end


type t = Term of Terminal.t | Nonterm of Nonterminal.t

