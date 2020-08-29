(** Parser functor that maps a shift-reduce parsing table to the corresponding LR(0) shift-reduce parser. *)
module Parser (Parsing_table : Parsing_table_intf.Intf) : sig

  (** Parse token stream. Usage: `parse create compose tokens` where `create` and `compose` define the semantics on the parse tree, e.g. evaluate expression or build tree explicitly. *)
  val parse : (Symbol.Token.t -> 'a) -> (Production.t -> 'a list -> 'a) -> Symbol.Token.t list -> ('a, string) result

end

