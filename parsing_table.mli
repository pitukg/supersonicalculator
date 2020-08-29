open Parsing_table_intf

(** Determine next state in the automaton based on current state and next input token. *)
val action : state -> Symbol.Terminal.t -> Action.t

(** Determine next state after a reduction to a nonterminal. *)
val goto : state -> Symbol.Nonterminal.t -> state

