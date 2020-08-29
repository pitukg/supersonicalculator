(* Set true to display states in the automaton and reductions *)
let debug = false


module Parser (Parsing_table : Parsing_table_intf.Intf) = struct

  (* Describing the state of the automaton at any given step *)
  type 'a world = {
    state : int;
    input : Symbol.Terminal.t list;
    stack : int list;
    accum : 'a list;
  }

  (* Drive LR(0) automaton *)
  let rec do_action create compose world =
    begin
      if debug then begin
        Printf.printf "{state=%d, input=" world.state;
        List.map (fun input -> Symbol.Token.to_string input |> print_string; print_char ',') world.input |> ignore;
        Printf.printf " stack=";
        List.map (fun x -> print_int x; print_char ',') world.stack |> ignore;
        Printf.printf "}\n"
      end
      else ()
    end;
    match world.input with
    | [] -> failwith "End of input reached while still parsing"
    | next_terminal :: rest_of_input ->
      match Parsing_table.action world.state next_terminal with
      | Shift new_state ->
          do_action create compose {
            state=new_state;
            input=rest_of_input;
            stack=(new_state :: world.stack);
            accum=(create next_terminal :: world.accum)
          }
      | Reduce production ->
          let head, num_symbols = Production.get_properties production in
          begin if debug then print_endline ((Symbol.Nonterminal.to_string head) ^ " -> num_symbols=" ^ (string_of_int num_symbols)) else () end;
          let rec pop = function
            | _::xs, y::ys, acc, n when n > 0 -> pop (xs, ys, y::acc, n-1)
            | x::xs, ys, acc, 0 -> x, x::xs, ys, acc
            | _ -> failwith "Automaton state doesn't match prefix" in
          let root_state, stack_after_pop, accum_after_pop, args = pop (world.stack, world.accum, [], num_symbols) in
          let new_state = Parsing_table.goto root_state head in
          let composition = compose production args in
          do_action create compose {
            state=new_state;
            input=world.input;
            stack=(new_state :: stack_after_pop);
            accum=(composition :: accum_after_pop)
          }
      | Accept ->
          Ok (List.hd world.accum)
      | Error ->
          Error (Symbol.Terminal.to_string next_terminal |> Printf.sprintf "Invalid token: %s")

  let parse create compose token_stream =
    try
      do_action create compose {
        state=0;
        input=token_stream;
        stack=[0];
        accum=[];
      }
    with e -> Error (Printexc.to_string e)

end

