open Symbol.Nonterminal

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

let get_properties = function
| E'_to_E -> E', 1
| E_to_E_plus_T -> E, 3
| E_to_E_minus_T -> E, 3
| E_to_T -> E, 1
| T_to_F_times_T -> T, 3
| T_to_F -> T, 1
| F_to_cos_F -> F, 2
| F_to_CA -> F, 1
| CA_to_CA_factorial -> CA, 2
| CA_to_FA -> CA, 1
| FA_to_U -> FA, 1
| FA_to_minus_U -> FA, 2
| U_to_Number -> U, 1
| U_to_bracket_E -> U, 3

