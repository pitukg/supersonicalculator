let action state terminal =
  let open Parsing_table_intf.Action in
  let open Production in
  let open Symbol.Terminal in
  let open Symbol.Nonterminal in
  match state with
  | 0 | 2 | 6 | 16 | 20 -> begin
    match terminal with
    | Cos -> Shift 8 | Minus -> Shift 13 | Number _ -> Shift 15 | Left -> Shift 16 | _ -> Error
  end
  | 1 -> begin
    match terminal with
    | EOF -> Accept | Plus -> Shift 2 | Minus -> Shift 20 | _ -> Error
  end
  | 3 -> if List.mem terminal (follow E) then Reduce E_to_E_plus_T else Error
  | 4 -> if List.mem terminal (follow E) then Reduce E_to_T else Error
  | 5 -> if terminal = Mult then Shift 6 else
         if List.mem terminal (follow T) then Reduce T_to_F else Error
  | 7 -> if List.mem terminal (follow F) then Reduce F_to_cos_F else Error
  | 8 -> begin
    match terminal with
    | Cos -> Shift 8 | Minus -> Shift 13 | Number _ -> Shift 15 | Left -> Shift 16 | _ -> Error
  end
  | 9 -> if terminal = Fact then Shift 11 else if List.mem terminal (follow F) then Reduce F_to_CA else Error
  | 10 -> if List.mem terminal (follow CA) then Reduce CA_to_FA else Error
  | 11 -> if List.mem terminal (follow CA) then Reduce CA_to_CA_factorial else Error
  | 12 -> if List.mem terminal (follow FA) then Reduce FA_to_U else Error
  | 13 -> begin
    match terminal with
    | Number _ -> Shift 15 | Left -> Shift 16 | _ -> Error
  end
  | 14 -> if List.mem terminal (follow FA) then Reduce FA_to_minus_U else Error
  | 15 -> if List.mem terminal (follow U) then Reduce U_to_Number else Error
  | 17 -> begin
    match terminal with
    | Right -> Shift 18 | Plus -> Shift 2 | Minus -> Shift 20 | _ -> Error
  end
  | 18 -> if List.mem terminal (follow U) then Reduce U_to_bracket_E else Error
  | 19 -> if List.mem terminal (follow T) then Reduce T_to_F_times_T else Error
  | 21 -> if List.mem terminal (follow E) then Reduce E_to_E_minus_T else Error
  |_ -> failwith (Printf.sprintf "State <%d> is out of bounds (0-19 incl)" state)


let goto state nonterminal =
  let open Symbol.Nonterminal in
  match state, nonterminal with
  | 0, E -> 1
  | 0, T -> 4
  | 0, F -> 5
  | 0, CA -> 9
  | 0, FA -> 10
  | 0, U -> 12
  | 2, T -> 3
  | 2, F -> 5
  | 2, CA -> 9
  | 2, FA -> 10
  | 2, U -> 12
  | 6, T -> 19
  | 6, F -> 5
  | 6, CA -> 9
  | 6, FA -> 10
  | 6, U -> 12
  | 8, F -> 7
  | 8, CA -> 9
  | 8, FA -> 10
  | 8, U -> 12
  | 13, U -> 14
  | 16, E -> 17
  | 16, T -> 4
  | 16, F -> 5
  | 16, CA -> 9
  | 16, FA -> 10
  | 16, U -> 12
  | 20, T -> 21
  | 20, F -> 5
  | 20, CA -> 9
  | 20, FA -> 10
  | 20, U -> 12
  | _ -> failwith (Printf.sprintf "GoTo received invalid args <state=%d, nonterminal=%s>" state (to_string nonterminal))

