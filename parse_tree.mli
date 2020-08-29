(** Parse tree type which is recursively built up during parse. *)
type t

(** Create "leaves" for tokens. *)
val create : Symbol.Token.t -> t

(** Build a parse tree from trees of child symbols. It is assumed that the input list corresponds to the production's right-hand side. *)
val compose : Production.t -> t list -> t

(** Get value at the root of a parse tree. @raise Failure if it is a terminal leaf node. *)
val value : t -> float

(** Print the parse tree to stdout. *)
val pretty_print : t -> unit


(* Converters *)

(** Basic tree type without values in branch nodes. *)
type tree = Lf of Symbol.Token.t | Br of tree list

(** Convert a parse tree to basic tree type. *)
val to_tree : t -> tree

