(** Type for productions of the grammar defining the calculator syntax. *)
type t = E'_to_E 
       | E_to_E_plus_T 
       | E_to_E_minus_T
       | E_to_T
       | T_to_F_times_T
       | T_to_F
       | F_to_cos_F
       | F_to_CA
       | CA_to_CA_factorial
       | CA_to_FA
       | FA_to_U
       | FA_to_minus_U
       | U_to_Number
       | U_to_bracket_E

(** Get (head nonterminal, length of right-hand side) pair for a production. *)
val get_properties : t -> Symbol.Nonterminal.t * int

