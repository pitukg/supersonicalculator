(* Instantiate parser functor with parsing table *)
module SLR_Parser = Parser.Parser (Parsing_table)


(* Command line arguments *)

let valueonly =
  let doc = "Display only evaluated values" in
  Cmdliner.Arg.(value & flag & info ["v"; "valueonly"] ~docv:"VALUEONLY" ~doc)

let runtests =
  let doc = "Run tests before prompting" in
  Cmdliner.Arg.(value & flag & info ["runtests"] ~docv:"RUNTESTS" ~doc)


(* Prompt user to enter expression repeatedly *)
let rec prompt valueonly =
  let () =
    match Lexer.get_token_stream () with
    | Error message -> Printf.eprintf "Lex error: %s\n" message
    | Ok tokens ->
      let result = SLR_Parser.parse Parse_tree.create Parse_tree.compose tokens in
      match result with
      | Ok parse_tree ->
          if valueonly
          then Parse_tree.value parse_tree |> string_of_float |> Printf.printf " = %s\n"
          else Parse_tree.pretty_print parse_tree
      | Error message -> Printf.eprintf "Parse error: %s\n" message
  in
    flush stdout;
    flush stderr;
    prompt valueonly


(* Define tests *)
let test () =
    (* Run parser unit tests *)
    let tests =
      let open Symbol.Token in
      let open Parse_tree in
      (* Assert parse tree is correct for all basic operations *)
      List.map (fun (expected, tokens) ->
        let [@warning "-8"] Ok tree = SLR_Parser.parse create compose tokens in
        assert (expected = to_tree tree)) [
          (Br [Br [Br [Br [Br [Br [Lf (Number 1.)]]]]]], [Number 1.; EOF]);
          (Br [Br [Br [Br [Br [Lf Minus; Br [Lf (Number 1.)]]]]]], [Minus; Number 1.; EOF]);
          (Br [Br [Br [Br [Br [Br [Br [Lf (Number 1.)]]]; Lf Fact]]]], [Number 1.; Fact; EOF]);
          (Br [Br [Br [Lf Cos; Br [Br [Br [Br [Lf (Number 1.)]]]]]]], [Cos; Number 1.; EOF]);
          (Br [Br [Br [Br [Br [Br [Lf (Number 1.)]]]]; Lf Mult; Br [Br [Br [Br [Br [Lf (Number 2.)]]]]]]], [Number 1.; Mult; Number 2.; EOF]);
          (Br [Br [Br [Br [Br [Br [Br [Lf (Number 1.)]]]]]]; Lf Plus; Br [Br [Br [Br [Br [Lf (Number 2.)]]]]]], [Number 1.; Plus; Number 2.; EOF]);
          (Br [Br [Br [Br [Br [Br [Br [Lf (Number 1.)]]]]]]; Lf Minus; Br [Br [Br [Br [Br [Lf (Number 2.)]]]]]], [Number 1.; Minus; Number 2.; EOF]);
        ]
      |> ignore;
      (* Assert expressions are validated by parser *)
      List.map (fun tokens ->
        match SLR_Parser.parse create compose tokens with
        | Ok _ -> ()
        | Error msg -> failwith (Printf.sprintf "Unit test failed with message: %s" msg)) [
          [Number 1.; Plus; Left; Left; Cos; Number 2.; Right; Fact; Right; EOF];
          [Cos; Cos; Number 0.; EOF];
          [Number 1.; Fact; Fact; EOF];
          [Minus; Left; Minus; Number 1.; Minus; Number 2.; Right; EOF];
        ]
      |> ignore;
      (* Assert expressions are invalidated by parser *)
      List.map (fun tokens ->
        match SLR_Parser.parse create compose tokens with
        | Ok _ -> failwith "Unit test failed because an invalid input didn't cause parse error"
        | Error _ -> ()) [
          [Left; Right; EOF];
          [Left; Number 1.; EOF];
          [Number 1.; Mult; Plus; Number 2.; EOF];
          [Minus; Minus; Number 1.; Minus; Number 2.; EOF];
        ]
      |> ignore;
    in
    ignore tests

(* Driver code *)
let main runtests valueonly =
  begin
    if runtests then test () else ()
  end;
  prompt valueonly

(* Execute via Cmdliner *)
let () = Cmdliner.Term.(exit @@ eval ((const main $ runtests $ valueonly), info "supersonicalculator"))

