(** ((symbol, expression string, value), children) *)
type t = Leaf of string * (string * float) option
       | Branch of (string * string * float) * t list

let create =
  let open Symbol.Token in
  function
  | Number x -> Leaf ("Number", Some (string_of_float x, x))
  | Left -> Leaf ("(", None)
  | Right -> Leaf (")", None)
  | Fact -> Leaf ("!", None)
  | Cos -> Leaf ("Cos", None)
  | Mult -> Leaf ("*", None)
  | Plus -> Leaf ("+", None)
  | Minus -> Leaf ("-", None)
  | EOF -> Leaf ("$", None)


let compose production trees =
  let nonterminal_str =
    Production.get_properties production
    |> fun (nt,_) -> nt
    |> Symbol.Nonterminal.to_string in
  let expr_string =
    List.map (function Leaf(_,Some(es,_)) | Branch((_,es,_),_) -> es | Leaf(s,None) -> s) trees
    |> String.concat " " in
  let value =
    let subtree_values =
      List.map (function Leaf(_,Some(_,v)) | Branch((_,_,v),_) -> v | Leaf(_,None) -> nan) trees in
    match production with
    | E'_to_E | E_to_T | T_to_F | F_to_CA | CA_to_FA | FA_to_U | U_to_Number ->
        let [@warning "-8"] [v] = subtree_values in v
    | E_to_E_plus_T ->
        let [@warning "-8"] [e_val; _; t_val] = subtree_values in e_val +. t_val
    | E_to_E_minus_T ->
        let [@warning "-8"] [e_val; _; t_val] = subtree_values in e_val -. t_val
    | T_to_F_times_T ->
        let [@warning "-8"] [f_val; _; t_val] = subtree_values in f_val *. t_val
    | F_to_cos_F ->
        let [@warning "-8"] [_; f_val] = subtree_values in cos f_val
    | CA_to_CA_factorial ->
        let [@warning "-8"] [ca_val; _] = subtree_values in Gamma.f (ca_val +. 1.)
    | FA_to_minus_U ->
        let [@warning "-8"] [_; u_val] = subtree_values in 0. -. u_val
    | U_to_bracket_E ->
        let [@warning "-8"] [_; e_val; _] = subtree_values in e_val
  in
  Branch ((nonterminal_str, expr_string, value), trees)


let value = function
  | Leaf (_, Some (_, v)) | Branch ((_, _, v), _) -> v | _ -> failwith "No value at leaf parse tree node"

let node_string node =
  let symbol_str = match node with
    | Leaf (symbol, _) | Branch ((symbol, _, _), _) -> String.concat symbol ["<"; ">"] in
  let rest_str = match node with
    | Leaf (_, None) -> ""
    | Leaf (_, Some (expr_str, value)) | Branch ((_, expr_str, value), _) ->
        Printf.sprintf " : %s = %f" expr_str value in
  String.concat (symbol_str ^ rest_str) ["( "; " )"]

let pretty_print tree =
  let rec tabulate = function 0 -> () | n -> print_char '\t'; tabulate (n-1) in
  let rec loop depth node =
    tabulate depth;
    node_string node |> print_string;
    match node with
    | Leaf _ -> print_newline ()
    | Branch (_, children) ->
        print_string " [\n";
        List.map (loop (depth+1)) children |> ignore;
        tabulate depth;
        print_string "]\n"
  in
  loop 0 tree



type tree = Lf of Symbol.Token.t | Br of tree list

let rec to_tree =
  let open Symbol.Token in
  function
  | Branch (_, children) -> Br (List.map to_tree children)
  | Leaf (_, Some (_, value)) -> Lf (Number value)
  | Leaf (symbol, _) ->
      let terminal =
        match symbol with
        | "(" -> Left
        | ")" -> Right
        | "!" -> Fact
        | "Cos" -> Cos
        | "*" -> Mult
        | "+" -> Plus
        | "-" -> Minus
        | "$" -> EOF
        | _ -> failwith "Invalid parse tree"
      in Lf terminal

