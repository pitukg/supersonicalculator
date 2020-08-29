(** Tokens supported by the lexer. *)
module Token : sig

  (** Token type. *)
  type t = Number of float
           | Left  (* "(" *)
           | Right (* ")" *)
           | Fact  (* "!" *)
           | Cos   (* "cos" *)
           | Mult  (* "*" *)
           | Plus  (* "+" *)
           | Minus (* "-" *)
           | EOF   (* End-of-line *)

  (** Format token. *)
  val to_string : t -> string

end


(** Terminal symbols - alias for tokens. *)
module Terminal = Token


(** Nonterminal symbols of the grammar driving the parser. *)
module Nonterminal : sig

  type t = E' (* starting symbol in "augmented" grammar *)
         | E  (* Expression *)
         | T  (* Term *)
         | F  (* Factor *)
         | CA (* Cosine Argument *)
         | FA (* Factorial Argument *)
         | U  (* Unsigned Number *)

  (** Set of terminal symbols that can follow the given nonterminal. *)
  val follow : t -> Terminal.t list

  (** Format nontermnial. *)
  val to_string : t -> string

end


(** General symbol of the grammar - either a terminal or a nonterminal. *)
type t = Term of Terminal.t | Nonterm of Nonterminal.t

