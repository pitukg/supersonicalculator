(** State encoding of the automaton by a unique integer. *)
type state = int

module Action : sig

  (** Alias for production type. *)
  type production = Production.t

  (** Type of action to be taken as a step in the LR(0) automaton. *)
  type t = Shift of state
         | Reduce of production
         | Accept
         | Error

end


(** Parsing table module interface that defines the behaviour of the automaton. *)
module type Intf = sig

  (** Determine next state in the automaton based on current state and next input token. *)
  val action : state -> Symbol.Terminal.t -> Action.t

  (** Determine next state after a reduction to a nonterminal. *)
  val goto : state -> Symbol.Nonterminal.t -> state

end

