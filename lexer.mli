(** Read a line from standard input and return the list of tokens it contains.
  * @raise Failure if lexing failed because the line contained invalid syntax. *)
val get_token_stream : unit -> (Symbol.Token.t list, string) result

